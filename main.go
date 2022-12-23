package main

import (
	"github.com/Eve-of-Darkness/db-public/src/config"
	"github.com/Eve-of-Darkness/db-public/src/tools"
)

func main() {
	config := config.Load()

	if config.ImportFlag {
		tools.ImportToJson(config)
	} else {
		tools.ExportToSql(config)
	}
}
