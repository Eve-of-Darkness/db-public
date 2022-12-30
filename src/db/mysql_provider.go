package db

import (
	"github.com/Eve-of-Darkness/db-public/src/db/schema"

	"fmt"
	"sort"
	"strings"

	_ "github.com/go-sql-driver/mysql"
)

type mysqlProvider struct {
	connection       *database
	connectionString string
}

func (provider *mysqlProvider) SetConnectionString(connectionString string) {
	provider.connectionString = connectionString
}

func (provider *mysqlProvider) DB() *database {
	if provider.connection == nil {
		provider.connection = open("mysql", provider.connectionString)
	}
	return provider.connection
}

func (provider *mysqlProvider) GetCreateStatement(table schema.Table) string {
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

func (provider *mysqlProvider) GetAllTableNames() []string {
	databaseName := strings.Split(provider.connectionString, "/")[1]
	query := fmt.Sprintf("SELECT TABLE_NAME FROM information_schema.tables WHERE TABLE_SCHEMA = '%v' ORDER BY TABLE_NAME", databaseName)
	var tableNames []string
	q := provider.DB().Query(query)
	for q.Next() {
		tableNames = append(tableNames, string(q.CurrentRow()[0].([]byte)))
	}
	return tableNames
}

func (provider *mysqlProvider) ReadSchema(tableName string) *schema.Table {
	table := schema.NewTable(tableName)
	q := provider.DB().Query("DESCRIBE " + tableName)
	for q.Next() {
		column, autoIncrement := provider.convertToColumn(q.CurrentRow())
		if autoIncrement {
			table.AutoIncrement = provider.getAutoIncrement(tableName)
		}
		table.Columns = append(table.Columns, column)
	}
	indexes := provider.readIndexes(table)
	table.Indexes = indexes
	return table
}

func (provider *mysqlProvider) convertToColumn(slice []any) (*schema.TableColumn, bool) {
	column := new(schema.TableColumn)
	column.Name = string(slice[0].([]byte))
	column.SqlType = string(slice[1].([]byte))
	var autoIncrement bool
	if string(slice[2].([]byte)) == "NO" {
		column.NotNull = true
	}
	if string(slice[3].([]byte)) == "PRI" {
		column.IsPrimary = true
	}
	implicitDefaultValue := column.GetDefaultValue()
	if column.SqlType == "datetime" {
		implicitDefaultValue = strings.Trim(implicitDefaultValue, "'")
	}
	if slice[4] != nil && string(slice[4].([]byte)) != implicitDefaultValue {
		column.DefaultValue = string(slice[4].([]byte))
	}
	if slice[5] != nil && string(slice[5].([]byte)) == "auto_increment" {
		autoIncrement = true
	}
	return column, autoIncrement
}

func (provider *mysqlProvider) getAutoIncrement(tableName string) int {
	queryStr := fmt.Sprintf("SELECT `AUTO_INCREMENT` FROM  INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = '%v'", tableName)
	q := provider.DB().Query(queryStr)
	q.Next()
	return int(q.CurrentRow()[0].(int64))
}

func (provider *mysqlProvider) readIndexes(table *schema.Table) []*schema.Index {
	queryStr := "SHOW INDEXES FROM " + table.Name
	var indexes []*schema.Index
	q := provider.DB().Query(queryStr)
	for q.Next() {
		if string(q.CurrentRow()[2].([]byte)) == "PRIMARY" {
			continue
		}
		index := new(schema.Index)
		index.Name = string(q.CurrentRow()[2].([]byte))
		if strings.HasPrefix(index.Name, "U_") {
			index.Unique = true
		}
		index.Column = string(q.CurrentRow()[4].([]byte))
		indexes = append(indexes, index)
	}
	sort.SliceStable(indexes, func(i, j int) bool {
		return indexes[i].Name < indexes[j].Name
	})
	return indexes
}
