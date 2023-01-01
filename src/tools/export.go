package tools

import (
	"path/filepath"

	"github.com/Eve-of-Darkness/db-public/src/db"
	"github.com/Eve-of-Darkness/db-public/src/db/schema"
	"github.com/Eve-of-Darkness/db-public/src/utils"

	"encoding/json"
	"fmt"
	"os"
	"strconv"
	"strings"
)

func ExportToSql(dbProvider db.Provider, tables []schema.Table) {
	var buffer strings.Builder

	for _, table := range tables {
		tableCreateStmt := dbProvider.GetCreateStatement(table)

		buffer.Write([]byte(tableCreateStmt))
		buffer.WriteString("\n")

		insert := buildBulkInsert(table)
		buffer.WriteString(insert)
	}

	err := os.WriteFile("public-db.sql", []byte(buffer.String()), 0644)
	if err != nil {
		panic(err)
	}
}

func getFiles(dir string) []string {
	files, err := os.ReadDir(dir)
	if err != nil {
		panic(err)
	}

	fileNames := make([]string, len(files))

	for i, f := range files {
		fileNames[i] = f.Name()
	}

	return fileNames
}

func buildBulkInsert(table schema.Table) string {
	data := parseFile(table)

	if len(data) == 0 {
		return ""
	}

	var buffer strings.Builder

	for index, row := range data {
		if index%2500 == 0 {
			if buffer.Len() > 0 {
				buffer.WriteString(";\n")
			}

			buffer.WriteString(getInsertStart(table))
		} else {
			buffer.WriteString(",\n")
		}

		buffer.WriteString(getValues(table, row))
	}

	buffer.WriteString(";\n\n")
	return buffer.String()
}

func getValues(table schema.Table, data map[string]interface{}) string {
	var buffer strings.Builder
	colCount := len(table.Columns)

	buffer.WriteString("\t(")

	for index, column := range table.Columns {
		value := data[column.Name]

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

func getInsertStart(table schema.Table) string {
	var buffer strings.Builder

	buffer.WriteString("INSERT INTO `")
	buffer.WriteString(table.Name)
	buffer.WriteString("` (")

	columns := table.Columns
	for i, column := range columns {
		buffer.WriteString("`")
		buffer.WriteString(column.Name)
		buffer.WriteString("`")
		if i+1 < len(columns) {
			buffer.WriteString(", ")
		}
	}

	buffer.WriteString(") VALUES \n")

	return buffer.String()
}

func parseFile(table schema.Table) []map[string]interface{} {
	files := getFiles(filepath.Join(utils.RootFolder(), "data"))
	var data []map[string]interface{}
	for _, f := range files {
		var addedData []map[string]interface{}
		if !strings.HasPrefix(f, table.Name+".") || !strings.HasSuffix(f, ".json") {
			continue
		}
		file, e := os.ReadFile(filepath.Join(utils.RootFolder(), "data", f))
		if e != nil {
			panic(e)
		}

		json.Unmarshal(file, &addedData)
		data = append(data, addedData...)
	}

	return data
}
