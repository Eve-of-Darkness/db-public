use serde::{Deserialize, Serialize};
use serde_yml;
use std::fs;

use crate::db::{DbCred, MySqlCredentials};

const CONFIG_FILE_NAME: &str = "config.yml";

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
        let config_file_path = match get_config_file_path() {
            Ok(path) => path,
            Err(_) => {
                let file_path = CONFIG_FILE_NAME.to_string();
                create_default_yml(&file_path);
                file_path
            },
        };
        let config_yml_text = fs::read_to_string(config_file_path).unwrap();
        let config_yml: ConfigYml = serde_yml::from_str(config_yml_text.as_str()).unwrap();
        return config_yml;
    }
}

fn get_config_file_path() -> Result<String, ()> {
    if fs::exists(CONFIG_FILE_NAME).unwrap() {
        return Ok(CONFIG_FILE_NAME.to_string());
    } else {
        let legacy_config_path = format!("./config/{CONFIG_FILE_NAME}");
        if fs::exists(&legacy_config_path).unwrap() {
            return Ok(legacy_config_path);
        } else {
            Err(())
        }
    }
}

fn create_default_yml(file_path: &str) {
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
    fs::write(file_path, contents.as_bytes()).unwrap();
}
