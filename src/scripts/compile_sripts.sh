#!/bin/bash

go get -u github.com/spf13/viper
go get -u github.com/go-sql-driver/mysql

# Compile Linux Binaries for 32-bit and 64-bit
GOOS=linux
GOARCH=amd64
go build -v -o bin/linux/export_to_json src/export_to_json.go 
go build -v -o bin/linux/concat src/concat.go 

# Compile Windows 32bit and 64bit binaries
GOOS=windows
GOARCH=amd64
go build -v -o bin/windows/export_to_json.exe src/export_to_json.go 
go build -v -o bin/windows/concat.exe src/concat.go 

# Compile Macos
GOOS=darwin
GOARCH=amd64
go build -v -o bin/macos/export_to_json src/export_to_json.go 
go build -v -o bin/macos/concat src/concat.go

