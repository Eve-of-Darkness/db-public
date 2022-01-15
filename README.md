# db-public
Vanilla database for Dawn of Light

## Goal
To provide the DOL community with means to spin up a new server on a solid data foundation.

## Usage
To use this database download the zipped `.sql` file from release depending on what SQL implementation you use. For MariaDB and MySQL download `public-db.mysql.sql.zip` and for SQLite use `public-db.sqlite.sql.zip. Extract it and execute the resulting `.sql` file in your favorite SQL tool (i.e. HeidiSQL). Note: On Windows 7-zip is recommended for extraction.

In MySQL you can import the file via:
```
mysql -u <user> -p <password> <doldb> < public-db.sql
```
In SQLite you can import the file via:
```
sqlite3 example.db < public-db.sql
```

## Build Database Query Yourself
Install go-1.13, open a Terminal and run `go run concat.go`. Without any options given this would create a new database in MySQL.  
Options:  
* `-sqlite` creates new database in SQLite
* `-update-only` creates update query for an existing database

The resulting file is `public-db.sql`.

## Contributing
Schema and data scripts have been separated to minimize risk of schema being accidentally modified. Data modifications should follow the formatting convention used throughout. To generate json data files run export_to_json. This will require you to create a config.yml file. See example file for inspiration.

## The data
We plan on following data available on http://camelot.allakhazam.com/ as closely as possible. We think this will be the most effective way quickly populate missing data.
