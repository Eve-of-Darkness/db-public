package main

import (
	"flag"
	"io/ioutil"
)

func main() {
	importFlag := flag.Bool("import", false, "Import your SQL database to JSON database found in data folder.")
	exportType := flag.String("export", "mysql", "Export Public-DB as SQL query. Possible values are \"mysql\", \"sqlite\", \"update-only\"")
	flag.Parse()

	if *importFlag {
		importToJson()
		return
	}

	exportToSql(*exportType)
}

func getFiles(dir string) []string {
	files, err := ioutil.ReadDir(dir)
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
