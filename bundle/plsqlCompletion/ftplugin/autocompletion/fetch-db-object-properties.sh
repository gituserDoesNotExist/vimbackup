#!/bin/bash

objectname=$1
#this file should be in the same folder as object-types.sql!!!!!
pathToCurrentFile=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
pathToSqlFile=$pathToCurrentFile

if [ -z $objectname ] 
then
	echo 'pass objectname as first parameter!'
	exit 1
fi

result=$(sqlplus -s es_metadata/es_metadata << EOF
set serveroutput on;
set feedback off;
set verify off;
execute dbms_output.put_line('hello world' || '$objectname');
exit;
EOF
)

#@$pathToSqlFile/call-metadata-info.sql $objectname

echo $result
