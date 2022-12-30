package db

import "database/sql"

type QueryResults struct {
	headers    []string
	rows       *sql.Rows
	currentRow []any
	rowPtrs    []any
}

func GetQueryResults(rows *sql.Rows) *QueryResults {
	res := new(QueryResults)
	res.headers, _ = rows.Columns()
	res.rows = rows
	columns, _ := res.rows.Columns()
	colCount := len(columns)
	res.currentRow = make([]any, colCount)
	res.rowPtrs = make([]any, colCount)
	for i := 0; i < colCount; i++ {
		res.rowPtrs[i] = &res.currentRow[i]
	}
	return res
}

func (q *QueryResults) Next() bool {
	rows := q.rows
	ok := rows.Next()
	if !ok {
		return false
	}
	rows.Scan(q.rowPtrs...)
	return true
}

func (q *QueryResults) Headers() []string {
	return q.headers
}

func (q *QueryResults) CurrentRow() []any {
	return q.currentRow
}
