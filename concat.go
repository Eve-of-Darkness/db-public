package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"regexp"
	"sort"
	"strconv"
	"strings"

	_ "github.com/go-sql-driver/mysql"
	"github.com/spf13/viper"
)

func exportToSql(exportType string) {
	viper.SetConfigName("config")    // name of config file (without extension)
	viper.AddConfigPath("./config/") // path to look for the config file in
	err := viper.ReadInConfig()      // Find and read the config file
	if err != nil {                  // Handle errors reading the config file
		panic(fmt.Errorf("Fatal error config file: %s \n", err))
	}
	schemaFolderName := "schema_mysql"

	switch exportType {
	case "mysql":
		schemaFolderName = "schema_mysql"
	case "sqlite":
		schemaFolderName = "schema_sqlite"
	case "update-only":
		schemaFolderName = "schema_mysql"
	default:
		panic("Chosen export value is invalid. Please choose either \"mysql\", \"sqlite\" or \"update-only\".")
	}

	schemaFiles := getFiles(schemaFolderName)
	dataFiles := getFiles("data")
	var buffer bytes.Buffer
	ignoreTables := strings.Join(viper.GetStringSlice("exportignore"), "|")
	re := regexp.MustCompile("(?i)(" + ignoreTables + ").sql")

	for _, schemaFile := range schemaFiles {
		if exportType == "update-only" {
			if re.MatchString(schemaFile) {
				fmt.Println("Found ignored table:", schemaFile)
				continue
			}
		}
		file, e := ioutil.ReadFile(schemaFolderName + "/" + schemaFile)
		if e != nil {
			panic(e)
		}

		buffer.Write(file)
		buffer.WriteString("\n")

		for _, dataFile := range dataFiles {
			if dataFile[:strings.Index(dataFile, ".")] == schemaFile[:strings.Index(schemaFile, ".")] {
				insert := buildBulkInsert(dataFile)
				buffer.WriteString(insert)
				buffer.WriteString("\n\n")
			}
		}
	}

	err = ioutil.WriteFile("public-db.sql", buffer.Bytes(), 0644)
	if err != nil {
		panic(err)
	}
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
	file, e := ioutil.ReadFile("data/" + fileName)
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
