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
	importFlag := flag.Bool("import", false, "Import configured SQL database to JSON database found in data folder.")
	exportType := flag.String("export", "mysql", "Export Public-DB as SQL query. Possible values are \"mysql\" and \"sqlite\"")
	updateOnly := flag.Bool("update-only", false, "Set to export/replace static content, but keep player content untouched.")
	excludeTables := flag.String("exclude", "", "Explicitly exclude (comma-separated) tables from export and import.")
	includeTables := flag.String("include", "", "Explicitly include (comma-separated) tables that are not listed or are non-static for import.")
	flag.Parse()

	loadConfigFile()

	ignoredTables := []string{}
	if *updateOnly {
		ignoredTables = getIgnoredTables()
	}

	config := new(Config)

	config.ExcludeTables = append(splitString(*excludeTables, ","), viper.GetStringSlice("exclude")...)
	config.IncludeTables = append(splitString(*includeTables, ","), viper.GetStringSlice("include")...)

	config.ImportFlag = *importFlag
	config.IgnoredTables = ignoredTables
	config.DbProvider = getDbProvider(exportType, importFlag)
	config.UpdateOnly = *updateOnly

	config.ConnectionString = getConnectionString()
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

func getDbProvider(exportType *string, importFlag *bool) dbProvider {
	importSQLite := *importFlag && viper.GetString("db.file_path") != ""

	if *exportType == "update-only" {
		println("Export type update-only is deprecated. Use \"-update-only\" instead.")
	}

	if importSQLite || *exportType == "sqlite" {
		return new(sqliteProvider)
	} else if *importFlag || *exportType == "mysql" || *exportType == "update-only" {
		return new(mysqlProvider)
	} else {
		panic("Chosen export value is invalid. Please choose either \"mysql\", \"sqlite\" or \"update-only\".")
	}
}

func getIgnoredTables() []string {
	ignoredTables := viper.GetStringSlice("exportignore")
	if len(ignoredTables) > 0 {
		println("The use of exportignore is deprecated. All non-static tables are excluded by default.")
		println("Use \"exclude\" instead.")
	}
	return ignoredTables
}

func getConnectionString() string {
	if viper.GetString("db.file_path") != "" {
		return "file:" + viper.GetString("db.file_path")
	} else {
		dbUser := viper.GetString("db.user")
		dbPasswort := viper.GetString("db.password")
		dbHost := viper.GetString("db.host")
		dbPort := viper.GetString("db.port")
		dbDatabase := viper.GetString("db.database")
		return dbUser + ":" + dbPasswort + "@tcp(" + dbHost + ":" + dbPort + ")/" + dbDatabase
	}
}
