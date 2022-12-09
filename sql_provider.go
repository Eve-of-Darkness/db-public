package main

import (
	"database/sql"
	"fmt"
	"strings"

	"github.com/spf13/viper"
)

type dbProvider interface {
	createConnection()
	getConnection() *sql.DB
	closeConnection()
	getCreateStatement(table Table) string
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
	for _, c := range table.Columns {
		sqlTypeIsNumber := strings.Contains(c.SqlType, "int(") || c.SqlType == "double"
		sqlTypeIsText := strings.HasPrefix(c.SqlType, "varchar") || c.SqlType == "text"
		columnIsPrimaryKey := c.Name == table.PrimaryColumn.Name
		if c.Name == table.PrimaryColumn.Name && sqlTypeIsNumber && table.AutoIncrement > 0 {
			stmt += "`" + c.Name + "` INTEGER"
		} else {
			sqlType := strings.Split(c.SqlType, " ")
			if len(sqlType) == 2 { //int(11) unsigned -> unsigned int(11)
				sqlType = []string{sqlType[1], sqlType[0]}
			}
			stmt += fmt.Sprintf("`%v` %v", c.Name, strings.ToUpper(strings.Join(sqlType, " ")))
		}
		if c.NotNull {
			stmt += " NOT NULL"
		}
		if c.Name == table.PrimaryColumn.Name && sqlTypeIsNumber && table.AutoIncrement > 0 {
			stmt += " PRIMARY KEY"
			if table.AutoIncrement > 0 {
				stmt += " AUTOINCREMENT"
			}
		}
		if c.DefaultValue != "" {
			if sqlTypeIsNumber || c.DefaultValue == "NULL" {
				stmt += " DEFAULT " + c.DefaultValue
			} else {
				stmt += fmt.Sprintf(" DEFAULT '%v'", c.DefaultValue)
			}
		} else if c.NotNull {
			if sqlTypeIsText {
				stmt += " DEFAULT ''"
			} else if !columnIsPrimaryKey {
				stmt += " DEFAULT 0"
			}
		} else if sqlTypeIsText || !columnIsPrimaryKey {
			stmt += " DEFAULT NULL"
		}

		if sqlTypeIsText {
			stmt += " COLLATE NOCASE"
		}
		stmt += ", \n"
	}
	if !strings.Contains(table.PrimaryColumn.SqlType, "int(") || table.AutoIncrement < 1 {
		stmt += fmt.Sprintf("PRIMARY KEY (`%v`));\n", table.PrimaryColumn.Name)
	} else {
		stmt = stmt[:len(stmt)-3] + ");\n"
	}
	for _, c := range table.UniqueIndexes {
		stmt += fmt.Sprintf("CREATE UNIQUE INDEX `U_%[1]v_%[2]v` ON `%[1]v` (`%[2]v`);\n", table.Name, c.Name)
	}
	for _, i := range table.Indexes {
		columns := ""
		for _, c := range i.Keys {
			columns += fmt.Sprintf("`%v`, ", c.Name)
		}
		columns = columns[:len(columns)-2]
		stmt += fmt.Sprintf("CREATE INDEX `%[2]v` ON `%[1]v` (%[3]v);\n", table.Name, i.Name, columns)
	}
	return stmt
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
	for _, k := range table.Columns {
		stmt += "  `" + k.Name + "` " + k.SqlType
		if k.NotNull {
			stmt += " NOT NULL"
		}
		if k.DefaultValue != "" {
			if k.DefaultValue == "NULL" {
				stmt += " DEFAULT NULL"
			} else {
				stmt += " DEFAULT '" + k.DefaultValue + "'"
			}
		}
		if (k == table.PrimaryColumn && table.AutoIncrement > 0) || k.AutoIncrement {
			stmt += " AUTO_INCREMENT"
		}
		stmt += ",\n"
	}
	stmt += "  PRIMARY KEY (`" + table.PrimaryColumn.Name + "`),\n"
	for _, k := range table.UniqueIndexes {
		stmt += "  UNIQUE KEY `U_" + table.Name + "_" + k.Name + "` (`" + k.Name + "`),\n"
	}

	for _, i := range table.Indexes {
		stmt += "  KEY `" + i.Name + "` ("
		for _, k := range i.Keys {
			stmt += "`" + k.Name + "`,"
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
