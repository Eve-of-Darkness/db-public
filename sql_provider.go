package main

import (
	"database/sql"
	"fmt"
	"strings"

	_ "github.com/go-sql-driver/mysql"
	_ "github.com/mattn/go-sqlite3"
)

type dbProvider interface {
	setConnectionString(string)
	getConnection() *sql.DB
	closeConnection()
	getCreateStatement(table Table) string
}

type sqliteProvider struct {
	db               *sql.DB
	connectionString string
}

func (provider *sqliteProvider) setConnectionString(connectionString string) {
	provider.connectionString = connectionString
}

func (provider *sqliteProvider) getConnection() *sql.DB {
	if provider.db == nil {
		db, err := sql.Open("sqlite3", provider.connectionString)

		if err != nil {
			panic(fmt.Errorf("failed to connect to database. %s", err))
		}
		provider.db = db
	}
	return provider.db
}

func (provider *sqliteProvider) closeConnection() {
	provider.db.Close()
}

func (provider *sqliteProvider) getCreateStatement(table Table) string {
	stmt := ""
	if table.Static {
		stmt += fmt.Sprintf("DROP TABLE IF EXISTS `%v`;\n\n", table.Name)
		stmt += fmt.Sprintf("CREATE TABLE `%v` (", table.Name)
	} else {
		stmt += fmt.Sprintf("CREATE TABLE IF NOT EXISTS `%v` (", table.Name)
	}
	for _, col := range table.Columns {
		sqlTypeIsNumber := strings.Contains(col.SqlType, "int(") || col.SqlType == "double"
		sqlTypeIsText := strings.HasPrefix(col.SqlType, "varchar") || col.SqlType == "text"
		if col.IsPrimary && sqlTypeIsNumber && table.AutoIncrement > 0 {
			stmt += "`" + col.Name + "` INTEGER"
		} else {
			sqlType := strings.Split(col.SqlType, " ")
			if len(sqlType) == 2 { //int(11) unsigned -> unsigned int(11)
				sqlType = []string{sqlType[1], sqlType[0]}
			}
			stmt += fmt.Sprintf("`%v` %v", col.Name, strings.ToUpper(strings.Join(sqlType, " ")))
		}
		if col.NotNull {
			stmt += " NOT NULL"
		}
		if col.IsPrimary && sqlTypeIsNumber && table.AutoIncrement > 0 {
			stmt += " PRIMARY KEY"
			if table.AutoIncrement > 0 {
				stmt += " AUTOINCREMENT"
			}
		}
		if col.DefaultValue != "" {
			if sqlTypeIsNumber || col.DefaultValue == "NULL" {
				stmt += " DEFAULT " + col.DefaultValue
			} else {
				stmt += fmt.Sprintf(" DEFAULT '%v'", col.DefaultValue)
			}
		} else if col.NotNull {
			if sqlTypeIsText {
				stmt += " DEFAULT ''"
			} else if !col.IsPrimary {
				stmt += " DEFAULT 0"
			}
		} else if sqlTypeIsText || !col.IsPrimary {
			stmt += " DEFAULT NULL"
		}

		if sqlTypeIsText {
			stmt += " COLLATE NOCASE"
		}
		stmt += ", \n"
	}
	if !strings.Contains(table.GetPrimaryColumn().SqlType, "int(") || table.AutoIncrement < 1 {
		stmt += fmt.Sprintf("PRIMARY KEY (`%v`));\n", table.GetPrimaryColumn().Name)
	} else {
		stmt = stmt[:len(stmt)-3] + ");\n"
	}
	for _, i := range table.Indexes {
		if i.Unique {
			stmt += fmt.Sprintf("CREATE UNIQUE INDEX `U_%[1]v_%[2]v` ON `%[1]v` (`%[2]v`);\n", table.Name, i.Columns[0])
			continue
		}
		columns := ""
		for _, col := range i.Columns {
			columns += fmt.Sprintf("`%v`, ", col)
		}
		columns = columns[:len(columns)-2]
		stmt += fmt.Sprintf("CREATE INDEX `%[2]v` ON `%[1]v` (%[3]v);\n", table.Name, i.Name, columns)
	}
	return stmt
}

type mysqlProvider struct {
	db               *sql.DB
	connectionString string
}

func (provider *mysqlProvider) setConnectionString(connectionString string) {
	provider.connectionString = connectionString
}

func (provider *mysqlProvider) getConnection() *sql.DB {
	if provider.db == nil {
		db, err := sql.Open("mysql", provider.connectionString)
		if err != nil {
			panic(fmt.Errorf("failed to connect to database"))
		}
		provider.db = db
	}
	return provider.db
}

func (provider *mysqlProvider) closeConnection() {
	provider.db.Close()
}

func (provider *mysqlProvider) getCreateStatement(table Table) string {
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
