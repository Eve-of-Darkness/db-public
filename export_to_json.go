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
	"strings"

	_ "github.com/go-sql-driver/mysql"
	"github.com/spf13/viper"
)

func importToJson() {
	viper.SetConfigName("config")  // name of config file (without extension)
	viper.AddConfigPath("config/") // path to look for the config file in
	err := viper.ReadInConfig()    // Find and read the config file
	if err != nil {                // Handle errors reading the config file
		panic(fmt.Errorf("Fatal error config file: %s \n", err))
	}

	db, err := sql.Open(
		"mysql",
		viper.GetString("db.user")+":"+viper.GetString("db.password")+"@tcp("+viper.GetString("db.host")+":"+viper.GetString("db.port")+")/"+viper.GetString("db.database"))

	if err != nil {
		fmt.Printf("Failed to connect to database")
		return
	}
	defer db.Close()

	tables, err := getTables(db)
	if err != nil {
		fmt.Printf("Failed to get tables: %v", err)
		return
	}

	for index, table := range tables {
		err := getJSON(table, db)
		if err != nil {
			fmt.Printf("Failed to get json")
			return
		}

		fmt.Printf("Finished " + fmt.Sprint(index+1) + " of " + fmt.Sprint(len(tables)) + " (" + table + ")\n")
	}
}

func getTables(db *sql.DB) ([]string, error) {
	ignoreTables := strings.Join(viper.GetStringSlice("exportignore"), "|")

	re := regexp.MustCompile("(?i)(" + ignoreTables + ")")

	rows, err := db.Query("SHOW TABLES;")
	if err != nil {
		return nil, err
	}
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

	return s, nil
}

func getMobJSON(expansion int, db *sql.DB) error {
	stmt, err := db.Prepare("SELECT Mob.* FROM Mob JOIN Regions on Mob.Region = Regions.RegionId WHERE Regions.Expansion = " + fmt.Sprint(expansion))
	if err != nil {
		return err
	}
	defer stmt.Close()

	buildJSON(stmt, "Mob."+fmt.Sprint(expansion))

	return nil
}

func getJSON(table string, db *sql.DB) error {
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
			getMobJSON(i, db)
		}
		return nil
	}

	stmt, err := db.Prepare("SELECT * FROM " + table)
	if err != nil {
		return err
	}
	defer stmt.Close()

	buildJSON(stmt, schemaFile)

	return nil
}

func buildJSON(stmt *sql.Stmt, fileName string) {
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
			var v interface{}
			val := values[i]
			b, ok := val.([]byte)
			if ok {
				v = string(b)
			} else {
				v = val
			}
			entry[col] = v
		}
		tableData = append(tableData, entry)
	}

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
