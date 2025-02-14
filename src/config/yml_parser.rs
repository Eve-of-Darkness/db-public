use serde::{Deserialize, Serialize};
use serde_yml;
use std::fs;

use crate::db::{DbCred, MySqlCredentials};

const CONFIG_FILE_PATH: &str = "./config/config.yml";

#[derive(Serialize, Deserialize, Debug)]
pub struct ConfigYml {
    pub db: DbCred,
    #[serde(default)]
    pub include: Vec<String>,
    #[serde(default)]
    pub exclude: Vec<String>,
    #[serde(default)]
    #[serde(skip)]
    pub exportignore: Vec<String>,
}

impl ConfigYml {
    pub fn parse() -> ConfigYml {
        if !fs::exists(CONFIG_FILE_PATH).unwrap() {
            create_default_yml();
        }
        let config_yml_text = fs::read_to_string(CONFIG_FILE_PATH).unwrap();
        let config_yml: ConfigYml = serde_yml::from_str(config_yml_text.as_str()).unwrap();
        return config_yml;
    }
}

fn create_default_yml() {
    let default_yml = &ConfigYml {
        db: DbCred::Mysql(MySqlCredentials {
            host: "localhost".to_string(),
            user: "dol".to_string(),
            password: "dol".to_string(),
            database: "dol".to_string(),
            port: 3306,
        }),
        include: vec![],
        exclude: vec![],
        exportignore: vec![],
    };
    let contents = serde_yml::to_string(&default_yml).unwrap();
    fs::write(CONFIG_FILE_PATH, contents.as_bytes()).unwrap();
}
