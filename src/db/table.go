package db

import (
	"github.com/Eve-of-Darkness/db-public/src/utils"

	"golang.org/x/exp/slices"

	"encoding/json"
	"fmt"
	"os"
	"path/filepath"
)

type Table struct {
	Name          string
	Columns       []*TableColumn
	primaryColumn *TableColumn
	Indexes       []*Index `json:",omitempty"`
	AutoIncrement int      `json:",omitempty"`
}

func NewTable(name string) *Table {
	result := new(Table)
	result.Name = name
	return result
}

func (t *Table) Add(name string, sqlType string) *TableColumn {
	col := new(TableColumn)
	col.Name = name
	col.SqlType = sqlType
	col.NotNull = false
	t.Columns = append(t.Columns, col)
	return col
}

func (t *Table) AddUnique(name string, sqlType string) *TableColumn {
	col := t.Add(name, sqlType)
	index := new(Index)
	index.Name = "U_" + t.Name + "_" + col.Name
	index.Column = col.Name
	index.Unique = true
	t.Indexes = append(t.Indexes, index)
	return col
}

func (t *Table) AddWithIndex(name string, sqlType string) *TableColumn {
	col := t.Add(name, sqlType)
	index := new(Index)
	index.Name = "I_" + t.Name + "_" + col.Name
	index.Column = col.Name
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

func (t *Table) IsStatic() bool {
	return slices.Contains(GetStaticTableNames(), t.Name)
}

var cachedTables []Table
var cachedStaticTables []string

func GetAllTables() []Table {
	if cachedTables != nil {
		return cachedTables
	}
	var tables []Table
	jsonPath := filepath.Join(utils.RootFolder(), "data", "_TableSchemas.json")
	file, err := os.ReadFile(jsonPath)
	if err != nil {
		panic(err)
	}
	json.Unmarshal(file, &tables)
	cachedTables = tables
	return tables
}

func GetStaticTableNames() []string {
	if cachedStaticTables != nil {
		return cachedStaticTables
	}
	jsonPath := filepath.Join(utils.RootFolder(), "data", "_StaticTables.json")
	content, err := os.ReadFile(jsonPath)
	if err != nil {
		panic(err)
	}
	json.Unmarshal(content, &cachedStaticTables)
	return cachedStaticTables
}
