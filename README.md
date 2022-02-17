# db-public
Vanilla database for Dawn of Light

## Goal
To provide the DOL community with means to spin up a new server on a solid data foundation.

## Usage
To use this database download the designated zipped `.sql` file from release. Extract it and execute the resulting `.sql` file in your favorite SQL tool (i.e. HeidiSQL). Note: The built-in extractor in Windows Explorer cannot unzip these; use 7-Zip instead.

If you want to update to current Public-DB without removing existing player content and settings use `public-db.update_only.sql`.

## Build the Database Yourself
Install go-1.17, open a Terminal and run `go run . -export [type]`, where `[type]` can be `mysql`, `sqlite`, `update-only`.

The resulting file is `public-db.sql`.

## Contributing
1. Edit `config.yml` to match the credentials for MySQL/MariaDB database you want to export
2. `go run . -import`

## The data
We plan on following data available on http://camelot.allakhazam.com/ as closely as possible. We think this will be the most effective way quickly populate missing data.
