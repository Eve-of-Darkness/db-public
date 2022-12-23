package db

import (
	"database/sql"
)

type Provider interface {
	SetConnectionString(string)
	GetConnection() *sql.DB
	CloseConnection()
	GetCreateStatement(table Table) string
}

func GetMysqlProvider() Provider {
	return new(mysqlProvider)
}

func GetSqliteProvider() Provider {
	return new(sqliteProvider)
}
