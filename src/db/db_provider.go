package db

import "github.com/Eve-of-Darkness/db-public/src/db/schema"

type Provider interface {
	SetConnectionString(string)
	DB() *database
	GetCreateStatement(table schema.Table) string
	GetAllTableNames() []string
	ReadSchema(tableName string) *schema.Table
}

func GetMysqlProvider() Provider {
	return new(mysqlProvider)
}

func GetSqliteProvider() Provider {
	return new(sqliteProvider)
}
