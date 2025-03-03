mod cli_options;
mod yml_parser;

use std::collections::HashSet;

use clap::Parser;
use cli_options::CliOptions;
use yml_parser::ConfigYml;

use crate::db::{self, json_db::INTERNAL_DB, DbCred, SqlProvider, TableSchema};

#[derive(Debug)]
pub struct Config {
    db_credentials: DbCred,
    import_schemas: bool,
    import_db: bool,
    export_to_sql: String,
    update_only: bool,
    excluded_tables: Vec<String>,
    included_tables: Vec<String>,
    ignored_tables: Vec<String>,
}

impl Config {
    pub fn load() -> Config {
        let args = std::env::args();
        let file_config = ConfigYml::parse();
        Self::build(args, file_config)
    }

    fn build(args: impl Iterator<Item = String>, file_config: ConfigYml) -> Self {
        let cli_options = CliOptions::parse_from(args);

        Config {
            import_schemas: cli_options.import_schema,
            import_db: cli_options.import,
            export_to_sql: cli_options.export,
            update_only: cli_options.update_only,
            excluded_tables: vec![file_config.exclude, cli_options.exclude].concat(),
            included_tables: vec![file_config.include, cli_options.include].concat(),
            ignored_tables: file_config.exportignore,
            db_credentials: file_config.db,
        }
    }
}

#[derive(Debug, PartialEq)]
pub enum Task {
    ImportSchema {
        db_credentials: DbCred,
    },
    ImportDb {
        db_credentials: DbCred,
        tables_to_import: Vec<TableSchema>,
    },
    ExportToSql {
        sql_provider: SqlProvider,
        tables_to_export: Vec<TableSchema>,
    },
}

impl Task {
    pub fn build(config: Config) -> Self {
        if config.import_schemas {
            let task = Task::ImportSchema {
                db_credentials: config.db_credentials,
            };
            return task;
        }

        if config.import_db {
            let task = Task::ImportDb {
                tables_to_import: INTERNAL_DB.get_filtered_schemas(
                    config.included_tables.iter().map(String::as_str).collect(),
                    config.excluded_tables.iter().map(String::as_str).collect(),
                    config.ignored_tables.iter().map(String::as_str).collect(),
                    true,
                ),
                db_credentials: config.db_credentials,
            };
            return task;
        }

        let task = Task::ExportToSql {
            sql_provider: match config.export_to_sql.as_str() {
                "sqlite" => SqlProvider::Sqlite,
                "mysql" => SqlProvider::MySql,
                s => panic!(r#"Export to "{}" is not defined"#, s),
            },
            tables_to_export: INTERNAL_DB.get_filtered_schemas(
                config.included_tables.iter().map(String::as_str).collect(),
                config.excluded_tables.iter().map(String::as_str).collect(),
                config.ignored_tables.iter().map(String::as_str).collect(),
                config.update_only,
            ),
        };
        return task;
    }

    pub fn execute(&self) {
        match self {
            Task::ImportSchema { db_credentials } => {
                let schemas = get_db(db_credentials).get_all_schemas();
                INTERNAL_DB.replace_schemas(schemas);
            }
            Task::ImportDb {
                db_credentials,
                tables_to_import,
            } => {
                let db = get_db(db_credentials);
                let table_count = tables_to_import.len();
                let all_schemas: HashSet<_> =
                    HashSet::from_iter(INTERNAL_DB.get_all_schemas().iter());
                (&all_schemas - &HashSet::from_iter(tables_to_import))
                    .iter()
                    .for_each(|s| println!("Found ignored table: {}", s.name));
                for (i, schema) in tables_to_import.iter().enumerate() {
                    let texts = db.get_table_as_json(&schema.name);
                    INTERNAL_DB.replace_table(texts, schema);
                    println!("Finished {} of {} ({})", i + 1, table_count, schema.name);
                }
            }
            Task::ExportToSql {
                sql_provider,
                tables_to_export,
            } => {
                let all_schemas: HashSet<_> =
                    HashSet::from_iter(INTERNAL_DB.get_all_schemas().iter());
                let ignored_tables =
                    &all_schemas - &HashSet::from_iter(tables_to_export);
                let mut ignored_tables = ignored_tables.iter().collect::<Vec<_>>();
                ignored_tables.sort_by(|a, b| a.name.to_lowercase().cmp(&b.name.to_lowercase()));
                ignored_tables
                    .iter()
                    .for_each(|s| println!("Found ignored table: {}", s.name));
                INTERNAL_DB.export_to_sql(tables_to_export, sql_provider);
            }
        }
    }
}

fn get_db(db_credentials: &DbCred) -> Box<dyn db::Db> {
    let db: Box<dyn db::Db> = match db_credentials {
        DbCred::Mysql(cred) => Box::new(db::mysql::Mysql::open(cred)),
        DbCred::Sqlite(cred) => Box::new(db::sqlite::Sqlite::open(cred)),
    };
    db
}

#[cfg(test)]
mod tests {
    use crate::db::SqliteCredentials;

    use super::*;
    #[test]
    /// When no arguments are given, export MySQL is chosen
    fn no_args_export_mysql() {
        let args = vec![String::new()].into_iter();
        let file_config = ConfigYml {
            db: DbCred::Sqlite(SqliteCredentials {
                file_path: String::new(),
            }),
            include: vec![],
            exclude: vec![],
            exportignore: vec![],
        };

        let config = Config::build(args, file_config);
        assert_eq!(config.export_to_sql, "mysql");
    }
}
