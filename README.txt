This collection of scripts runs a server which handles requests from users that wish to create, change or query existing databases. Instructions on how to use this system follow.

SERVER
______

First, the server must be initiated. Otherwise, our requests will only work by accessing the scripts directly, which is also possible. To enable the server, run the command ./server.sh 

It takes no parameters for valid execution.

CLIENT
______

After starting our server, we must initiate a client log on. To do this, you must run the client script ./client.sh with a parameter (userID).

For example: ./client.sh admin

CREATE DATABASE
______

To create a database, the user must send a request to the server. Our client script listents to stdin. The user may type their request into the terminal. There is no need to enter the clientID again, as this is stored by our client script. The format for creating a database is as follows:

create_database name_of_database

Standalone script executable outside of the server/client functionality with the following (admin testing purposes only):

./create_database.sh database_name

CREATE TABLE
______

Creating a table follows a similar format above, except that we must add some additional information. The format is as follows:

create_table database_name table_name header_name,header_name,header_name

Where argument $3 can take as many header's as required, separated by commas.

Standalone script executable outside of the server/client functionality with the following (admin testing purposes only):

./create_table.sh database_name table_name

INSERT
______

If the user needs to update the table with additional information, the format is as follows:

insert database_name table_name data_1,data_2,data_3

Where each piece of data is separated by a comma in argument $3. This should match the number of headers in the designated table.

Standalone script executable outside of the server/client functionality with the following (admin testing purposes only):

./insert.sh database_name table_name data1,data2,data3

SELECT
______

In order to request columns of information from the schema, the following format should be followed:

select database_name table_name col_required,col_required,col_required 

Where col_required = the number of the column you want returned.

Standalone script executable outside of the server/client functionality with the following (admin testing purposes only):

./select database_name table_name col_req,col_req,col_req

