#!/bin/bash

# This program does some validity checks (like checking whether the number of columns to insert matches the number of headers in the CSV file) and then inserts the new data into our schema.

database=$1
table=$2
currentDirectory=`pwd`
writeToTable=$3
arg3wc=`echo $writeToTable | tr ',' ' ' | wc -w `

if [ -d $database ]; then
	checkCSV=`head "-1" $currentDirectory/$database/$table | tr ',' ' ' | wc -w `
	if [ -f $currentDirectory/$database/$table ]; then
		if [ "$arg3wc" -eq $checkCSV ]; then
			./lockDB.sh $currentDirectory/$database/$table
			printf "$3\n" >> $currentDirectory/$database/$table
			echo Data successfully added.
			./unlockDB.sh $currentDirectory/$database/$table
			exit 0
		fi
	else
		echo $table does not exist in `pwd` >&2
		exit 2
	fi
else
	echo $database does not exist at `pwd` >&2
	exit 1
fi
