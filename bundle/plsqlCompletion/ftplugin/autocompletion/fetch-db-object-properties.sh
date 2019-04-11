#!/bin/bash

objectname=$1
#this file should be in the same folder as object-types.sql!!!!!
pathToCurrentFile=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
pathToObjectTypesFile=$pathToCurrentFile

if [ -z $objectname ] 
then
	echo 'pass objectname as first parameter!'
	exit 1
fi


result=$(sqlplus -s dietplan/dietplan << EOF
set serveroutput on;
set feedback off;
set verify off;
@$pathToObjectTypesFile/object-types.sql $objectname
/
exit;
EOF
)


echo $result
