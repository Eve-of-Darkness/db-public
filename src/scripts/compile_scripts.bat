go get -u github.com\spf13\viper
go get -u github.com\go-sql-driver\mysql

REM Compile Linux Binaries for 32-bit and 64-bit
set GOOS=linux
set GOARCH=amd64
go build -v -o bin/linux/export_to_json src/export_to_json.go 
go build -v -o bin/linux/concat src/concat.go 


REM Compile Windows 32bit and 64bit binaries
set GOOS=windows
set GOARCH=amd64
go build -v -o bin/windows/export_to_json.exe src/export_to_json.go 
go build -v -o bin/windows/concat.exe src/concat.go 