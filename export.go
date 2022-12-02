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

	_ "github.com/go-sql-driver/mysql"
	"github.com/spf13/viper"
)

func exportToSql(exportType string) {
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
	if exportType == "update-only" {
		ignoredTables = viper.GetStringSlice("exportignore")
	}
	tables := getTables(ignoredTables)

	for _, table := range tables {
		var tableCreateStmt string
		switch exportType {
		case "mysql":
			tableCreateStmt = new(mysqlProvider).getCreateStatement(table)
		case "sqlite":
			tableCreateStmt = new(sqliteProvider).getCreateStatement(table)
		case "update-only":
			tableCreateStmt = new(mysqlProvider).getCreateStatement(table)
		default:
			panic("Chosen export value is invalid. Please choose either \"mysql\", \"sqlite\" or \"update-only\".")
		}

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
	for _, ignoredTable := range ignoredTables {
		matchedIndex := searchInTables(ignoredTable, tables)
		if matchedIndex >= 0 {
			fmt.Println("Found ignored table: ", tables[matchedIndex].Name)
			tables = append(tables[:matchedIndex], tables[matchedIndex+1:]...)
		}
	}
	sortTables(tables)
	return tables
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
