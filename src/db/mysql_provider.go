package db

import (
	"database/sql"
	"fmt"
	"sort"
	"strings"

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
	if table.IsStatic() {
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
		columnIsAutoIncremented := table.AutoIncrement > 0 && col.IsPrimary
		defaultValue := col.GetDefaultValue()
		if !columnIsAutoIncremented && defaultValue != "" {
			stmt += " DEFAULT " + defaultValue
		}
		if columnIsAutoIncremented {
			stmt += " AUTO_INCREMENT"
		}
		stmt += ",\n"
	}
	stmt += "  PRIMARY KEY (`" + table.GetPrimaryColumn().Name + "`),\n"

	previousIndexName := ""
	for _, i := range table.Indexes {
		if previousIndexName == i.Name {
			stmt = stmt[:len(stmt)-3]
			stmt += fmt.Sprintf(",`%v`),\n", i.Column)
			continue
		}
		stmt += "  "
		if i.Unique {
			stmt += "UNIQUE "
		}
		stmt += "KEY `" + i.Name + "` (`" + i.Column + "`),\n"
		previousIndexName = i.Name
	}
	stmt = stmt[0:len(stmt)-2] + "\n"
	stmt += ") ENGINE=InnoDB"
	if table.AutoIncrement > 1 {
		stmt += fmt.Sprintf(" AUTO_INCREMENT=%v", table.AutoIncrement)
	}
	stmt += " DEFAULT CHARSET utf8 COLLATE utf8_general_ci;\n"
	return stmt
}

func (provider *mysqlProvider) ReadTableSchema(tableName string) *Table {
	table := NewTable(tableName)
	for _, slice := range getValuesFromQuery(provider, "DESCRIBE "+tableName) {
		column := new(TableColumn)
		column.Name = string(slice[0].([]byte))
		column.SqlType = string(slice[1].([]byte))
		if string(slice[2].([]byte)) == "NO" {
			column.NotNull = true
		}
		if string(slice[3].([]byte)) == "PRI" {
			column.IsPrimary = true
		}
		implicitDefaultValue := column.GetDefaultValue()
		if slice[4] == nil || (string(slice[4].([]byte)) == implicitDefaultValue && !column.IsNumber()) {
			column.DefaultValue = ""
		} else if string(slice[4].([]byte)) == strings.Trim(implicitDefaultValue, "'") {
			column.DefaultValue = ""
		} else {
			column.DefaultValue = string(slice[4].([]byte))
		}
		if slice[5] != nil && string(slice[5].([]byte)) == "auto_increment" {
			table.AutoIncrement = provider.getAutoIncrement(tableName)
		}
		table.Columns = append(table.Columns, column)
	}
	indexes := provider.readIndexesForTable(table)
	table.Indexes = indexes
	return table
}

func (provider *mysqlProvider) getAutoIncrement(tableName string) int {
	query := fmt.Sprintf("SELECT `AUTO_INCREMENT` FROM  INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = '%v'", tableName)
	return int(getValuesFromQuery(provider, query)[0][0].(int64))
}

func (provider *mysqlProvider) readIndexesForTable(table *Table) []*Index {
	indexQuery := "SHOW INDEXES FROM " + table.Name
	var indexes []*Index
	for _, slice := range getValuesFromQuery(provider, indexQuery) {
		if string(slice[2].([]byte)) == "PRIMARY" {
			continue
		}
		index := new(Index)
		index.Name = string(slice[2].([]byte))
		if strings.HasPrefix(index.Name, "U_") {
			index.Unique = true
		}
		index.Column = string(slice[4].([]byte))
		indexes = append(indexes, index)
	}
	sort.Slice(indexes, func(i, j int) bool {
		colIndex1 := getIndexOfColumnIndex(table.Columns, indexes[i].Name)
		colIndex2 := getIndexOfColumnIndex(table.Columns, indexes[j].Name)
		return colIndex1 < colIndex2
	})
	return indexes
}

func getIndexOfColumnIndex(columns []*TableColumn, indexName string) int {
	colName := strings.Join(strings.Split(indexName, "_")[2:], "_")
	for i, t := range columns {
		if colName == t.Name {
			return i
		}
	}
	return -1
}
