package tools

import (
	"github.com/Eve-of-Darkness/db-public/src/config"
	"github.com/Eve-of-Darkness/db-public/src/db"
	"github.com/Eve-of-Darkness/db-public/src/utils"

	"encoding/json"
	"os"
	"path/filepath"
	"sort"
	"strings"
)

func ImportSchema(config config.Config) {
	dbProvider := config.DbProvider
	dbProvider.SetConnectionString(config.ConnectionString)
	tableNames := dbProvider.GetAllTableNames()
	sort.Slice(tableNames, func(i, j int) bool {
		return strings.ToLower(tableNames[i]) < strings.ToLower(tableNames[j])
	})
	var tables []*db.Table
	for _, tableName := range tableNames {
		tables = append(tables, dbProvider.ReadTableSchema(tableName))
	}

	content, _ := json.MarshalIndent(tables, "", "  ")
	err := os.WriteFile(filepath.Join(utils.RootFolder(), "data", "_TableSchemas.json"), content, 0644)
	if err != nil {
		panic(err)
	}
}
