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
dependentObjectsStr=$(sqlplus -s es_metadata/es_metadata << EOF
set serveroutput on;
set feedback off;
set verify off;
declare
dependent_objects varchar2(10000);
begin
dependent_objects:=es_metadata.metadata_info.find_dependent_objects('$oldObjectName');
dbms_output.put_line(dependent_objects);
end;
/
exit;
EOF
)

dependentObjectsStr=${dependentObjectsStr//[[:space:]]/}
dependentObjects=$(IFS=';'; read -r -a files <<< $dependentObjectsStr; echo ${files[@]})

echo "the following objects depend on $oldObjectName and will be modified..."
for object in ${dependentObjects[@]}
do
	echo $object
done

echo 'continue? [y(yes)/n(no)]'
read -r userInput

if [[ $userInput != 'y' ]]
then
	echo 'nothing to do...'
	exit 0
fi


#renaming dependent files
for objectname in ${dependentObjects[@]}
do
	filepaths=($(getFilepathsForObject $objectname))
	for filepath in ${filepaths[@]}
	do
		if [ ! -f $filepath ]
		then
			echo 'file' $filepath 'does not exist!'
		else
			dirCurrentFile=${filepath%/*}
			filenameWithExtension=${filepath##*/}
			filenameWithoutExtension=${filenameWithExtension%.*}
			tmpFilepath=${dirCurrentFile}/${filenameWithoutExtension}_TMP.sql
			echo 'renaming' $oldObjectName 'to' $newObjectname 'in depending object' $tmpFilepath
			cat $filepath | sed "s/\<$oldObjectName\>/$newObjectname/Ig" > $tmpFilepath
			kdiff3 $filepath $filepath $tmpFilepath -o $tmpFilepath --cs CreateBakFiles=0 #do no create .orig files
			echo 'apply change? [y(yes)/n(no)]'
			read -r userInputApplyChange
			if [[ $userInputApplyChange = 'y' ]]
			then
				rm $filepath
				mv $tmpFilepath	$filepath
			else
				rm $tmpFilepath
			fi
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
		folderpathActualFile=${filepathActualFile%/*}
		newFilename=${folderpathActualFile}/${newObjectname}.sql
		echo "... and renaming file $filepathActualFile to $newFilename"
		cat $filepathActualFile | sed "s/\<$oldObjectName\>/$newObjectname/Ig" > $newFilename
		kdiff3 $filepathActualFile $filepathActualFile $newFilename -o $newFilename --cs CreateBakFiles=0 #do no create .orig files
		echo 'apply change? [y(yes)/n(no)]'
		read -r userInputApplyChange
		if [[ $userInputApplyChange = 'y' ]]
		then
			rm $filepathActualFile
		else
			rm $newFilename
		fi
	fi
done









