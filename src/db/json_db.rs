use std::{
    fs::OpenOptions,
    io::Write,
    sync::{LazyLock, OnceLock},
};

use serde::Serialize;
use serde_json::Value;

use super::{SqlProvider, TableSchema};

pub static INTERNAL_DB: LazyLock<JsonDB> = LazyLock::new(|| JsonDB::new());

pub struct JsonDB {
    location: String,
    schemas: OnceLock<Vec<TableSchema>>,
}

impl JsonDB {
    const DATA_FOLDER: &str = "./data/";
    const SCHEMAS_FILE_NAME: &str = "_TableSchemas.json";
    const STATIC_TABLES_LIST_FILE_NAME: &str = "_StaticTables.json";

    fn new() -> Self {
        Self {
            location: Self::DATA_FOLDER.to_string(),
            schemas: OnceLock::new(),
        }
    }

    pub fn get_all_schemas(&self) -> &Vec<TableSchema> {
        &self.schemas.get_or_init(|| self.read_all_schemas())
    }

    pub fn get_static_table_names(&self) -> Vec<String> {
        let path = self.location.to_string() + Self::STATIC_TABLES_LIST_FILE_NAME;
        let json_str = std::fs::read_to_string(path).unwrap();
        serde_json::from_str(&json_str).unwrap()
    }

    pub fn export_to_sql(&self, schemas: &Vec<&TableSchema>, db_provider: &SqlProvider) {
        let mut file = OpenOptions::new()
            .truncate(true)
            .create(true)
            .write(true)
            .open("public-db.sql")
            .unwrap();
        for s in schemas {
            file.write_all(Self::convert_to_sql_text(s, db_provider).as_bytes())
                .expect("Failed to write file");
        }
    }

    pub fn replace_schemas(&self, schemas: Vec<TableSchema>) {
        Self::write_as_json_file(
            &schemas,
            &format!("{}{}", self.location, Self::SCHEMAS_FILE_NAME),
        );
    }

    pub fn replace_table(&self, texts: Vec<String>, schema: &TableSchema) {
        if texts.len() == 1 {
            let file_path = &format!("{}{}.json", self.location, schema.name);
            Self::write_text_to_file(texts.get(0).unwrap(), file_path);
        } else {
            for i in 0..texts.len() {
                let file_path = &format!("{}{}.{}.json", self.location, schema.name, i);
                Self::write_text_to_file(texts.get(i).unwrap(), &file_path);
            }
        }
    }

    fn convert_to_sql_text(table_schema: &TableSchema, db_provider: &SqlProvider) -> String {
        let mut sql = String::new();
        sql.push_str(&db_provider.table_create_statement(table_schema));
        sql.push_str("\n");
        let columns = table_schema
            .columns
            .iter()
            .map(|c| format!("`{}`", c.name))
            .collect::<Vec<_>>()
            .join(", ");
        let insert_stmt = format!(
            "INSERT INTO `{}` ({}) VALUES \n",
            table_schema.name, columns
        );
        let path = format!("{}{}.json", Self::DATA_FOLDER, table_schema.name);
        let data = match std::fs::read_to_string(&path) {
            Ok(s) => {
                let json_value: Vec<Value> = serde_json::from_str(&s).unwrap();
                json_value
            }
            Err(_) => {
                let mut data_collection = Vec::<Value>::new();
                let mut ctr = 0;
                let mut path = format!("{}{}.{}.json", Self::DATA_FOLDER, table_schema.name, ctr);
                while let Ok(s) = std::fs::read_to_string(&path) {
                    let mut json_value: Vec<Value> = serde_json::from_str(&s).unwrap();
                    data_collection.append(&mut json_value);
                    ctr += 1;
                    path = format!("{}{}.{}.json", Self::DATA_FOLDER, table_schema.name, ctr);
                }
                data_collection
            }
        };
        let mut value_lines: Vec<String> = vec![];
        for (i, row) in data.iter().enumerate() {
            if i % 2500 == 0 {
                sql.push_str(&insert_stmt);
            }
            let mut values = Vec::<String>::new();
            let row_obj = row.as_object().unwrap();
            for col in &table_schema.columns {
                let val = &row_obj[&col.name];
                values.push(Self::json_value_to_string(&val));
            }
            value_lines.push(format!("\t({})", values.join(", ")));
            if i % 2500 == 2499 {
                sql.push_str(&value_lines.join(",\n"));
                sql.push_str(";\n");
                value_lines.clear();
            }
        }
        sql.push_str(&value_lines.join(",\n"));
        if !value_lines.is_empty() {
            sql.push_str(";\n\n");
        }
        sql
    }

    fn json_value_to_string(val: &Value) -> String {
        match val {
            Value::String(s) => {
                let verbose_string = Value::String(s.to_string()).to_string();
                format!(
                    "'{}'",
                    verbose_string[1..verbose_string.len() - 1]
                        .replace("'", "''")
                        .replace("\\\"", "\"")
                )
            }
            Value::Number(n) => {
                let result = n.as_f64().unwrap();
                if result >= 1e06 {
                    let e = result.log10().floor();
                    let decimal_base: f64 = 10.0;
                    let b = result / decimal_base.powf(e);
                    return format!("{b}e+{e:02}");
                }
                format!("{result}")
            }
            Value::Null => String::from("NULL"),
            Value::Bool(b) => b.to_string(),
            Value::Array(_) => todo!(),
            Value::Object(_) => todo!(),
        }
    }

    fn read_all_schemas(&self) -> Vec<TableSchema> {
        let path = self.location.clone() + Self::SCHEMAS_FILE_NAME;
        let json_str = std::fs::read_to_string(path).unwrap();
        let schemas: Vec<TableSchema> = serde_json::from_str(&json_str).unwrap();
        let static_table_names = self.get_static_table_names();

        return schemas
            .into_iter()
            .map(|s| {
                if static_table_names.contains(&s.name) {
                    return s.as_static();
                } else {
                    return s;
                }
            })
            .collect::<Vec<_>>();
    }

    fn write_as_json_file<T>(json: &T, file_path: &str)
    where
        T: ?Sized + Serialize,
    {
        let text = serde_json::to_string_pretty(json).unwrap();
        Self::write_text_to_file(&text, file_path);
    }

    fn write_text_to_file(text: &str, file_path: &str) {
        let mut file = OpenOptions::new()
            .create(true)
            .truncate(true)
            .write(true)
            .open(file_path)
            .unwrap();
        file.write_all(text.as_bytes())
            .expect("Failed to write file");
    }
}
