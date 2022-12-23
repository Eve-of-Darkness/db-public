package db

type Index struct {
	Name    string
	Columns []string
	Unique  bool `json:",omitempty"`
}
