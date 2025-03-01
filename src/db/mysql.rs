use super::json_db::INTERNAL_DB;
use super::{Db, MySqlCredentials, TableColumn, TableIndex, TableSchema};
use aho_corasick::AhoCorasick;
use mysql::{consts::ColumnType, prelude::Queryable, Pool, Row};
use std::{collections::BTreeMap, str};

pub struct Mysql {
    database_name: String,
    pool: Pool,
}

impl Mysql {
    pub fn open(credentials: &MySqlCredentials) -> Self {
        let MySqlCredentials {
            user,
            password,
            host,
            port,
            database,
        } = &credentials;
        let host = if host == "localhost" {
            "127.0.0.1"
        } else {
            host
        }; // Fix Docker
        let connection_string = format!("mysql://{user}:{password}@{host}:{port}/{database}");
        let pool = Pool::new(connection_string.as_str()).unwrap();
        Self {
            database_name: database.to_string(),
            pool,
        }
    }

    pub fn get_all_table_names(&self) -> Vec<String> {
        let conn = self.pool.get_conn().unwrap();
        let query = format!("SELECT TABLE_NAME FROM information_schema.tables WHERE TABLE_SCHEMA = '{}' ORDER BY TABLE_NAME", self.database_name);
        let rows = conn.unwrap().query_map(query, |s: String| s).unwrap();
        rows
    }

    fn get_schema(&self, table_name: &str) -> TableSchema {
        let mut conn = self.pool.get_conn().unwrap();
        let query = format!("DESCRIBE {}", table_name);
        let rows: Vec<Row> = conn.query(query).unwrap();
        let mut columns: Vec<TableColumn> = vec![];
        for row in rows {
            let col = TableColumn {
                name: row.get(0).unwrap(),
                sql_type: Mysql::format_sql_type(row.get(1).unwrap()),
                not_null: row.get(2) == Some("NO".to_string()),
                is_primary: row.get(3) == Some("PRI".to_string()),
                auto_increment: row.get(5) == Some("auto_increment".to_string()),
                default_value: match row.get::<Option<String>, _>(4).unwrap() {
                    Some(s) => s,
                    None => "NULL".to_string(),
                },
            };
            columns.push(col);
        }

        let query = format!("SHOW INDEXES FROM {}", table_name);
        let rows: Vec<Row> = conn.query(query).unwrap();
        let mut indexes: Vec<TableIndex> = vec![];
        for row in rows {
            let name: String = row.get(2).unwrap();
            if name == "PRIMARY" {
                continue;
            }
            let index = TableIndex {
                unique: name.starts_with("U_"),
                name,
                column: row.get(4).unwrap(),
            };
            indexes.push(index);
        }
        indexes.sort_by(|a, b| a.name.to_lowercase().cmp(&b.name.to_lowercase()));
        TableSchema {
            name: table_name.to_string(),
            is_static: false,
            columns,
            indexes,
        }
    }

    fn format_sql_type(sql_type: String) -> String {
        let formatted_sql_type = match sql_type.as_str() {
            "int" => "int(11)",
            "bigint" => "bigint(20)",
            "int unsigned" => "int(10) unsigned",
            "smallint" => "smallint(6)",
            "tinyint" => "tinyint(3)",
            "smallint unsigned" => "smallint(5) unsigned",
            "tinyint unsigned" => "tinyint(3) unsigned",
            s => s,
        };
        String::from(formatted_sql_type)
    }
}

impl Db for Mysql {
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
        let schemas = INTERNAL_DB.get_all_schemas();
        let primary_col = &schemas
            .iter()
            .find(|s| s.name.as_str() == table_name)
            .unwrap()
            .columns
            .iter()
            .find(|c| c.is_primary)
            .unwrap()
            .name;
        let query_strings = super::get_query_strings_for_table(table_name);

        let mut conn = self.pool.get_conn().unwrap();
        let mut results: Vec<_> = vec![];
        for query in &query_strings {
            let mut json_values: Vec<_> = Vec::new();
            let rows: Vec<mysql::Row> = conn.query(query).unwrap();
            for row in rows {
                json_values.push(row_to_map(&row));
            }
            let compare_json_value = |a: &serde_json::Value, b: &serde_json::Value| match a {
                serde_json::Value::String(v) => {
                    v.to_lowercase().cmp(&b.as_str().unwrap().to_lowercase())
                }
                serde_json::Value::Number(v) => v.as_f64().unwrap().total_cmp(&b.as_f64().unwrap()),
                _ => panic!(""),
            };
            json_values.sort_by(|a, b| compare_json_value(&a[primary_col], &b[primary_col]));

            if json_values.len() == 0 {
                continue;
            }
            results.push(escape_special_chars(
                &serde_json::to_string_pretty(&json_values).unwrap(),
            ));
        }

        return results;

        fn escape_special_chars(input: &str) -> String {
            let unescaped_strings = &["&", "<", ">", "\\\\r"];
            let replace_with = &["\\u0026", "\\u003c", "\\u003e", "\\r"];
            let replacer = AhoCorasick::new(unescaped_strings).unwrap();
            replacer.replace_all(input, replace_with)
        }

        fn row_to_map(row: &mysql::Row) -> BTreeMap<String, serde_json::Value> {
            let mut tuple_array: Vec<(String, serde_json::Value)> = Vec::with_capacity(row.len());
            for (i, col) in row.columns().iter().enumerate() {
                let val = match col.column_type() {
                    ColumnType::MYSQL_TYPE_LONG
                    | ColumnType::MYSQL_TYPE_LONGLONG
                    | ColumnType::MYSQL_TYPE_SHORT
                    | ColumnType::MYSQL_TYPE_TINY => {
                        serde_json::json!(row.get::<i64, _>(i))
                    }
                    ColumnType::MYSQL_TYPE_VAR_STRING
                    | ColumnType::MYSQL_TYPE_DATETIME
                    | ColumnType::MYSQL_TYPE_BLOB => {
                        serde_json::json!(row.get::<Option<String>, _>(i))
                    }
                    ColumnType::MYSQL_TYPE_DOUBLE | ColumnType::MYSQL_TYPE_FLOAT => {
                        let float = row.get::<f64, _>(i).unwrap();
                        match float.fract() {
                            0.0 => serde_json::json!(float as i64),
                            _ => serde_json::json!(row.get::<f64, _>(i)),
                        }
                    }
                    _ => panic!(
                        "Invalid type {:?} in Schema {} for Column {}",
                        col.column_type(),
                        col.schema_str(),
                        col.name_str()
                    ),
                };
                tuple_array.push((col.name_str().to_string(), val));
            }
            tuple_array
                .into_iter()
                .collect::<BTreeMap<String, serde_json::Value>>()
        }
    }
}
