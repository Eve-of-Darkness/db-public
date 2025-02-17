package config

import (
	"github.com/Eve-of-Darkness/db-public/src/db"
	"github.com/Eve-of-Darkness/db-public/src/db/schema"

	"errors"
	"flag"
	"fmt"
	"os"
	"strings"

	"github.com/spf13/viper"
	"golang.org/x/exp/slices"
)

type Config struct {
	DbProvider       db.Provider
	ImportFlag       bool
	ImportSchemaFlag bool
	ignoredTables    []string
	excludeTables    []string
	includeTables    []string
	updateOnly       bool
	loaded           bool
}

var LoadedConfig Config

func GetConfig() Config {
	if LoadedConfig.loaded {
		return LoadedConfig
	}
	return Load()
}

func Load() Config {
	importFlag := flag.Bool("import", false, "Import configured SQL database to JSON database found in data folder.")
	importSchemaFlag := flag.Bool("import-schema", false, "Import all schemas from database.")
	exportType := flag.String("export", "mysql", "Export Public-DB as SQL query. Possible values are \"mysql\" and \"sqlite\"")
	updateOnly := flag.Bool("update-only", false, "Set to export/replace static content, but keep player content untouched.")
	excludeTables := flag.String("exclude", "", "Explicitly exclude (comma-separated) tables from export and import. \"all\" excludes all tables.")
	includeTables := flag.String("include", "", "Explicitly include (comma-separated) tables that are not listed or are non-static for import.")
	flag.Parse()

	loadConfigFile()

	ignoredTables := []string{}
	if *updateOnly {
		ignoredTables = getIgnoredTables()
	}

	config := new(Config)

	config.excludeTables = append(splitString(*excludeTables, ","), viper.GetStringSlice("exclude")...)
	config.includeTables = append(splitString(*includeTables, ","), viper.GetStringSlice("include")...)

	config.ImportFlag = *importFlag
	config.ImportSchemaFlag = *importSchemaFlag
	config.ignoredTables = ignoredTables
	config.DbProvider = getDbProvider(*exportType, (*importFlag || *importSchemaFlag))
	config.updateOnly = *updateOnly
	config.loaded = true
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

func getDbProvider(exportType string, useFileConfig bool) db.Provider {
	importSQLite := useFileConfig && viper.GetString("db.file_path") != ""

	if exportType == "update-only" {
		println("Export type update-only is deprecated. Use \"-update-only\" instead.")
	}

	var dbProvider db.Provider
	if importSQLite || exportType == "sqlite" {
		dbProvider = db.GetSqliteProvider()
	} else if useFileConfig || exportType == "mysql" || exportType == "update-only" {
		dbProvider = db.GetMysqlProvider()
	} else {
		panic("Chosen export value is invalid. Please choose either \"mysql\", \"sqlite\" or \"update-only\".")
	}
	dbProvider.SetConnectionString(getConnectionString())
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

func (config *Config) GetTables() []schema.Table {
	tables := schema.GetAllTables()

	if len(config.ignoredTables) > 0 {
		println("\"exportignore\" in config.yml is deprecated use \"exclude\" instead.")
	}

	result := []schema.Table{}
	for _, t := range tables {
		if !config.isTableIncluded(t) {
			fmt.Println("Found ignored table:", t.Name)
			continue
		}
		result = append(result, t)
	}
	return result
}

func (config *Config) isTableIncluded(t schema.Table) bool {
	isIgnored := slices.Contains(config.ignoredTables, t.Name)
	isExcluded := slices.Contains(config.excludeTables, "all") || slices.Contains(config.excludeTables, t.Name)
	isIncluded := slices.Contains(config.includeTables, t.Name)
	if config.updateOnly && (!t.IsStatic() || isIgnored || isExcluded) {
		return false
	}
	if config.ImportFlag && (!isIncluded && (!t.IsStatic() || isExcluded)) { // include > exclude
		return false
	}
	if !config.ImportFlag && !isIncluded && isExcluded {
		return false
	}
	return true
}
