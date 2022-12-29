package main

import (
	"github.com/Eve-of-Darkness/db-public/src/config"
	"github.com/Eve-of-Darkness/db-public/src/tools"
)

func main() {
	config := config.Load()

	if config.ImportSchemaFlag {
		tools.ImportSchema(config)
	}

	if config.ImportFlag {
		tools.ImportToJson(config)
	}

	if !config.ImportFlag && !config.ImportSchemaFlag {
		tools.ExportToSql(config)
	}
}
