package db

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
