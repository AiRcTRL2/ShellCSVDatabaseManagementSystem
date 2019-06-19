#!/bin/bash

# This program initiates a client log-on. It takes 1 argument when initiating execution, which is our client identification name/number. Then, it lists to stdin for commands to send to the server. Finally, it takes responses from the server by reading its own pipe, and outputting the results to the user.

function ctrl_c() {
	rm "$id.pipe"
	exit 0
}

trap ctrl_c INT

id=$1

if [ "$#" -ne 1 ]; then
	echo User ID not provided. Please try again.
	exit 1
else
	mkfifo "$id.pipe"
	while true; do
		read input
		
		if [ $input = "exit" ]; then
			rm $id.pipe
			echo "Logged off successfully."
			exit 0
		fi 2>/dev/null

		inputArray=( $input )
		checkArgs=${#inputArray[@]} # If > than 4, error. Our server takes 1 parameter for client ID, 1 parameter for script request, and up to 3 parameters for script execution (max 5 args).

		if [ "$checkArgs" -gt 5 ]; then
			echo Number of arguments needs to be less than 4.
			continue
		else
			echo Request: ${inputArray[0]} UserID: $id Request arguments: ${inputArray[@]:1}
			echo $id ${inputArray[0]} ${inputArray[@]:1} > server.pipe
		fi
		
		read output < $id.pipe
		echo $output
		if [ $output = "start_result" ]; then
			while [ $output != "end_result" ]; do
				read output < $id.pipe
				echo $output
			done
		fi 2>/dev/null
	done
fi 
