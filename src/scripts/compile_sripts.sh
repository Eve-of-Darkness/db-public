// Used for MacOS 

export GOOS=darwin
export GOARCH=amd64

// Compile concat

go mod init src/concat.go
go get github.com/spf13/viper
go get github.com/go-sql-driver/mysql

go build -o bin/macos/concat src/concat.go 

rm go.mod
rm go.sum

// Compile export_to_json

go mod init src/export_to_json.go
go get github.com/spf13/viper
go get github.com/go-sql-driver/mysql

go build -o bin/macos/export_to_json src/export_to_json.go

rm go.mod
rm go.sum
