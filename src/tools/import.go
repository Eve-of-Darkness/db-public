package tools

import (
	"github.com/Eve-of-Darkness/db-public/src/db"
	"github.com/Eve-of-Darkness/db-public/src/db/schema"
	"github.com/Eve-of-Darkness/db-public/src/utils"

	"crypto/sha256"
	"encoding/json"
	"fmt"
	"os"
	"path/filepath"
	"sort"
	"strconv"
	"strings"
	"time"
)

func ImportToJson(dbProvider db.Provider, tables []schema.Table) {
	conn := dbProvider.DB()

	for index, table := range tables {
		if table.Name == "Mob" {
			for i := 0; i <= 6; i++ {
				q := conn.Query("SELECT Mob.* FROM Mob JOIN Regions on Mob.Region = Regions.RegionId WHERE Regions.Expansion = " + fmt.Sprint(i))
				var tableData = convertRowsToTableData(q, table.GetPrimaryColumn().Name)
				writeJSON(tableData, fmt.Sprintf("Mob.%v", i))
			}
			continue
		}
		q := conn.Query("SELECT * FROM " + table.Name)
		var tableData = convertRowsToTableData(q, table.GetPrimaryColumn().Name)
		writeJSON(tableData, table.Name)
		fmt.Printf("Finished " + fmt.Sprint(index+1) + " of " + fmt.Sprint(len(tables)) + " (" + table.Name + ")\n")
	}
}

func convertRowsToTableData(q *db.QueryResults, primaryKeyName string) []map[string]any {
	tableData := make([]map[string]any, 0)
	for q.Next() {
		entry := make(map[string]any)
		for i, col := range q.Headers() {
			entry[col] = convertDbEntryToJson(q.CurrentRow()[i])
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

	jsonPath := filepath.Join(utils.RootFolder(), "data", fileName+".json")

	if _, err := os.Stat(filepath.Dir(jsonPath)); os.IsNotExist(err) {
		os.MkdirAll(filepath.Dir(jsonPath), os.ModePerm)
	}

	if _, err := os.Stat(jsonPath); err == nil {
		file, e := os.ReadFile(jsonPath)
		if e != nil {
			panic(e)
		}

		fileHash := fmt.Sprintf("%x", sha256.Sum256(file))
		jsonHash := fmt.Sprintf("%x", sha256.Sum256(jsonData))

		if fileHash == jsonHash {
			return
		}
	}

	err = os.WriteFile(jsonPath, jsonData, 0644)
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
