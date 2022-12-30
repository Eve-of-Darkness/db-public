package db

import (
	"database/sql"
	"fmt"
)

type database struct {
	sqlDB *sql.DB
}

func (db *database) Query(queryStr string) *QueryResults {
	var sqlDB = db.sqlDB

	stmt, err := sqlDB.Prepare(queryStr)
	if err != nil {
		panic(err)
	}
	defer stmt.Close()

	rows, err := stmt.Query()
	if err != nil {
		panic(err)
	}

	q := GetQueryResults(rows)
	return q
}

func open(dbType string, connectionString string) *database {
	sqlDB, err := sql.Open(dbType, connectionString)
	if err != nil {
		panic(fmt.Errorf("failed to connect to database"))
	}

	db := new(database)
	db.sqlDB = sqlDB
	return db
}
