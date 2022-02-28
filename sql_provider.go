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

func (provider *sqliteProvider) closeConnection() {
	provider.db.Close()
}

type mysqlProvider struct {
	db *sql.DB
}

func (provider *mysqlProvider) createConnection() {
	db, err := sql.Open(
		"mysql",
		viper.GetString("db.user")+":"+viper.GetString("db.password")+"@tcp("+viper.GetString("db.host")+":"+viper.GetString("db.port")+")/"+viper.GetString("db.database"))

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

func (provider *mysqlProvider) closeConnection() {
	provider.db.Close()
}
