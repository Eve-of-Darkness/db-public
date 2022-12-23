package db

import (
	"database/sql"
	"fmt"

	_ "github.com/go-sql-driver/mysql"
)

type mysqlProvider struct {
	db               *sql.DB
	connectionString string
}

func (provider *mysqlProvider) SetConnectionString(connectionString string) {
	provider.connectionString = connectionString
}

func (provider *mysqlProvider) GetConnection() *sql.DB {
	if provider.db == nil {
		db, err := sql.Open("mysql", provider.connectionString)
		if err != nil {
			panic(fmt.Errorf("failed to connect to database"))
		}
		provider.db = db
	}
	return provider.db
}

func (provider *mysqlProvider) CloseConnection() {
	provider.db.Close()
}

func (provider *mysqlProvider) GetCreateStatement(table Table) string {
	stmt := ""
	if table.Static {
		stmt += fmt.Sprintf("DROP TABLE IF EXISTS `%v`;\n\n", table.Name)
		stmt += fmt.Sprintf("CREATE TABLE `%v` (\n", table.Name)
	} else {
		stmt += fmt.Sprintf("CREATE TABLE IF NOT EXISTS `%v` (\n", table.Name)
	}
	for _, col := range table.Columns {
		stmt += "  `" + col.Name + "` " + col.SqlType
		if col.NotNull {
			stmt += " NOT NULL"
		}
		if col.DefaultValue != "" {
			if col.DefaultValue == "NULL" {
				stmt += " DEFAULT NULL"
			} else {
				stmt += " DEFAULT '" + col.DefaultValue + "'"
			}
		}
		if (col.IsPrimary && table.AutoIncrement > 0) || col.AutoIncrement {
			stmt += " AUTO_INCREMENT"
		}
		stmt += ",\n"
	}
	stmt += "  PRIMARY KEY (`" + table.GetPrimaryColumn().Name + "`),\n"

	for _, i := range table.Indexes {
		if i.Unique {
			stmt += "  UNIQUE KEY `" + i.Name + "` (`" + i.Columns[0] + "`),\n"
			continue
		}
		stmt += "  KEY `" + i.Name + "` ("
		for _, col := range i.Columns {
			stmt += "`" + col + "`,"
		}
		stmt = stmt[:len(stmt)-1]
		stmt += "),\n"
	}
	stmt = stmt[0:len(stmt)-2] + "\n"
	stmt += ") ENGINE=InnoDB"
	if table.AutoIncrement > 1 {
		stmt += fmt.Sprintf(" AUTO_INCREMENT=%v", table.AutoIncrement)
	}
	stmt += " DEFAULT CHARSET utf8 COLLATE utf8_general_ci;\n"
	return stmt
}
