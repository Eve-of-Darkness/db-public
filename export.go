package main

import (
	"bytes"
	"encoding/json"
	"errors"
	"fmt"
	"os"
	"sort"
	"strconv"
	"strings"

	"github.com/spf13/viper"
)

func exportToSql(exportType string, updateOnly bool) {
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

	dataFiles := getFiles("data")
	var buffer bytes.Buffer

	ignoredTables := []string{}
	if exportType == "update-only" || updateOnly {
		ignoredTables = viper.GetStringSlice("exportignore")
		if len(ignoredTables) > 0 {
			println("The use of exportignore is deprecated. All non-static tables are excluded by default.")
			println("Use \"exclude\" instead.")
		}
	}
	tables := getTables(ignoredTables)
	var dbProvider dbProvider
	switch exportType {
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

	for _, table := range tables {
		tableCreateStmt := dbProvider.getCreateStatement(table)

		buffer.Write([]byte(tableCreateStmt))
		buffer.WriteString("\n")

		for _, dataFile := range dataFiles {
			if dataFile[:strings.Index(dataFile, ".")] == table.Name {
				insert := buildBulkInsert(dataFile)
				buffer.WriteString(insert)
				buffer.WriteString("\n\n")
			}
		}
	}

	err := os.WriteFile("public-db.sql", buffer.Bytes(), 0644)
	if err != nil {
		panic(err)
	}
}

func getTables(ignoredTables []string) []Table {
	tables := getAllTables()
	sortTables(tables)
	if ignoredTables != nil && len(ignoredTables) == 0 {
		return tables
	}

	result := []Table{}
	sort.Strings(ignoredTables)
	for _, t := range tables {
		isIgnored := containsString(ignoredTables, t.Name)
		if !t.Static || isIgnored {
			fmt.Println("Found ignored table: ", t.Name)
			continue
		}
		result = append(result, t)
	}
	return result
}

func containsString(stringSlice []string, searchString string) bool {
	for _, s := range stringSlice {
		if strings.EqualFold(s, searchString) {
			return true
		}
	}
	return false
}

func buildBulkInsert(table string) string {
	data := parseFile(table)

	if len(data) == 0 {
		return ""
	}

	var buffer bytes.Buffer
	columns := getColumns(data[0])

	for index, row := range data {
		if index%2500 == 0 {
			if buffer.Len() > 0 {
				buffer.WriteString(";\n")
			}

			buffer.WriteString(getInsertStart(table, columns))
		} else {
			buffer.WriteString(",\n")
		}

		buffer.WriteString(getValues(columns, row))
	}

	buffer.WriteString(";")
	return buffer.String()
}

func getValues(columns []string, data map[string]interface{}) string {
	var buffer bytes.Buffer
	colCount := len(columns)

	buffer.WriteString("\t(")

	for index, column := range columns {
		value := data[column]

		if strValue, ok := value.(string); ok {
			strValue := strings.Replace(strconv.QuoteToGraphic(strValue), "\\\"", "\"\"", -1)
			buffer.WriteString(strValue)
		} else if value == nil {
			buffer.WriteString("NULL")
		} else {
			buffer.WriteString(fmt.Sprintf("%v", value))
		}

		if index < colCount-1 {
			buffer.WriteString(", ")
		}
	}

	buffer.WriteString(")")

	return buffer.String()
}

func getInsertStart(table string, columns []string) string {
	var buffer bytes.Buffer

	buffer.WriteString("INSERT INTO `")
	buffer.WriteString(table[:strings.Index(table, ".")])
	buffer.WriteString("` (")

	colCount := len(columns)
	for index, column := range columns {
		buffer.WriteString("`")
		buffer.WriteString(column)
		buffer.WriteString("`")

		if index < colCount-1 {
			buffer.WriteString(", ")
		}
	}

	buffer.WriteString(") VALUES \n")

	return buffer.String()
}

func parseFile(fileName string) []map[string]interface{} {
	file, e := os.ReadFile("data/" + fileName)
	if e != nil {
		panic(e)
	}

	var jsontype []map[string]interface{}
	json.Unmarshal(file, &jsontype)

	return jsontype
}

func getColumns(object map[string]interface{}) []string {
	keys := make([]string, len(object))

	i := 0
	for k := range object {
		keys[i] = k
		i++
	}

	sort.Strings(keys)
	return keys
}
