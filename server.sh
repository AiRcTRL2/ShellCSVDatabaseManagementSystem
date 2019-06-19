#!/bin/bash

# This program listents to its own pipe. Clients send their requests to the pipe. It assigns array values from this request to different variables, then uses those variables to send requests to our scripts. The results are returned to the server, and the server pipes the results back to the client.

function ctrl_c() {
	rm server.pipe
	exit 0
}

trap ctrl_c INT

mkfifo server.pipe

while true; do
	read input < server.pipe	
	inputArray=( $input )
	checkArgs=${#inputArray[@]} # If > than 4, error. Our scripts take maximum 3 args, and 1 arg for calling the script itself.
	request=${inputArray[1]}

	clientID=${inputArray[0]}.pipe

	case "$request" in
		create_database)
			if [ "$checkArgs" -eq 3 ]; then
				./create_database.sh "${inputArray[2]}" > $clientID &
			else
				echo Number of arguments to create a database is incorrect. > $clientID &
			fi
			continue
			;;
		create_table)
			if [ "$checkArgs" -eq 5 ]; then	
				./create_table.sh "${inputArray[2]}" "${inputArray[3]}" "${inputArray[4]}" > $clientID &
			else
				echo Number of arguments to create a table is incorrect. > $clientID &
			fi
			continue
			;;
		insert)
			if [ "$checkArgs" -eq 5 ]; then
				./insert.sh "${inputArray[2]}" "${inputArray[3]}" "${inputArray[4]}" > $clientID &
			else
				echo Number of arguments to insert tuple into table is incorrect. > $clientID &
			fi
			continue
			;;
		select)
			if [ "$checkArgs" -eq 5 ]; then
				./select.sh "${inputArray[2]}" "${inputArray[3]}" "${inputArray[4]}" > $clientID &
			else
				echo Number of arguments to request data from table is incorrect. > $clientID &
			fi
			;;
		shutdown)
			rm server.pipe
			echo Server was shut down successfully. > $clientID &
			exit 0
			;;
		*)
			echo "Error: bad request. Try again." > $clientID &
			continue
			;;
	esac
done

