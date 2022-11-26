package main

import (
	"database/sql"
	"fmt"

	"github.com/spf13/viper"
)

type dbProvider interface {
	createConnection()
	getConnection() *sql.DB
	getAllTables() *sql.Rows
	getPrimaryKeyColumn(tableName string) string
	closeConnection()
}

type sqliteProvider struct {
	db *sql.DB
}

func (provider *sqliteProvider) createConnection() {
	db, err := sql.Open(
		"sqlite3",
		"file:"+viper.GetString("db.file_path"))

	if err != nil {
		panic(fmt.Errorf("failed to connect to database. %s", err))
	}
	provider.db = db
}

func (provider *sqliteProvider) getConnection() *sql.DB {
	if provider.db == nil {
		provider.createConnection()
	}
	return provider.db
}

func (provider *sqliteProvider) getAllTables() *sql.Rows {
	rows, err := provider.db.Query("SELECT name FROM sqlite_schema WHERE type ='table' AND name NOT LIKE 'sqlite_%';")
	if err != nil {
		panic(fmt.Errorf("failed to get tables: %v", err))
	}
	return rows
}

func (provider *sqliteProvider) getPrimaryKeyColumn(tableName string) string {
	db := provider.getConnection()
	var rows *sql.Rows
	rows, _ = db.Query("select name from pragma_table_info( '" + tableName + "' ) where pk = 1")
	defer rows.Close()
	var primaryKey string
	rows.Next()
	rows.Scan(&primaryKey)
	return primaryKey
}

func (provider *sqliteProvider) closeConnection() {
	provider.db.Close()
}

type mysqlProvider struct {
	db *sql.DB
}

func (provider *mysqlProvider) createConnection() {
	dbUser := viper.GetString("db.user")
	dbPasswort := viper.GetString("db.password")
	dbHost := viper.GetString("db.host")
	dbPort := viper.GetString("db.port")
	dbDatabase := viper.GetString("db.database")
	db, err := sql.Open(
		"mysql",
		dbUser+":"+dbPasswort+"@tcp("+dbHost+":"+dbPort+")/"+dbDatabase)
	if err != nil {
		panic(fmt.Errorf("failed to connect to database"))
	}
	provider.db = db
}

func (provider *mysqlProvider) getConnection() *sql.DB {
	if provider.db == nil {
		provider.createConnection()
	}
	return provider.db
}

func (provider *mysqlProvider) getAllTables() *sql.Rows {
	rows, err := provider.db.Query("SHOW TABLES;")
	if err != nil {
		panic(fmt.Errorf("failed to get tables: %v", err))
	}
	return rows
}

func (provider *mysqlProvider) getPrimaryKeyColumn(tableName string) string {
	db := provider.getConnection()
	var rows *sql.Rows
	rows, _ = db.Query("SHOW INDEX FROM `" + tableName + "` where Key_name='PRIMARY'")
	defer rows.Close()

	columns, _ := rows.Columns()
	count := len(columns)
	values := make([]interface{}, count)
	valuePtrs := make([]interface{}, count)
	for rows.Next() {
		for i := 0; i < count; i++ {
			valuePtrs[i] = &values[i]
		}
		rows.Scan(valuePtrs...)
		for i, col := range columns {
			if col == "Column_name" {
				return fmt.Sprintf("%s", values[i])
			}
		}
	}

	panic("No primary key for " + tableName + " found!")
}

func (provider *mysqlProvider) closeConnection() {
	provider.db.Close()
}
