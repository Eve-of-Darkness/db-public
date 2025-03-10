use config::{Config, Task};

mod config;
mod db;
mod utils;

pub fn main() {
    std::env::set_current_dir(&utils::get_root_directory()).unwrap();

    let config = Config::load();

    if !std::fs::exists("data").unwrap() {
        eprintln!("Data folder missing, downloading database from Github");
        utils::download_database_from_github().unwrap();
    }

    Task::build(config).execute();
}
