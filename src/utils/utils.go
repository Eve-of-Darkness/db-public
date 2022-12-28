package utils

import (
	"path/filepath"
	"runtime"
)

func RootFolder() string {
	_, b, _, _ := runtime.Caller(0)
	basepath := filepath.Dir(filepath.Dir(filepath.Dir(b)))
	return basepath
}
