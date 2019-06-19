#!/bin/bash

# This program identifies whether the target schema exists, and then requests the data we want back from the table. It ensures the number of columns requested is 1 or greater and less than the total number in the schema. If all is true, it shall print the results (in column numerical order).

currentDirectory=`pwd`
database=$1
table=$2
columns=$3
colSep=$(echo $columns | tr ',' ' ')
array_col=( $colSep ) # array of columns we want to return

if [ -d $database ]; then
	if [ -f $currentDirectory/$database/$table ]; then
		./lockDB.sh $currentDirectory/$database/$table
		tableHeader=$(head -1 "$currentDirectory/$database/$table" | sed 's/,/ /g') # replace commas with spaces (easier to create array)

		array_table_head=( $tableHeader ) # create array from tableHeader

		last_column_index="${array_col[-1]}" # get last column index value

		fix_last_column_index=`(expr "$last_column_index" - 1)` # since we are using cut, the requests must be made with 1,2,3 where 1 is the first column in the file. However, when not using cut, the starting point is 0. We must -1 from the last index to check if the range that the user requests exists in our table (non-cut), and then output (with cut). This value is just for validity checking.

		for k in ${!array_table_head[@]}; do
			boolean=1 # set the boolean to false
			if [ $fix_last_column_index = $k ]; then
				boolean=0 # if the col exists based on its true value, change the boolean to true and break
				break
			fi
		done
		
		if [ $boolean -ne 0 ]; then
			echo Column $last_column_index does not exist in $table. Please redo your search with different parameters.
			./unlockDB.sh $currentDirectory/$database/$table
			exit 1
		fi
		
		for i in "${array_col[@]}";do
			if [ ${array_col[0]} -eq 0 ]; then
                        	echo Please modify your search. Columns start from 1 '(not 0)'.
				./unlockDB.sh $currentDirectory/$database/$table
                        	exit 1
			fi
		done
# For each indices in the tableHeader array, replace the tableHeader value with	i+1, which then becomes the table header.
		for i in "${!tableHeader[@]}"; do
			columns=$(echo "$columns" | sed "s/${tableHeader[$i]}/$((i+1))/g")
		done

		echo start_result 
		# get the results from the sed operation
		cut -d',' -f$columns $currentDirectory/$database/$table
		echo end_result
		./unlockDB.sh $currentDirectory/$database/$table
		exit 0
	fi
fi
