#!/bin/bash

#this file should be in the same folder as object-types.sql!!!!!
pathToCurrentFile=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
pathToSqlFile=$pathToCurrentFile


result=$(sqlplus -s dietplan/dietplan << EOF
commit;
@$pathToSqlFile/compile-all-for-debug.sql;
/
commit;
exit
EOF
)


if [[ $result == *"error"* ]] || [[ $result == *"warning"* ]]
then
errorMessages=$(sqlplus -s dietplan/dietplan << EOF
set serveroutput on;
set feedback off;
set verify off;
@$pathToSqlFile/fetch-error-messages.sql;
/
exit
EOF
)
echo $errorMessages
else
echo 'db objects successully compiled'
fi






