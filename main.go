package main

import (
	"github.com/Eve-of-Darkness/db-public/src/config"
	"github.com/Eve-of-Darkness/db-public/src/tools"
)

func main() {
	config := config.GetConfig()

	if config.ImportSchemaFlag {
		tools.ImportSchema(config.DbProvider)
	}

	if config.ImportFlag {
		tools.ImportToJson(config.DbProvider, config.GetTables())
	}

	if !config.ImportFlag && !config.ImportSchemaFlag {
		tools.ExportToSql(config.DbProvider, config.GetTables())
	}
}
