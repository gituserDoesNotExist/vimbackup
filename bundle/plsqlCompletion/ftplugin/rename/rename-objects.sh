#!/bin/bash

oldObjectName=$1
newObjectname=$2
baseDirPlsqlFiles=$3
#this file should be in the same folder as object-types.sql!!!!!
pathToCurrentFile=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
pathToSqlFile=$pathToCurrentFile


if [ -z $oldObjectName ] || [ -z $newObjectname ] || [ -z $baseDirPlsqlFiles ]
then
	echo 'pass old name as first, new name as second parameter and the base directory containing the PLSQL files as third parameter!'
	exit 1
fi

#first parameter: objectname
#echos filepaths (for a package name one has two files: spec and body
function getFilepathsForObject {
	local objectname=$1
	local filepaths=()
	while IFS= read -r -d $'\0'
	do
		filepaths+=($REPLY)
	done < <(find $baseDirPlsqlFiles -type f -iname "$objectname.sql" -print0)
	echo ${filepaths[@]}
}



#find dependent objects
dependentObjectsStr=$(sqlplus -s dietplan/dietplan << EOF
set serveroutput on;
set feedback off;
set verify off;
@$pathToSqlFile/find-dependent-objects.sql $oldObjectName
/
exit;
EOF
)
dependentObjectsStr=${dependentObjectsStr//[[:space:]]/}
dependentObjects=$(IFS=';'; read -r -a files <<< $dependentObjectsStr; echo ${files[@]})


#renaming dependent files
for objectname in ${dependentObjects[@]}
do
	filepaths=$(getFilepathsForObject $objectname)
	for filepath in ${filepaths[@]}
	do
		if [ -f $filepath ]
		then
			echo 'renaming' $oldObjectName 'to' $newObjectname 'in depending object' $filepath
			echo $(cat $filepath | sed "s/\<$oldObjectName\>/$newObjectname/Ig") > $filepath
		else
			echo 'file' $filepath 'does not exist!'
		fi
	done
done

#perform renaming in actual file (i.e. the object you want to rename)
filepathsActualFile=$(getFilepathsForObject $oldObjectName) 

for filepathActualFile in ${filepathsActualFile[@]}
do
	if [ -f $filepathActualFile ]
	then
		echo 'renaming' $oldObjectName 'to' $newObjectname 'in actual file' $filepathActualFile '...'
		folderpathActualFile=$(dirname $filepathActualFile)
		echo "... and renaming file $filepathActualFile to $folderpathActualFile/$newObjectname.sql"
		echo $(cat $filepathActualFile | sed "s/\<$oldObjectName\>/$newObjectname/Ig") > $folderpathActualFile/$newObjectname.sql
		rm $filepathActualFile
	fi
done











