# db-public
Vanilla database for Dawn of Light

## Goal
To provide the DOL community with means to spin up a new server on a solid data foundation.

## Installing
To use this database download and run concat.exe in Windows or concat in Linux. This will combine the json files into a single script that you can run against an already made database.

## Contributing
Schema and data scripts have been separated to minimize risk of schema being accidentally modified. Data modifications should follow the formatting convention used throughout. To generate json data files run export_to_json. This will require you to create a config.yml file. See example file for inspiration.

## The data
We plan on following data available on http://camelot.allakhazam.com/ as closely as possible. We think this will be the most effective way quickly populate missing data.
