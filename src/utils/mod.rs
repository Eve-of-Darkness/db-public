use std::{fs::{self, File}, io::Write};

use reqwest::{blocking::Client, header::USER_AGENT, blocking::Response};
use serde::Deserialize;
use sevenz_rust2::Archive;

pub fn download_database_from_github() {
    #[derive(Deserialize, Debug)]
    struct GithubRelease {
        name: String,
        assets: Vec<Asset>,
    }

    #[derive(Deserialize, Debug)]
    struct Asset {
        name: String,
        browser_download_url: String,
    }

    let github_api_url = "https://api.github.com/repos/Eve-of-Darkness/db-public/releases";
    let api_response = download(github_api_url);
    let json_str = api_response.text().unwrap();
    let releases: Vec<GithubRelease> = serde_json::from_str(&json_str).unwrap();
    for release in releases {
        for asset in release.assets {
            let db_file_name = "json_db.7z";
            if asset.name == db_file_name {
                println!("Found {}", release.name);
                let url = asset.browser_download_url;

                let destination_folder = "temp";
                let mut file = File::create(db_file_name).unwrap();
                file.write_all(&download(&url).bytes().unwrap()).unwrap();
                let archive = Archive::open(db_file_name).unwrap();
                archive.files;
                sevenz_rust2::decompress_file(db_file_name, destination_folder).unwrap();
                fs::remove_file(db_file_name).unwrap();
                fs::rename(format!("{destination_folder}/data"), "data").unwrap();
                fs::rename(format!("{destination_folder}/customizations"), "customizations")
                    .unwrap_or_else(|e| eprintln!("{e}"));
                fs::remove_dir_all(destination_folder).unwrap();
                return;
            }
        }
    }
}

pub fn get_root_directory<'a>() -> String {
    let repo_folder = env!("CARGO_MANIFEST_DIR");
    let exe_path = std::env::current_exe().unwrap();
    let exe_folder = exe_path.parent().unwrap();
    // "cargo run" executes from target folder, but relevant files are in repo folder
    if exe_folder.starts_with(repo_folder){
        return repo_folder.to_string();
    } else {
        return exe_folder.to_string_lossy().to_string();
    }
}

fn download(url: &str) -> Response {
    Client::new()
            .get(url)
            .header(USER_AGENT, "user_agent")// Github API requires a USER AGENT
            .send()
            .unwrap()
}
