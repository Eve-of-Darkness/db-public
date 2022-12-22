package main

import (
	"fmt"
	"sort"
	"strings"
)

type Table struct {
	Name          string
	Columns       []*TableColumn
	primaryColumn *TableColumn
	Indexes       []*Index `json:",omitempty"`
	AutoIncrement int      `json:",omitempty"`
	Static        bool     `json:",omitempty"`
}

type Index struct {
	Name    string
	Columns []string
	Unique  bool `json:",omitempty"`
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
	index := new(Index)
	index.Name = "U_" + t.Name + "_" + col.Name
	index.Columns = append(index.Columns, col.Name)
	index.Unique = true
	t.Indexes = append(t.Indexes, index)
	return col
}

func (t *Table) AddWithIndex(name string, sqlType string) *TableColumn {
	col := t.Add(name, sqlType)
	index := new(Index)
	index.Name = "I_" + t.Name + "_" + col.Name
	index.Columns = append(index.Columns, col.Name)
	t.Indexes = append(t.Indexes, index)
	return col
}

func (t *Table) AddPrimary(name string, sqlType string) *TableColumn {
	col := t.Add(name, sqlType)
	col.IsPrimary = true
	t.primaryColumn = col
	return col
}

func (t *Table) GetColumn(columnName string) *TableColumn {
	for _, col := range t.Columns {
		if col.Name == columnName {
			return col
		}
	}
	return nil
}

func (t *Table) GetPrimaryColumn() *TableColumn {
	if t.primaryColumn != nil {
		return t.primaryColumn
	}
	for _, c := range t.Columns {
		if c.IsPrimary {
			return c
		}
	}
	panic(fmt.Sprintf("Primary column for %v missing", t.Name))
}

type TableColumn struct {
	Name          string
	SqlType       string
	NotNull       bool   `json:",omitempty"`
	AutoIncrement bool   `json:",omitempty"`
	DefaultValue  string `json:",omitempty"`
	IsPrimary     bool   `json:",omitempty"`
}

func (col *TableColumn) NotNullable() *TableColumn {
	col.NotNull = true
	return col
}

func (col *TableColumn) SetDefault(defaultValue string) *TableColumn {
	col.DefaultValue = defaultValue
	return col
}

func findTableIndex(tableName string, tables []Table) int {
	for i, t := range tables {
		if strings.EqualFold(tableName, t.Name) {
			return i
		}
	}
	return -1
}

func findTable(tableName string, tables []Table) *Table {
	matchedIndex := findTableIndex(tableName, tables)
	if matchedIndex >= 0 {
		return &tables[matchedIndex]
	} else {
		return nil
	}
}

func sortTables(tables []Table) {
	sort.Slice(tables, func(i, j int) bool {
		return tables[i].Name < tables[j].Name
	})
}
