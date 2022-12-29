package db

import (
	"database/sql"
)

type Provider interface {
	SetConnectionString(string)
	GetConnection() *sql.DB
	CloseConnection()
	GetCreateStatement(table Table) string
	GetAllTableNames() []string
	ReadTableSchema(tableName string) *Table
}

func GetMysqlProvider() Provider {
	return new(mysqlProvider)
}

func GetSqliteProvider() Provider {
	return new(sqliteProvider)
}

func Query(dbProvider Provider, queryStr string) *sql.Rows {
	var db = dbProvider.GetConnection()

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

func getValuesFromQuery(dbProvider Provider, queryStr string) [][]any {
	rows := Query(dbProvider, queryStr)
	var result [][]any
	columns, _ := rows.Columns()
	for rows.Next() {
		valuePtrs := make([]any, len(columns))
		values := make([]any, len(columns))
		for i := 0; i < len(columns); i++ {
			valuePtrs[i] = &values[i]
		}
		rows.Scan(valuePtrs...)
		result = append(result, values)
	}
	return result
}
