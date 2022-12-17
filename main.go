package main

func main() {
	config := LoadConfig()

	if config.ImportFlag {
		importToJson(config)
	} else {
		exportToSql(config)
	}
}
