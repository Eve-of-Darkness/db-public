# db-public
Vanilla database for Dawn of Light

## Goal
To provide the DOL community with means to spin up a new server on a solid data foundation.

## Usage
To use this database download the designated zipped `.sql` file from release. Extract it and execute the resulting `.sql` file in your favorite SQL tool (i.e. HeidiSQL). Note: The built-in extractor in Windows Explorer cannot unzip these; use 7-Zip instead.

If you want to update to current Public-DB without removing existing player content and settings use `public-db.update_only.sql`.

## Build the Database Yourself
1. Download public-db-tools.7z
2. Unzip (for example with 7-zip)
3. In a terminal run `./public-db-tools -export [type]`, where `[type]` can be `mysql`, `sqlite`, `update-only`. Note: For Windows the executable is named `public-db-tools.exe` and for MacOS `public-db-tools_mac`.

The resulting file is `public-db.sql`.

## Contributing
1. Edit `config.yml` to match the credentials for MySQL/MariaDB or SQLite database you want to export
2. In a terminal run `./public-db-tools -import`
3. Copy data folder to repository

## The data
We plan on following data available on http://camelot.allakhazam.com/ as closely as possible. We think this will be the most effective way quickly populate missing data.
