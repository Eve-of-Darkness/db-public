package config

import (
	"github.com/Eve-of-Darkness/db-public/src/db"

	"errors"
	"flag"
	"fmt"
	"os"
	"strings"

	"github.com/spf13/viper"
)

type Config struct {
	DbProvider       db.Provider
	ImportFlag       bool
	ConnectionString string
	ignoredTables    []string
	excludeTables    []string
	includeTables    []string
	updateOnly       bool
}

func Load() Config {
	importFlag := flag.Bool("import", false, "Import configured SQL database to JSON database found in data folder.")
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
	config.ignoredTables = ignoredTables
	config.DbProvider = getDbProvider(exportType, importFlag)
	config.updateOnly = *updateOnly

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

func getDbProvider(exportType *string, importFlag *bool) db.Provider {
	importSQLite := *importFlag && viper.GetString("db.file_path") != ""

	if *exportType == "update-only" {
		println("Export type update-only is deprecated. Use \"-update-only\" instead.")
	}

	if importSQLite || *exportType == "sqlite" {
		return db.GetSqliteProvider()
	} else if *importFlag || *exportType == "mysql" || *exportType == "update-only" {
		return db.GetMysqlProvider()
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

func (config *Config) GetTables() []db.Table {
	tables := db.GetAllTables()
	db.SortTables(tables)

	if len(config.ignoredTables) > 0 {
		println("\"exportignore\" in config.yml is deprecated use \"exclude\" instead.")
	}

	result := []db.Table{}
	for _, t := range tables {
		if !config.isTableIncluded(t) {
			fmt.Println("Found ignored table:", t.Name)
			continue
		}
		result = append(result, t)
	}
	return result
}

func (config *Config) isTableIncluded(t db.Table) bool {
	isIgnored := containsString(config.ignoredTables, t.Name)
	isExcluded := containsString(config.excludeTables, "all") || containsString(config.excludeTables, t.Name)
	isIncluded := containsString(config.includeTables, t.Name)
	if config.updateOnly && (!t.IsStatic() || isIgnored || isExcluded) {
		return false
	}
	if config.ImportFlag && (!isIncluded && (!t.IsStatic() || isExcluded)) { // include > exclude
		return false
	}
	if !config.ImportFlag && isExcluded {
		return false
	}
	return true
}

func containsString(stringSlice []string, searchString string) bool {
	for _, s := range stringSlice {
		if strings.EqualFold(s, searchString) {
			return true
		}
	}
	return false
}
