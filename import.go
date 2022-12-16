package main

import (
	"crypto/sha256"
	"database/sql"
	"encoding/json"
	"fmt"
	"os"
	"sort"
	"strconv"
	"strings"
	"time"
)

func importToJson(config Config) {
	var dbProvider dbProvider = config.DbProvider
	dbProvider.setConnectionString(config.ConnectionString)
	dbProvider.getConnection()
	defer dbProvider.closeConnection()

	tables := config.GetTables()

	for index, table := range tables {
		if table.Name == "Mob" {
			for i := 0; i <= 6; i++ {
				getMobJSON(i, dbProvider)
			}
			continue
		}
		getJSON(table, dbProvider)
		fmt.Printf("Finished " + fmt.Sprint(index+1) + " of " + fmt.Sprint(len(tables)) + " (" + table.Name + ")\n")
	}
}

func getMobJSON(expansion int, dbProvider dbProvider) {
	rows := query(dbProvider, "SELECT Mob.* FROM Mob JOIN Regions on Mob.Region = Regions.RegionId WHERE Regions.Expansion = "+fmt.Sprint(expansion))
	defer rows.Close()
	allTables := getAllTables()
	mobTable := findTable("Mob", allTables)
	var tableData = convertRowsToTableData(rows, mobTable.PrimaryColumn.Name)
	writeJSON(tableData, "Mob."+fmt.Sprint(expansion))
}

func getJSON(table Table, dbProvider dbProvider) {
	rows := query(dbProvider, "SELECT * FROM "+table.Name)
	defer rows.Close()
	var tableData = convertRowsToTableData(rows, table.PrimaryColumn.Name)
	writeJSON(tableData, table.Name)
}

func query(dbProvider dbProvider, queryStr string) *sql.Rows {
	var db = dbProvider.getConnection()

	stmt, err := db.Prepare(queryStr)
	if err != nil {
		panic(err)
	}
	defer stmt.Close()

	rows, err := stmt.Query()
	if err != nil {
		panic(err)
	}

	return rows
}

func convertRowsToTableData(rows *sql.Rows, primaryKeyName string) []map[string]any {
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

	sortTableData(tableData, primaryKeyName)

	return tableData
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

func writeJSON(tableData []map[string]any, fileName string) {
	if len(tableData) == 0 {
		return
	}

	jsonData, err := json.MarshalIndent(tableData, "", "  ")
	if err != nil {
		panic(err)
	}

	if _, err := os.Stat("/data"); os.IsNotExist(err) {
		os.MkdirAll("data", os.ModePerm)
	}

	if _, err := os.Stat("data/" + fileName + ".json"); err == nil {
		file, e := os.ReadFile("data/" + fileName + ".json")
		if e != nil {
			panic(e)
		}

		fileHash := fmt.Sprintf("%x", sha256.Sum256(file))
		jsonHash := fmt.Sprintf("%x", sha256.Sum256(jsonData))

		if fileHash == jsonHash {
			return
		}
	}

	err = os.WriteFile("data/"+fileName+".json", jsonData, 0644)
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
