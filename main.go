package main

import (
	"flag"
	"os"
)

func main() {
	importFlag := flag.Bool("import", false, "Import your SQL database to JSON database found in data folder.")
	exportType := flag.String("export", "mysql", "Export Public-DB as SQL query. Possible values are \"mysql\", \"sqlite\", \"update-only\"")
	updateOnly := flag.Bool("update-only", false, "Set to export SQL query to replace static content, but keep player content untouched.")
	flag.Parse()

	if *importFlag {
		importToJson()
		return
	}

	exportToSql(*exportType, *updateOnly)
}

func getFiles(dir string) []string {
	files, err := os.ReadDir(dir)
	if err != nil {
		panic(err)
	}

	fileNames := make([]string, len(files))

	i := 0
	for _, f := range files {
		fileNames[i] = f.Name()
		i++
	}

	return fileNames
}
