package db

import (
	"database/sql"
	"fmt"
	"sort"
	"strings"

	_ "github.com/mattn/go-sqlite3"
)

type sqliteProvider struct {
	db               *sql.DB
	connectionString string
}

func (provider *sqliteProvider) SetConnectionString(connectionString string) {
	provider.connectionString = connectionString
}

func (provider *sqliteProvider) GetConnection() *sql.DB {
	if provider.db == nil {
		db, err := sql.Open("sqlite3", provider.connectionString)

		if err != nil {
			panic(fmt.Errorf("failed to connect to database. %s", err))
		}
		provider.db = db
	}
	return provider.db
}

func (provider *sqliteProvider) CloseConnection() {
	provider.db.Close()
}

func (provider *sqliteProvider) GetCreateStatement(table Table) string {
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

			if defaultValue == "" {
				stmt += " DEFAULT NULL"
			} else if col.IsNumber() {
				stmt += " DEFAULT " + strings.Trim(defaultValue, "'")
			} else {
				stmt += " DEFAULT " + defaultValue
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

func (provider *sqliteProvider) ReadTableSchema(tableName string) *Table {
	table := NewTable(tableName)
	sqlite_sequence := getValuesFromQuery(provider, fmt.Sprintf("SELECT seq FROM sqlite_sequence WHERE name = '%v'", tableName))
	if len(sqlite_sequence) > 0 {
		table.AutoIncrement = int(sqlite_sequence[0][0].(int64)) + 1
	} else {
		schemaStatement := getValuesFromQuery(provider, fmt.Sprintf("select sql from sqlite_master where tbl_name = '%v'", tableName))[0][0].(string)
		if strings.Contains(schemaStatement, "AUTOINCREMENT") {
			table.AutoIncrement = 1
		}
	}

	for _, slice := range getValuesFromQuery(provider, fmt.Sprintf("PRAGMA table_info('%v')", tableName)) {
		column := new(TableColumn)
		column.Name = slice[1].(string)
		column.SqlType = strings.ToLower(slice[2].(string))
		if strings.HasPrefix(column.SqlType, "unsigned") {
			column.SqlType = strings.Join([]string{strings.Split(column.SqlType, " ")[1], strings.Split(column.SqlType, " ")[0]}, " ")
		}
		if column.SqlType == "integer" {
			fmt.Printf("Cannot infer specific type from INTEGER for \"%v.%v\". Default to bigint.\n", table.Name, column.Name)
			column.SqlType = "bigint(20)"
		}
		if slice[3].(int64) == 1 {
			column.NotNull = true
		}

		implicitDefaultValue := column.GetDefaultValue()
		if column.IsNumber() {
			implicitDefaultValue = strings.Trim(implicitDefaultValue, "'")
		}

		if slice[4] == implicitDefaultValue || slice[4] == nil || slice[4] == "NULL" {
			column.DefaultValue = ""
		} else {
			column.DefaultValue = slice[4].(string)
		}
		table.Columns = append(table.Columns, column)

		if slice[5].(int64) == 1 {
			column.IsPrimary = true
		}
	}
	table.Indexes = provider.readIndexesForTable(table)
	return table
}

func (provider *sqliteProvider) readIndexesForTable(table *Table) []*Index {
	indexNameQuery := fmt.Sprintf("select name from sqlite_schema where `type`='index' and name not like 'sqlite_%%' and tbl_name='%v'", table.Name)
	var indexes []*Index
	for _, slice := range getValuesFromQuery(provider, indexNameQuery) {
		indexName := slice[0].(string)
		columnRefs := getValuesFromQuery(provider, fmt.Sprintf("PRAGMA index_info('%v')", indexName))

		for _, colRef := range columnRefs {
			index := new(Index)
			index.Name = indexName
			if strings.HasPrefix(indexName, "U_") {
				index.Unique = true
			}
			index.Column = colRef[2].(string)
			indexes = append(indexes, index)
		}
	}
	sort.Slice(indexes, func(i, j int) bool {
		return indexes[i].Name < indexes[j].Name
	})
	return indexes
}
