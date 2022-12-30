package db

import (
	"github.com/Eve-of-Darkness/db-public/src/db/schema"

	"fmt"
	"sort"
	"strings"

	_ "github.com/mattn/go-sqlite3"
)

type sqliteProvider struct {
	connection       *database
	connectionString string
}

func (provider *sqliteProvider) SetConnectionString(connectionString string) {
	provider.connectionString = connectionString
}

func (provider *sqliteProvider) DB() *database {
	if provider.connection == nil {
		provider.connection = open("sqlite3", provider.connectionString)
	}
	return provider.connection
}

func (provider *sqliteProvider) GetCreateStatement(table schema.Table) string {
	stmt := ""
	if table.IsStatic() {
		stmt += fmt.Sprintf("DROP TABLE IF EXISTS `%v`;\n\n", table.Name)
		stmt += fmt.Sprintf("CREATE TABLE `%v` (", table.Name)
	} else {
		stmt += fmt.Sprintf("CREATE TABLE IF NOT EXISTS `%v` (", table.Name)
	}
	for _, col := range table.Columns {
		sqlTypeIsNumber := col.IsNumber()
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
		if col.IsPrimary && table.AutoIncrement > 0 {
			stmt += " PRIMARY KEY"
			if table.AutoIncrement > 0 {
				stmt += " AUTOINCREMENT"
			}
		} else {
			defaultValue := col.GetDefaultValue()

			stmt += " DEFAULT "
			if defaultValue == "" {
				stmt += "NULL"
			} else if col.IsNumber() {
				stmt += strings.Trim(defaultValue, "'")
			} else {
				stmt += defaultValue
			}
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
	previousIndexName := ""
	for _, i := range table.Indexes {
		if previousIndexName == i.Name {
			stmt = stmt[:len(stmt)-3]
			stmt += fmt.Sprintf(", `%v`);\n", i.Column)
			continue
		}
		stmt += "CREATE"
		if i.Unique {
			stmt += " UNIQUE"
		}
		stmt += fmt.Sprintf(" INDEX `%v` ON `%v` (`%v`);\n", i.Name, table.Name, i.Column)
		previousIndexName = i.Name
	}
	return stmt
}

func (provider *sqliteProvider) GetAllTableNames() []string {
	query := "select name from sqlite_master where `type` = 'table' and name not like 'sqlite_%'"
	results := provider.DB().Query(query)
	var tableNames []string
	for results.Next() {
		tableNames = append(tableNames, results.CurrentRow()[0].(string))
	}
	return tableNames
}

func (provider *sqliteProvider) ReadSchema(tableName string) *schema.Table {
	table := schema.NewTable(tableName)
	results := provider.DB().Query(fmt.Sprintf("SELECT seq FROM sqlite_sequence WHERE name = '%v'", tableName))
	if results.Next() {
		table.AutoIncrement = int(results.CurrentRow()[0].(int64)) + 1
	} else {
		results = provider.DB().Query(fmt.Sprintf("select sql from sqlite_master where tbl_name = '%v'", tableName))
		results.Next()
		schemaStatement := results.CurrentRow()[0].(string)
		if strings.Contains(schemaStatement, "AUTOINCREMENT") {
			table.AutoIncrement = 1
		}
	}

	results = provider.DB().Query(fmt.Sprintf("PRAGMA table_info('%v')", tableName))
	for results.Next() {
		res := results.CurrentRow()
		column := new(schema.TableColumn)
		column.Name = res[1].(string)
		column.SqlType = strings.ToLower(res[2].(string))
		if strings.HasPrefix(column.SqlType, "unsigned") {
			column.SqlType = strings.Join([]string{strings.Split(column.SqlType, " ")[1], strings.Split(column.SqlType, " ")[0]}, " ")
		}
		if column.SqlType == "integer" {
			fmt.Printf("Cannot infer specific type from INTEGER for \"%v.%v\". Default to bigint.\n", table.Name, column.Name)
			column.SqlType = "bigint(20)"
		}
		if res[3].(int64) == 1 {
			column.NotNull = true
		}

		implicitDefaultValue := column.GetDefaultValue()

		if res[4] != implicitDefaultValue && res[4] != nil && res[4] != "NULL" {
			column.DefaultValue = res[4].(string)
		}
		table.Columns = append(table.Columns, column)

		if res[5].(int64) == 1 {
			column.IsPrimary = true
		}
	}
	table.Indexes = provider.readIndexes(table)
	return table
}

func (provider *sqliteProvider) readIndexes(table *schema.Table) []*schema.Index {
	query := fmt.Sprintf("select name from sqlite_schema where `type`='index' and name not like 'sqlite_%%' and tbl_name='%v'", table.Name)
	results := provider.DB().Query(query)
	var indexes []*schema.Index
	for results.Next() {
		indexName := results.CurrentRow()[0].(string)
		indexQueryRes := provider.DB().Query(fmt.Sprintf("PRAGMA index_info('%v')", indexName))

		for indexQueryRes.Next() {
			index := new(schema.Index)
			index.Name = indexName
			index.Unique = provider.isIndexUnique(indexName, table.Name)
			index.Column = indexQueryRes.CurrentRow()[2].(string)
			indexes = append(indexes, index)
		}
	}
	sort.Slice(indexes, func(i, j int) bool {
		return indexes[i].Name < indexes[j].Name
	})
	return indexes
}

func (provider *sqliteProvider) isIndexUnique(indexName string, tableName string) bool {
	res := provider.DB().Query(fmt.Sprintf("PRAGMA INDEX_LIST('%v')", tableName))
	for res.Next() {
		if res.CurrentRow()[1].(string) == indexName && res.CurrentRow()[2].(int64) == 1 {
			return true
		}
	}
	return false
}
