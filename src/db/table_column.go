package db

import "strings"

type TableColumn struct {
	Name         string
	SqlType      string
	NotNull      bool   `json:",omitempty"`
	DefaultValue string `json:",omitempty"`
	IsPrimary    bool   `json:",omitempty"`
}

func (col *TableColumn) NotNullable() *TableColumn {
	col.NotNull = true
	return col
}

func (col *TableColumn) GetDefaultValue() string {
	if !(col.DefaultValue == "" || strings.ToLower(col.DefaultValue) == "null") {
		return col.DefaultValue
	}

	if !col.NotNull {
		return ""
	} else if col.IsNumber() {
		return "'0'"
	} else if col.SqlType == "datetime" {
		return "'2000-01-01 00:00:00'"
	} else {
		return "''"
	}
}

func (col *TableColumn) IsNumber() bool {
	return strings.Contains(col.SqlType, "int") || col.SqlType == "double" || col.SqlType == "float" || col.SqlType == "real"
}
