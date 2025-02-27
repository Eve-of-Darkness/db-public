use clap::Parser;

#[derive(Parser, Debug)]
#[command(version, about, long_about = None)]
pub struct CliOptions {
    /// Export Public-DB as SQL query. Possible values are "mysql" and "sqlite"
    #[arg(long, default_value = "mysql")]
    pub export: String,
    /// Import configured SQL database to JSON database found in data folder
    #[arg(long)]
    pub import: bool,
    /// Import all schemas from database
    #[arg(long)]
    pub import_schema: bool,
    /// Explicitly exclude (comma-separated) tables from export and import "all" excludes all tables
    #[arg(long, value_delimiter=',')]
    pub exclude: Vec<String>,
    /// Explicitly include (comma-separated) tables that are not listed or are non-static for import
    #[arg(long, value_delimiter=',')]
    pub include: Vec<String>,
    /// Set to export/replace static content, but keep player content untouched
    #[arg(long)]
    pub update_only: bool,
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn config_build_no_args_given_get_defaults() {
        let config = CliOptions::parse_from(&vec!["path_to_binary"]);

        assert_eq!("mysql", config.export);
        assert_eq!(false, config.import);
        assert_eq!(false, config.import_schema);
        assert_eq!(Vec::<String>::new(), config.exclude);
        assert_eq!(Vec::<String>::new(), config.include);
        assert_eq!(false, config.update_only);
    }

    #[test]
    fn config_build_export_sqlite_db_provider_is_sqlite() {
        let args = vec!["path_to_binary", "--export", "sqlite"];

        let config = CliOptions::parse_from(&args);

        assert_eq!(config.export, "sqlite")
    }

    #[test]
    fn config_build_exclude_abc_exclude_tables_has_vector_with_a_b_c() {
        let args = vec!["path_to_binary", "--exclude", "a,b,c"];

        let config = CliOptions::parse_from(&args);

        assert_eq!(config.exclude, vec!["a", "b", "c"])
    }
}
