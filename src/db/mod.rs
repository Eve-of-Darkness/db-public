use std::hash::Hash;

use json_db::INTERNAL_DB;
use serde::{ser::SerializeStruct, Deserialize, Serialize, Serializer};

pub mod json_db;
pub mod mysql;
pub mod sqlite;

pub trait Db {
    fn get_all_schemas(&self) -> Vec<TableSchema>;
    fn get_table_as_json(&self, table_name: &str) -> Vec<String>;
}

fn get_query_strings_for_table(table_name: &str) -> Vec<String> {
    let schemas = INTERNAL_DB.get_all_schemas();
    let schema = schemas
        .iter()
        .find(|s| s.name.as_str() == table_name)
        .unwrap();
    let column_names = &schema
        .columns
        .iter()
        .map(|s| format!("`{}`", s.name))
        .collect::<Vec<String>>();
    match table_name.to_lowercase().as_str() {
        "mob" => (0..6)
            .map(|i| {
                format!(
                    "SELECT {0} FROM Mob \
JOIN Regions on Mob.Region = Regions.RegionId \
WHERE Regions.Expansion = {1}",
                    column_names
                        .iter()
                        .map(|s| format!("Mob.{}", s))
                        .collect::<Vec<_>>()
                        .join(","),
                    i
                )
            })
            .collect(),
        _ => vec![format!(
            "SELECT {0} FROM {1}",
            column_names.join(","),
            schema.name
        )],
    }
}



#[derive(Serialize, Deserialize, Debug, Clone, PartialEq)]
#[serde(untagged)]
pub enum DbCred {
    Mysql(MySqlCredentials),
    Sqlite(SqliteCredentials),
}

#[derive(Serialize, Deserialize, Debug, Clone, PartialEq)]
pub struct MySqlCredentials {
    pub host: String,
    pub user: String,
    pub password: String,
    pub database: String,
    pub port: u16,
}

#[derive(Serialize, Deserialize, Debug, Clone, PartialEq)]
pub struct SqliteCredentials {
    pub file_path: String,
}

#[derive(Debug, PartialEq)]
pub enum SqlProvider {
    MySql,
    Sqlite,
}

impl SqlProvider {
    fn table_create_statement(&self, schema: &TableSchema) -> String {
        match &self {
            SqlProvider::MySql => {
                let mut stmt = String::new();
                if schema.is_static() {
                    stmt.push_str(&format!("DROP TABLE IF EXISTS `{}`;\n\n", schema.name));
                    stmt.push_str(&format!("CREATE TABLE `{}` (\n", schema.name));
                } else {
                    stmt.push_str(&format!("CREATE TABLE IF NOT EXISTS `{}` (\n", schema.name));
                }

                for col in &schema.columns {
                    stmt.push_str(&format!("  `{}` {}", col.name, col.sql_type));
                    if col.not_null {
                        stmt += " NOT NULL";
                    }
                    // text can't have a default value on MySQL
                    if !col.auto_increment && col.get_default_value() != "" && col.sql_type != "text" {
                        stmt += &format!(" DEFAULT {}", col.get_default_value());
                    }
                    if col.auto_increment {
                        stmt += " AUTO_INCREMENT";
                    }
                    stmt += ",\n"
                }
                stmt += &format!("  PRIMARY KEY (`{}`),\n", schema.primary_column().name);

                let mut previous_index_name = "";
                for i in &schema.indexes {
                    if previous_index_name == i.name {
                        stmt = stmt[..stmt.len() - 3].to_string();
                        stmt += &format!(",`{}`),\n", i.column);
                        continue;
                    }
                    stmt += "  ";
                    if i.unique {
                        stmt += "UNIQUE "
                    }
                    stmt += &format!("KEY `{}` (`{}`),\n", i.name, i.column);
                    previous_index_name = &i.name
                }
                stmt = format!("{}\n", &stmt[..stmt.len() - 2]);
                stmt += ") ENGINE=InnoDB";
                stmt += " DEFAULT CHARSET utf8 COLLATE utf8_general_ci;\n";

                stmt
            }
            SqlProvider::Sqlite => {
                let mut stmt = String::new();
                if schema.is_static() {
                    stmt.push_str(&format!("DROP TABLE IF EXISTS `{}`;\n\n", schema.name));
                    stmt.push_str(&format!("CREATE TABLE `{}` (", schema.name));
                } else {
                    stmt.push_str(&format!("CREATE TABLE IF NOT EXISTS `{}` (", schema.name));
                }

                for col in &schema.columns {
                    let sql_type_is_number = col.is_number();
                    let sql_type_is_text =
                        col.sql_type.starts_with("varchar") || col.sql_type == "text";
                    if col.is_primary && sql_type_is_number && col.auto_increment {
                        stmt += &("`".to_string() + &col.name + "` INTEGER");
                    } else {
                        let mut sql_type = col.sql_type.split(" ").collect::<Vec<&str>>();
                        if sql_type.len() == 2 {
                            //int(11) unsigned -> unsigned int(11)
                            sql_type.reverse()
                        }
                        stmt += &format!("`{}` {}", col.name, sql_type.join(" ").to_uppercase())
                    }
                    if col.not_null {
                        stmt += " NOT NULL"
                    }
                    if col.is_primary && col.auto_increment {
                        stmt += " PRIMARY KEY AUTOINCREMENT"
                    } else {
                        let default_value = col.get_default_value();

                        stmt += " DEFAULT ";
                        if default_value == "" {
                            stmt += "NULL"
                        } else if col.is_number() {
                            stmt += default_value.trim_matches('\'')
                        } else {
                            stmt += default_value
                        }
                    }

                    if sql_type_is_text {
                        stmt += " COLLATE NOCASE"
                    }
                    stmt += ", \n"
                }

                if !schema.primary_column().sql_type.contains("int(")
                    || !schema.primary_column().auto_increment
                {
                    stmt += &format!("PRIMARY KEY (`{}`));\n", schema.primary_column().name)
                } else {
                    stmt = format!("{});\n", stmt[..stmt.len() - 3].to_string())
                }

                let mut previous_index_name = "";
                for i in &schema.indexes {
                    if previous_index_name == i.name {
                        stmt = stmt[..stmt.len() - 3].to_string();
                        stmt += &format!(", `{}`);\n", i.column);
                        continue;
                    }
                    stmt += "CREATE";
                    if i.unique {
                        stmt += " UNIQUE";
                    }
                    stmt += &format!(
                        " INDEX `{}` ON `{}` (`{}`);\n",
                        i.name, schema.name, i.column
                    );
                    previous_index_name = &i.name
                }
                stmt
            }
        }
    }
}

