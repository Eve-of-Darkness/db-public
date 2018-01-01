package main

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"regexp"
	"strings"

	_ "github.com/go-sql-driver/mysql"
	"github.com/jinzhu/configor"
)

//Config is from config file
var Config = struct {
	DB struct {
		Host     string `required:"true" default:"127.0.0.1"`
		User     string `required:"true" default:"dolserver"`
		Database string `required:"true" default:"dolserver"`
		Password string `required:"true" default:"dolserver"`
		Port     uint   `default:"3306"`
	}
}{}

func main() {
	configor.Load(&Config, "config.yml")

	db, err := sql.Open(
		"mysql",
		Config.DB.User+":"+Config.DB.Password+"@tcp("+Config.DB.Host+":"+fmt.Sprint(Config.DB.Port)+")/"+Config.DB.Database)

	if err != nil {
		fmt.Printf("Failed to connect to database")
		return
	}
	defer db.Close()

	tables, err := getTables(db)
	if err != nil {
		fmt.Printf("Failed to get tables")
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
	re := regexp.MustCompile("(?i)(Appeal|AuditEntry|Ban|DBHouseCharsXPerms|DOLCharacters|DBHousePermissions|DOLCharactersBackup|DOLCharactersBackupXCustomParam|DOLCharactersXCustomParam|GuildAlliance|HouseConsignmentMerchant|KeepCaptureLog|News|PlayerXEffect|PvPKillsLog|ServerInfo|serverproperty_category|serverstats|SinglePermission|Task|Account|Characterxdataquest|characterxmasterlevel|characterxonetimedrop|inventory|playerboats|playerinfo|BugReport)")

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

func getFiles(dir string) []string {
	files, err := ioutil.ReadDir("../" + dir)
	if err != nil {
		panic(err)
	}

	fileNames := make([]string, len(files))

	i := 0
	for _, f := range files {
		fileNames[i] = f.Name()
		i++
	}

	return fileNames
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
	schemaFiles := getFiles("schema")
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

	if _, err := os.Stat("../data"); os.IsNotExist(err) {
		os.MkdirAll("../data", os.ModePerm)
	}

	err = ioutil.WriteFile("../data/"+fileName+".json", jsonData, 0644)
	if err != nil {
		panic(err)
	}
}
