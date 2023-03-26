package utils

import (
	"os"
	"path/filepath"
	"strings"
)

func RootFolder() string {
	if strings.Contains(os.Args[0], "go-build") {
		return "."
	}
	exePath, err := os.Executable()
	if err != nil {
		panic(err)
	}
	return filepath.Dir(exePath)
}