#[derive(Serialize, Deserialize, Debug, Clone)]
#[serde(rename_all = "PascalCase")]
pub struct TableSchema {
    pub name: String,
    pub columns: Vec<TableColumn>,
    #[serde(skip)]
    pub is_static: bool,
    #[serde(default)]
    #[serde(skip_serializing_if = "std::vec::Vec::is_empty")]
    pub indexes: Vec<TableIndex>,
}

impl Eq for TableSchema {
}

impl PartialEq for TableSchema {
    fn eq(&self, other: &Self) -> bool {
        self.name.eq_ignore_ascii_case(&other.name)
    }
}

impl Hash for TableSchema {
    fn hash<H: std::hash::Hasher>(&self, state: &mut H) {
        self.name.to_ascii_lowercase().hash(state);
    }
}

impl TableSchema {
    pub fn primary_column(&self) -> &TableColumn {
        self.columns
            .iter()
            .find(|c| c.is_primary)
            .expect(&format!("Primary column for {} missing", self.name))
    }

    pub fn is_static(&self) -> bool {
        self.is_static
    }

    fn as_static(mut self) -> Self {
        self.is_static = true;
        self
    }
}

#[derive(Deserialize, Debug, Clone)]
#[serde(rename_all = "PascalCase")]
pub struct TableColumn {
    pub name: String,
    pub sql_type: String,
    #[serde(default)]
    not_null: bool,
    #[serde(default)]
    pub is_primary: bool,
    #[serde(default)]
    auto_increment: bool,
    #[serde(default)]
    default_value: String,
}

impl Serialize for TableColumn {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        let mut state = serializer.serialize_struct("TableColumn", 6)?;
        state.serialize_field("Name", &self.name).unwrap();
        state.serialize_field("SqlType", &self.sql_type).unwrap();
        if self.not_null {
            state.serialize_field("NotNull", &self.not_null).unwrap();
        }
        if self.is_primary {
            state
                .serialize_field("IsPrimary", &self.is_primary)
                .unwrap();
        }
        if self.auto_increment {
            state
                .serialize_field("AutoIncrement", &self.auto_increment)
                .unwrap();
        }
        if !self.has_implicit_default() {
            state
                .serialize_field("DefaultValue", &self.default_value)
                .unwrap();
        }
        state.end()
    }
}

impl TableColumn {
    fn get_default_value(&self) -> &str {
        if !(self.default_value == "" || self.default_value.to_lowercase() == "null") {
            return &self.default_value;
        }

        if !self.not_null {
            return "";
        } else if self.is_number() {
            return "0";
        } else if self.sql_type == "datetime" {
            return "'2000-01-01 00:00:00'";
        } else {
            return "''";
        }
    }

    fn has_implicit_default(&self) -> bool {
        match self.default_value.as_str() {
            "NULL" => true,
            "0" => self.is_number(),
            x if x.contains("2000-01-01 00:00:00") => self.sql_type == "datetime",
            "" | "''" => true,
            _ => false,
        }
    }

    fn is_number(&self) -> bool {
        return self.sql_type.contains("int")
            || self.sql_type == "double"
            || self.sql_type == "float"
            || self.sql_type == "real";
    }
}

#[derive(Serialize, Deserialize, Debug, Clone)]
#[serde(rename_all = "PascalCase")]
pub struct TableIndex {
    name: String,
    column: String,
    #[serde(default)]
    #[serde(skip_serializing_if = "_is_false")]
    unique: bool,
}

fn _is_false(v: &bool) -> bool {
    let def: bool = Default::default();
    *v == def
}
