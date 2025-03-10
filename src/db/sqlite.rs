use std::{collections::BTreeMap, path::Path};

use aho_corasick::AhoCorasick;
use rusqlite::{
    params,
    types::{Type, ValueRef},
    Connection, Row,
};
use serde_json::Value;

use super::{Db, SqliteCredentials, TableColumn, TableIndex, TableSchema};

pub struct Sqlite {
    connection: Connection,
}

impl Sqlite {
    pub fn open(credentials: &SqliteCredentials) -> Self {
        let path_to_db = Path::new(&credentials.file_path);
        if !path_to_db.exists() {
            panic!(
                "The SQLite DB at {} does not exist.",
                path_to_db.to_string_lossy()
            );
        }
        Self {
            connection: Connection::open(path_to_db).unwrap(),
        }
    }

    pub fn get_all_table_names(&self) -> Vec<String> {
        let query =
            "select name from sqlite_master where `type` = 'table' and name not like 'sqlite_%'";
        let mut stmt = self.connection.prepare(query).unwrap();
        let mut rows = stmt.query([]).unwrap();
        let mut table_names: Vec<String> = Vec::new();
        while let Some(&row) = rows.next().unwrap().as_ref() {
            let v = row.get_ref(0).unwrap();
            table_names.push(v.as_str().unwrap().to_owned());
        }
        table_names
    }

    fn get_schema(&self, table_name: &str) -> TableSchema {
        let connection = &self.connection;
        let mut stmt = connection
            .prepare(&format!("PRAGMA table_info('{}')", table_name))
            .unwrap();
        let mut rows = stmt.query(params![]).unwrap();
        let mut columns: Vec<TableColumn> = Vec::new();
        while let Some(&row) = rows.next().unwrap().as_ref() {
            let name = row.get_ref_unwrap(1).as_str().unwrap().to_string();
            let mut sql_type = row.get_ref_unwrap(2).as_str().unwrap().to_lowercase();
            if sql_type.starts_with("unsigned") {
                let first = sql_type.split(" ").next().unwrap();
                let last = sql_type.split(" ").last().unwrap();
                sql_type = format!("{} {}", last, first);
            }
            if sql_type == "integer" {
                println!(
                    "Cannot infer specific type from INTEGER for \"{}.{}\". Default to bigint.",
                    table_name, name
                );
                sql_type = "bigint(20)".to_string();
            }
            let not_null = row.get_ref_unwrap(3).as_i64().unwrap() == 1;
            let is_primary = row.get_ref_unwrap(5).as_i64().unwrap() == 1;
            let auto_increment = is_primary && self.is_primary_auto_increment(table_name);
            let default_value = match row.get::<usize, Option<String>>(4).unwrap() {
                Some(s) => s,
                None => "NULL".to_string(),
            };
            let col = TableColumn {
                name,
                sql_type,
                not_null,
                is_primary: is_primary,
                auto_increment: auto_increment,
                default_value
            };
            columns.push(col);
        }
        TableSchema {
            name: table_name.to_string(),
            is_static: false,
            columns,
            indexes: self.read_indexes(table_name),
        }
    }

    fn read_indexes(&self, table_name: &str) -> Vec<TableIndex> {
        let query = &format!("select name from sqlite_schema where `type`='index' and name not like 'sqlite_%%' and tbl_name='{}'", table_name);
        let mut stmt = self.connection.prepare(query).unwrap();
        let mut results = stmt.query([]).unwrap();
        let mut indexes: Vec<TableIndex> = Vec::new();
        while let Some(&row) = results.next().unwrap().as_ref() {
            let index_name = row.get_ref_unwrap(0).as_str().unwrap();
            let mut stmt = self
                .connection
                .prepare(&format!("PRAGMA index_info('{}')", index_name))
                .unwrap();
            let mut index_query_res = stmt.query([]).unwrap();

            while let Some(&row) = index_query_res.next().unwrap().as_ref() {
                let index = TableIndex {
                    name: index_name.to_string(),
                    column: row.get_ref_unwrap(2).as_str().unwrap().to_string(),
                    unique: self.is_index_unique(index_name, table_name),
                };
                indexes.push(index);
            }
        }
        indexes.sort_by(|a, b| a.name.to_lowercase().cmp(&b.name.to_lowercase()));
        return indexes;
    }

