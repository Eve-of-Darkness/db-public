use config::Config;

mod config;
mod db;

pub fn main() {
    let config = Config::load();

    config.execute_task();
}
