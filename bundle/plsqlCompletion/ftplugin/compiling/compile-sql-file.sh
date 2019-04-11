#!/bin/bash

#Full filename (path+name) must be passed as first and only parameter!

filename=$1

pathToCurrentFile=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
pathToFetchErrorsFile=$pathToCurrentFile


if [ -z $filename ]
then
	echo 'you have to pass the filepath (path+name) as parameter!'
	exit 1
fi

if [[ $filename != *".sql" ]]
then
	echo 'you should pass an sql file!'
	exit 1 
fi


result=$(sqlplus -s dietplan/dietplan << EOF
COMMIT;
@$filename
.
RUN
COMMIT;
exit
EOF
)


if [[ $result == *"error"* ]]
then
errorMessage=$(sqlplus -s dietplan/dietplan << EOF
set serveroutput on;
set feedback off;
set verify off;
@$pathToFetchErrorsFile/fetch-error-messages.sql
/
exit
EOF
)
echo $errorMessage
else
echo 'db object successfully created'
fi



