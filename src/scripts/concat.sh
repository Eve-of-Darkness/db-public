#!/bin/bash -l

file_name="public-db.sql"

if [ -e "./$file_name" ]; then
  rm "./$file_name"
fi

for file in src/schema/*.sql; do
  table=$(basename $file .sql)

  echo "DROP TABLE IF EXISTS \`$table\`;" >> $file_name

  cat $file >> $file_name

  if [ -e "./src/data/$table.sql" ]; then
    cat "./src/data/$table.sql" >> $file_name
  fi
done