    fn is_index_unique(&self, index_name: &str, table_name: &str) -> bool {
        let mut stmt = self
            .connection
            .prepare(&format!("PRAGMA INDEX_LIST('{}')", table_name))
            .unwrap();
        let mut rows = stmt.query([]).unwrap();
        while let Some(&row) = rows.next().unwrap().as_ref() {
            if row.get_ref_unwrap(1).as_str() == Ok(index_name)
                && row.get_ref_unwrap(2).as_i64() == Ok(1)
            {
                return true;
            }
        }
        return false;
    }

    fn is_primary_auto_increment(&self, table_name: &str) -> bool {
        let mut stmt = self
            .connection
            .prepare(&format!(
                "select sql from sqlite_master where `type`='table' and tbl_name = '{}'",
                table_name
            ))
            .unwrap();
        let mut rows = stmt.query([]).unwrap();
        if let Some(&row) = rows.next().unwrap().as_ref() {
            return row
                .get_ref_unwrap(0)
                .as_str()
                .unwrap()
                .contains("AUTOINCREMENT");
        }
        panic!("AUTOINCREMENT could not be determined");
    }
}

impl Db for Sqlite {
    fn get_all_schemas(&self) -> Vec<TableSchema> {
        let mut table_names: Vec<String> = self
            .get_all_table_names()
            .iter()
            .map(|t| t.to_string())
            .collect();
        table_names.sort();
        let mut schemas = table_names
            .iter()
            .map(|tn| self.get_schema(tn))
            .collect::<Vec<TableSchema>>();
        schemas.sort_by(|a, b| a.name.to_lowercase().cmp(&b.name.to_lowercase()));
        schemas
    }

    fn get_table_as_json(&self, table_name: &str) -> Vec<String> {
        let connection = &self.connection;
        let mut results = vec![];

        for query in super::get_query_strings_for_table(table_name) {
            let mut stmt = connection.prepare(&query).unwrap();
            let mut rows = stmt.query([]).unwrap();
            let mut json_values: Vec<_> = Vec::new();

            while let Some(&row) = rows.next().unwrap().as_ref() {
                json_values.push(row_to_map(row));
            }

            if json_values.len() == 0 {
                continue;
            }

            let json_string = serde_json::to_string_pretty(&json_values).unwrap();
            results.push(escape_special_chars(&json_string))
        }

        return results;

        fn escape_special_chars(input: &str) -> String {
            let unescaped_strings = &["\\\\"];
            let replace_with = &["\\"];
            let replacer = AhoCorasick::new(unescaped_strings).unwrap();
            replacer.replace_all(input, replace_with)
        }

        fn convert_value_ref_to_json(val: ValueRef) -> Value {
            match val.data_type() {
                Type::Text => serde_json::json!(val.as_str().unwrap()),
                Type::Integer => serde_json::json!(val.as_i64().unwrap()),
                Type::Real => {
                    let float = val.as_f64().unwrap();
                    match float.fract() {
                        0.0 => serde_json::json!(float as i64),
                        _ => serde_json::json!(float),
                    }
                }
                Type::Null => Value::Null,
                t => panic!("{:#?} not implemented", t),
            }
        }

        fn row_to_map(row: &Row) -> BTreeMap<String, Value> {
            let mut tuple_array: Vec<(String, Value)> = Vec::new();
            let mut ctr = 0;
            while let Ok(val) = row.get_ref(ctr) {
                tuple_array.push((
                    row.as_ref().column_name(ctr).unwrap().to_string(),
                    convert_value_ref_to_json(val),
                ));
                ctr += 1;
            }
            tuple_array.sort_by(|(a, _), (b, _)| a.cmp(b));
            tuple_array
                .into_iter()
                .map(|(a, b)| (a, b))
                .collect::<BTreeMap<String, Value>>()
        }
    }
}
