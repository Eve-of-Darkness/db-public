mod cli_options;
mod yml_parser;

use std::{collections::HashSet, process};

use cli_options::CliOptions;
use yml_parser::ConfigYml;

use crate::db::{self, json_db::INTERNAL_DB, DbCred, SqlProvider, TableSchema};

#[derive(Debug)]
pub struct Config<'a> {
    task: Task<'a>,
}

impl<'a> Config<'a> {
    pub fn load() -> Config<'a> {
        let args: Vec<String> = std::env::args().collect();
        let args = args.iter().map(|arg| arg.as_str()).collect::<Vec<_>>();
        let file_config = ConfigYml::parse();
        match Self::build(&args, file_config) {
            Ok(c) => c,
            Err(msg) => {
                eprintln!("{msg}\n");
                eprint!("{}", CliOptions::usage_text(args[0]));
                process::exit(2);
            }
        }
    }

    fn build(args: &Vec<&str>, file_config: ConfigYml) -> Result<Config<'a>, String> {
        let cli_options = match CliOptions::new(args) {
            Ok(opts) => opts,
            Err(msg) => return Err(msg),
        };

        if cli_options.help {
            let task = Task::Help {
                text: CliOptions::usage_text(&args[0]),
            };
            return Ok(Config { task });
        }

        if cli_options.import_schema {
            let task = Task::ImportSchema {
                db_credentials: file_config.db,
            };
            return Ok(Config { task });
        }

        if cli_options.import {
            let task = Task::ImportDb {
                tables_to_import: Self::get_selected_table_schemas(
                    &cli_options,
                    &file_config,
                    true,
                ),
                db_credentials: file_config.db,
            };
            return Ok(Config { task });
        }

        let task = Task::ExportToSql {
            sql_provider: match cli_options.export.as_str() {
                "sqlite" => SqlProvider::Sqlite,
                "mysql" => SqlProvider::MySql,
                s => panic!(r#"Export to "{}" is not defined"#, s),
            },
            tables_to_export: Self::get_selected_table_schemas(
                &cli_options,
                &file_config,
                cli_options.update_only,
            ),
        };
        return Ok(Config { task });
    }

    fn get_selected_table_schemas(
        cli_options: &CliOptions,
        file_config: &ConfigYml,
        only_static_by_default: bool,
    ) -> Vec<&'a TableSchema> {
        let all_schemas = INTERNAL_DB.get_all_schemas();

        let included_table_names: Vec<_> = cli_options
            .include
            .iter()
            .chain(&file_config.include)
            .map(|t| t.to_lowercase())
            .collect();

        if included_table_names.contains(&String::from("all")) {
            return all_schemas.iter().collect();
        }

        let excluded_table_names: Vec<_> = cli_options
            .exclude
            .iter()
            .chain(&file_config.exclude)
            .chain(&file_config.exportignore)
            .map(|t| t.to_lowercase())
            .collect();

        if excluded_table_names.contains(&String::from("all")) {
            return all_schemas
                .into_iter()
                .filter(|s| included_table_names.contains(&s.name.to_lowercase()))
                .collect::<Vec<_>>();
        }

        let ignored_when_importing = |s: &TableSchema| !s.is_static() && only_static_by_default;
        return all_schemas
            .into_iter()
            .filter(|s| {
                !(excluded_table_names.contains(&s.name.to_lowercase())
                    || ignored_when_importing(s))
                    || included_table_names.contains(&s.name.to_lowercase())
            })
            .collect::<Vec<_>>();
    }

    pub fn execute_task(&self) {
        self.task.execute();
    }
}

#[derive(Debug)]
enum Task<'a> {
    Help {
        text: String,
    },
    ImportSchema {
        db_credentials: DbCred,
    },
    ImportDb {
        db_credentials: DbCred,
        tables_to_import: Vec<&'a TableSchema>,
    },
    ExportToSql {
        sql_provider: SqlProvider,
        tables_to_export: Vec<&'a TableSchema>,
    },
}

impl<'a> Task<'a> {
    fn execute(&self) {
        match self {
            Task::Help { text } => {
                println!("{text}");
                std::process::exit(0);
            }
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
                (&all_schemas - &HashSet::from_iter(tables_to_import.iter().cloned()))
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
                    &all_schemas - &HashSet::from_iter(tables_to_export.iter().cloned());
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
