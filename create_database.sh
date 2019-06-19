#!/bin/bash

# This program create's a database (folder) based on the argument provided to the script upon execution.

filename=$1

if [ "$#" -eq 0 ]; then
	echo Error: No parameter provided 
	exit 1
elif [ -d $filename ]; then
	echo Error: Database already exists
	exit 1
else
	mkdir $1
	echo OK: Database created 
	exit 0
fi
