package main

import (
	"sort"
	"strings"
)

type Table struct {
	Name          string
	Columns       []*TableColumn
	PrimaryColumn *TableColumn
	UniqueIndexes []*TableColumn
	Indexes       []*Index
	AutoIncrement int
	Static        bool
}

type Index struct {
	Name string
	Keys []*TableColumn
}

func newTable(name string) *Table {
	result := new(Table)
	result.Name = name
	return result
}

func (t *Table) Add(name string, sqlType string) *TableColumn {
	col := new(TableColumn)
	col.Name = name
	col.SqlType = sqlType
	col.AutoIncrement = false
	col.NotNull = false
	t.Columns = append(t.Columns, col)
	return col
}

func (t *Table) AddUnique(name string, sqlType string) *TableColumn {
	col := t.Add(name, sqlType)
	t.UniqueIndexes = append(t.UniqueIndexes, col)
	return col
}

func (t *Table) AddWithIndex(name string, sqlType string) *TableColumn {
	col := t.Add(name, sqlType)
	index := new(Index)
	indexName := "I_" + t.Name + "_" + col.Name
	index.Name = indexName
	index.Keys = append(index.Keys, col)
	t.Indexes = append(t.Indexes, index)
	return col
}

func (t *Table) AddPrimary(name string, sqlType string) *TableColumn {
	col := t.Add(name, sqlType)
	t.PrimaryColumn = col
	return col
}

type TableColumn struct {
	Name          string
	SqlType       string
	NotNull       bool
	AutoIncrement bool
	DefaultValue  string
}

func (col *TableColumn) NotNullable() *TableColumn {
	col.NotNull = true
	return col
}

func (col *TableColumn) SetDefault(defaultValue string) *TableColumn {
	col.DefaultValue = defaultValue
	return col
}

func searchInTables(tableName string, tables []Table) int {
	for i, t := range tables {
		if strings.EqualFold(tableName, t.Name) {
			return i
		}
	}
	return -1
}

func sortTables(tables []Table) {
	sort.Slice(tables, func(i, j int) bool {
		return tables[i].Name < tables[j].Name
	})
}
