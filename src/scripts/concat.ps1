$fileName = "public-db.sql"

if(Test-Path ./$fileName){
    Remove-Item ./$fileName    
}

Get-ChildItem ../schema -Filter *.sql | ForEach-Object {
    # drop table if exists
    Add-Content .\$fileName "DROP TABLE IF EXISTS ``$($_.Name.Substring(0, $_.Name.Length - 4))``;`n"
    
    # inject schema create script    
    Get-Content $_.FullName | Out-File -Encoding ASCII -Append .\$fileName

    # if schema file has a mirroring data file, inject it
    if(Test-Path "$($_.directoryname)\..\data\$($_)"){
        Get-Content "$($_.directoryname)\..\data\$($_)" | out-file -encoding ascii -append .\$filename      
    }
}