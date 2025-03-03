use config::{Config, Task};

mod config;
mod db;

pub fn main() {
    let config = Config::load();

    Task::build(config).execute();
}
