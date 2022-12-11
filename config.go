package main

import (
	"errors"
	"flag"
	"fmt"
	"os"
	"strings"

	"github.com/spf13/viper"
)

type Config struct {
	DbProvider       dbProvider
	ImportFlag       bool
	IgnoredTables    []string
	ConnectionString string
	ExcludeTables    []string
	IncludeTables    []string
	UpdateOnly       bool
}

func LoadConfig() Config {
	importFlag := flag.Bool("import", false, "Import your SQL database to JSON database found in data folder.")
	exportType := flag.String("export", "mysql", "Export Public-DB as SQL query. Possible values are \"mysql\", \"sqlite\", \"update-only\"")
	updateOnly := flag.Bool("update-only", false, "Set to export SQL query to replace static content, but keep player content untouched.")
	flag.Parse()

	loadConfigFile()

	ignoredTables := []string{}
	if *updateOnly {
		ignoredTables = getIgnoredTables()
	}

	config := new(Config)

	config.ImportFlag = *importFlag
	config.IgnoredTables = ignoredTables
	config.DbProvider = getDbProvider(exportType)
	config.UpdateOnly = *updateOnly

	config.ConnectionString = config.getConnectionString()
	return *config
}

func splitString(str string, sep string) []string {
	if str == "" {
		return []string{}
	} else {
		return strings.Split(str, sep)
	}
}

func loadConfigFile() {
	viper.SetConfigName("config")    // name of config file (without extension)
	viper.AddConfigPath("./config/") // path to look for the config file in
	if _, fileError := os.Stat("./config/config.yml"); errors.Is(fileError, os.ErrNotExist) {
		input, _ := os.ReadFile("./config/config.example.yml")
		_ = os.WriteFile("./config/config.yml", input, 0644)
	} else {
		err := viper.ReadInConfig()
		if err != nil {
			panic(fmt.Errorf("fatal error config file: %s", err))
		}
	}
}

func getDbProvider(exportType *string) dbProvider {
	var dbProvider dbProvider
	switch *exportType {
	case "mysql":
		dbProvider = new(mysqlProvider)
	case "sqlite":
		dbProvider = new(sqliteProvider)
	case "update-only":
		println("Export type update-only is deprecated. Use \"-update-only\" instead.")
		dbProvider = new(mysqlProvider)
	default:
		panic("Chosen export value is invalid. Please choose either \"mysql\", \"sqlite\" or \"update-only\".")
	}
	return dbProvider
}

func getIgnoredTables() []string {
	ignoredTables := viper.GetStringSlice("exportignore")
	if len(ignoredTables) > 0 {
		println("The use of exportignore is deprecated. All non-static tables are excluded by default.")
		println("Use \"exclude\" instead.")
	}
	return ignoredTables
}

func (config *Config) getConnectionString() string {
	if viper.GetString("db.file_path") != "" {
		config.DbProvider = new(sqliteProvider)
		return "file:" + viper.GetString("db.file_path")
	} else {
		config.DbProvider = new(mysqlProvider)
		dbUser := viper.GetString("db.user")
		dbPasswort := viper.GetString("db.password")
		dbHost := viper.GetString("db.host")
		dbPort := viper.GetString("db.port")
		dbDatabase := viper.GetString("db.database")
		return dbUser + ":" + dbPasswort + "@tcp(" + dbHost + ":" + dbPort + ")/" + dbDatabase
	}
}
