use getopts::{Matches, Options};

pub struct CliOptions {
    pub export: String,
    pub import: bool,
    pub import_schema: bool,
    pub exclude: Vec<String>,
    pub include: Vec<String>,
    pub update_only: bool,
    pub help: bool,
}

impl CliOptions {
    pub fn new(args: &Vec<&str>) -> Result<CliOptions,String> {
        let opts = get_options();
        let matches = match get_matches(&opts, &args) {
            Ok(m) => m,
            Err(e) => return Err(e),
        };

        if matches.free.len() > 1 {
            let non_opts = matches.free.into_iter().skip(1).collect::<Vec<_>>().join(", ");
            let msg = format!("Too many non-option arguments provided: {non_opts}");
            return Err(msg);
        }
        let cli_parser = CliOptions {
            export: matches
                .opt_str("export")
                .unwrap_or_else(|| String::from("mysql")),
            import: matches.opt_present("import"),
            import_schema: matches.opt_present("import-schema"),
            exclude: split_string(matches.opt_str("exclude").unwrap_or_default(), ","),
            include: split_string(matches.opt_str("include").unwrap_or_default(), ","),
            update_only: matches.opt_present("update-only"),
            help: matches.opt_present("help"),
        };
        Ok(cli_parser)
    }

    pub fn usage_text(path_to_binary: &str) -> String {
        let brief = format!("Usage: {} [options]", path_to_binary);
        get_options().usage(&brief)
    }
}

fn get_matches(opts: &Options, args: &Vec<&str>) -> Result<Matches, String> {
    match opts.parse(args) {
        Ok(matches) => Ok(matches),
        Err(e) => {
            match e {
                getopts::Fail::ArgumentMissing(o) => {
                    Err(format!("Option --{o} needs an argument."))
                }
                getopts::Fail::UnrecognizedOption(o) => {
                    Err(format!("Option --{o} is not defined."))
                }
                getopts::Fail::OptionMissing(o) => Err(format!("Option --{o} is missing.")),
                getopts::Fail::OptionDuplicated(o) => {
                    Err(format!("Option --{o} may not be given more than once."))
                }
                getopts::Fail::UnexpectedArgument(o) => {
                    Err(format!("Option --{o} may not be given an argument."))
                }
            }
        },
    }
}

fn get_options() -> Options {
    let mut opts = Options::new();
    opts.long_only(true);
    opts.optopt(
        "",
        "exclude",
        r#"Explicitly exclude (comma-separated) tables from export and import
        "all" excludes all tables"#,
        "string",
    );
    opts.optopt(
        "", 
        "export",
        r#"Export Public-DB as SQL query. Possible values are "mysql" and "sqlite" (default "mysql")"#,
        "string");
    opts.optflag(
        "",
        "import",
        "Import configured SQL database to JSON database found in data folder",
    );
    opts.optflag("", "import-schema", "Import all schemas from database");
    opts.optopt(
        "", 
        "include",
        "Explicitly include (comma-separated) tables that are not listed or are non-static for import",
        "string");
    opts.optflag(
        "",
        "update-only",
        "Set to export/replace static content, but keep player content untouched",
    );
    opts.optflag("", "help", "Show this help");
    opts
}

fn split_string(s: String, pattern: &str) -> Vec<String> {
    s.split(pattern)
        .filter(|s| !s.is_empty())
        .map(String::from)
        .collect::<Vec<_>>()
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn config_build_no_args_given_get_defaults() {
        let config = CliOptions::new(&vec!["path_to_binary"]).unwrap();

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

        let config = CliOptions::new(&args).unwrap();

        assert_eq!(config.export, "sqlite")
    }

    #[test]
    fn config_build_exclude_abc_exclude_tables_has_vector_with_a_b_c() {
        let args = &vec!["path_to_binary", "--exclude", "a,b,c"];

        let config = CliOptions::new(&args).unwrap();

        assert_eq!(config.exclude, vec!["a", "b", "c"])
    }
}
