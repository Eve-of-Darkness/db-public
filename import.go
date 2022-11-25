package main

import (
	"crypto/sha256"
	"database/sql"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"regexp"
	"sort"
	"strconv"
	"strings"
	"time"

	_ "github.com/go-sql-driver/mysql"
	_ "github.com/mattn/go-sqlite3"
	"github.com/spf13/viper"
)

func importToJson() {
	viper.SetConfigName("config")  // name of config file (without extension)
	viper.AddConfigPath("config/") // path to look for the config file in
	err := viper.ReadInConfig()    // Find and read the config file
	if err != nil {                // Handle errors reading the config file
		panic(fmt.Errorf("fatal error config file: %s", err))
	}

	var dbProvider dbProvider
	if viper.GetString("db.file_path") != "" {
		dbProvider = new(sqliteProvider)
	} else {
		dbProvider = new(mysqlProvider)
	}
	dbProvider.getConnection()
	defer dbProvider.closeConnection()

	tables := getTables(dbProvider)

	for index, table := range tables {
		err := getJSON(table, dbProvider)
		if err != nil {
			fmt.Printf("Failed to get json")
			return
		}

		fmt.Printf("Finished " + fmt.Sprint(index+1) + " of " + fmt.Sprint(len(tables)) + " (" + table + ")\n")
	}
}

func getTables(dbProvider dbProvider) []string {
	ignoreTables := strings.Join(viper.GetStringSlice("exportignore"), "|")

	re := regexp.MustCompile("(?i)(" + ignoreTables + ")")

	rows := dbProvider.getAllTables()
	defer rows.Close()

	var s []string
	for rows.Next() {
		var name string

		if err := rows.Scan(&name); err != nil {
			log.Fatal(err)
		}

		if re.MatchString(name) {
			continue
		}

		s = append(s, name)
	}

	return s
}

func getMobJSON(expansion int, dbProvider dbProvider) error {
	var db = dbProvider.getConnection()
	stmt, err := db.Prepare("SELECT Mob.* FROM Mob JOIN Regions on Mob.Region = Regions.RegionId WHERE Regions.Expansion = " + fmt.Sprint(expansion))
	if err != nil {
		return err
	}
	defer stmt.Close()

	buildJSON(stmt, "Mob."+fmt.Sprint(expansion), dbProvider.getPrimaryKey("Mob"))

	return nil
}

func getJSON(table string, dbProvider dbProvider) error {
	var db = dbProvider.getConnection()
	schemaFiles := getFiles("schema_mysql")
	foundSchemaFile := false
	var schemaFile string
	for _, file := range schemaFiles {
		schemaFile = file[:strings.Index(file, ".")]
		if strings.EqualFold(schemaFile, table) {
			foundSchemaFile = true
			break
		}
	}

	if !foundSchemaFile {
		return nil
	}

	//Handle partitioned Mob table
	if schemaFile == "Mob" {
		for i := 0; i <= 6; i++ {
			getMobJSON(i, dbProvider)
		}
		return nil
	}

	stmt, err := db.Prepare("SELECT * FROM " + table)

	if err != nil {
		return err
	}
	defer stmt.Close()

	var primaryKeyName = dbProvider.getPrimaryKey(table)
	buildJSON(stmt, schemaFile, primaryKeyName)

	return nil
}

func convertDbEntryToJson(v interface{}) interface{} {
	if dateTime, ok := v.(time.Time); ok {
		v = dateTime.Format("2006-01-02 15:04:05")
	} else if str, ok := v.(string); ok {
		str = strings.Replace(str, `"`, `\"`, -1)
		v, _ = strconv.Unquote(`"` + str + `"`)
	} else if byteSlice, ok := v.([]byte); ok {
		v = string(byteSlice)
	}
	return v
}

func buildJSON(stmt *sql.Stmt, fileName string, primaryKeyName string) {
	rows, err := stmt.Query()
	if err != nil {
		panic(err)
	}
	defer rows.Close()

	columns, err := rows.Columns()
	if err != nil {
		panic(err)
	}

	count := len(columns)
	tableData := make([]map[string]interface{}, 0)
	values := make([]interface{}, count)
	valuePtrs := make([]interface{}, count)

	for rows.Next() {
		for i := 0; i < count; i++ {
			valuePtrs[i] = &values[i]
		}
		rows.Scan(valuePtrs...)
		entry := make(map[string]interface{})
		for i, col := range columns {
			entry[col] = convertDbEntryToJson(values[i])
		}

		tableData = append(tableData, entry)
	}

	if len(tableData) == 0 {
		return
	}

	sortTableData(tableData, primaryKeyName)

	jsonData, err := json.MarshalIndent(tableData, "", "  ")
	if err != nil {
		panic(err)
	}

	if _, err := os.Stat("/data"); os.IsNotExist(err) {
		os.MkdirAll("data", os.ModePerm)
	}

	if _, err := os.Stat("data/" + fileName + ".json"); err == nil {
		file, e := ioutil.ReadFile("data/" + fileName + ".json")
		if e != nil {
			panic(e)
		}

		fileHash := fmt.Sprintf("%x", sha256.Sum256(file))
		jsonHash := fmt.Sprintf("%x", sha256.Sum256(jsonData))

		if fileHash == jsonHash {
			return
		}
	}

	err = ioutil.WriteFile("data/"+fileName+".json", jsonData, 0644)
	if err != nil {
		panic(err)
	}
}

func sortTableData(tableData []map[string]interface{}, primaryKeyName string) {
	sort.Slice(tableData, func(i, j int) bool {
		if _, ok := tableData[i][primaryKeyName].(int64); ok {
			return tableData[i][primaryKeyName].(int64) < tableData[j][primaryKeyName].(int64)
		} else if _, ok := tableData[i][primaryKeyName].(string); ok {
			return strings.ToLower(tableData[i][primaryKeyName].(string)) < strings.ToLower(tableData[j][primaryKeyName].(string))
		}
		panic("Primary key " + primaryKeyName + " is neither string nor int.")
	})
}
