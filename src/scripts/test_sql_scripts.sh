#!/bin/bash -l

export MYSQL_PWD=root
result=0

for file in ../customizations/*.sql; do
  echo "Testing [$file]"
  # run each script inside of a transaction to ensure it doesn't change the db
  # and then rollback at the end of it
  echo "START TRANSACTION;$(cat $file);ROLLBACK;" | \
    mysql -u root --password=root -h 127.0.0.1 -P 3307 -D dol
  run=$?
  result=$((result+run))
  echo -e "\n"
done

exit $result;
