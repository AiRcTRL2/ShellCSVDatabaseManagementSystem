#!/bin/bash

# This program checks the validity of its arguments, and if true, creates a schema inside the existing database.

filename=$2
dirname=$1

install=`pwd` # get current directory

if [ "$#" -ne 3 ]; then
        echo The number of paramaters is wrong.
        exit 1
else
 	if [ -d $install/$dirname ]; then
		./lockDB.sh $install/$dirname
		if [ -f $install/$dirname/$filename ]; then
			echo $filename already exists in `pwd`
			./unlockDB.sh $install/$dirname
			exit 1
       		else	
			touch $install/$dirname/$filename
			printf "$3\n" >> $install/$dirname/$filename
			echo OK: table created
			./unlockDB.sh $install/$dirname
			exit 0
		fi

	fi
fi
