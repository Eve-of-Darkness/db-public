# db-public
Vanilla database for Dawn of Light

## Goal
To provide the DOL community with means to spin up a new server on a solid data foundation.

## Usage
To use this database download the designated zipped `.sql` file from release. Extract it and execute the resulting `.sql` file in your favorite SQL tool (i.e. HeidiSQL). Note: The built-in extractor in Windows Explorer cannot unzip these; use 7-Zip instead.

## Build the Database Yourself
1. Download public-db-tools.7z
2. Unzip (for example with 7-zip)
3. In a terminal run `./public-db-tools -export <type>`, where `<type>` can be `mysql` or `sqlite`. 

Note: For Windows the executable is named `public-db-tools.exe` and for MacOS `public-db-tools_mac`.

The resulting file is `public-db.sql`.

## Contributing
1. `git clone https://github.com/Eve-of-Darkness/db-public`
2. `cd db-public`
3. `cargo run -- -import`

Afterwards you need to push your changes to your fork of the repository.

## CLI Options
`-export <type>`: Export Public-DB as SQL query. Possible `<type>`s are "mysql" and "sqlite" (default "mysql")  
`-update-only`: Set export to only update static data  
`-import`: Import the configured SQL database  
`-import-schema`: Import schema from database  
`-exclude <table1>,<table2>,...`: Exclude tables  
`-include <table1>,<table2>,...`: Include tables  

Tip: To import only selected tables do `-import -exclude all -include <table1>,<table2>,...`.

## The data
We plan on following data available on http://camelot.allakhazam.com/ as closely as possible. We think this will be the most effective way quickly populate missing data.
