package schema

type Index struct {
	Name   string
	Column string
	Unique bool `json:",omitempty"`
}
