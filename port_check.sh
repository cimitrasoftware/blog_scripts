#!/bin/bash
# This is a file for communicating between PowerShell and Bash
# Change the variable below according to your configuration
# [ CHANGE IO_FILE LOCATION VARIABLE BELOW  ]

IO_FILE="/mnt/c/linwin/io.txt"

# [ CHANGE IO_FILE LOCATION VARIABLE ABOVE  ]
#
# [ SCRIPT INFORMATION SECTION ]
# ------------------------------
# This script reads 2 varibles ( SERVER_ADDRESS and SERVER_PORT ) from an "IO FILE" and uses those confirm a listening port
# Author: Tay Kratzer tay@cimitra.com
# GitHub Location: https://github.com/cimitrasoftware/blog_scripts/blob/master/port_check.sh
# Get Latest Version: curl -LJO https://raw.githubusercontent.com/cimitrasoftware/blog_scripts/master/port_check.sh
# ------------------------------
# 
# VERBOSE Mode is on by default
#--------------------
declare -i VERBOSE=1
#--------------------

SERVER_ADDRESS="$1"
SERVER_PORT="$2"


# Convert the file from a DOS ASCII file to a Linux ASCII file
sed -i 's/.$//' ${IO_FILE} 2> /dev/null

# This is the function for properly exiting the Bash script
function CALL_EXIT()
{
# Get the first parameter passed to the function assign it to "EXIT_CODE"
EXIT_CODE=$1

if [ $VERBOSE -eq 1 ]
then

	if [ $EXIT_CODE == 0 ]
	then
	echo "Success"
	else
	echo "Failed"
	fi
fi

exit $EXIT_CODE
}

# This is the main function
function main()
{

# Read in the contents of the IO_FILE
if [ -z "$SERVER_ADDRESS" ] || [ -z "$SERVER_PORT" ]
then
SERVER_ADDRESS="bogus"
SERVER_PORT="bogus"
source ${IO_FILE} 2> /dev/null
fi

# Test to see if a "SERVER_ADDRESS" variable is in the IO_FILE
if [ $SERVER_ADDRESS == "bogus" ]
then
CALL_EXIT "1"
fi

# Test to see if a "SERVER_PORT" variable is in the IO_FILE
if [ $SERVER_PORT == "bogus" ]
then
CALL_EXIT "1"
fi

if [ $VERBOSE -eq 1 ]
then
echo "Server Address: ${SERVER_ADDRESS}"
echo "Server Port: ${SERVER_PORT}"
fi

echo "/dev/tcp/${SERVER_ADDRESS}/${SERVER_PORT}"



# I found this gem on the Internet :)
cat < /dev/tcp/${SERVER_ADDRESS}/${SERVER_PORT} & 

# Get the PID of the "cat" command 
CONNECTION_PROCESS=$!

# See if the "cat" command remains in memory few at least a few seconds 
declare -i CONNECTION_PROCESS_WORKED=`ps -aux | grep "${CONNECTION_PROCESS}" | grep -c "cat"`

if [ $CONNECTION_PROCESS_WORKED -gt 0 ]
then
CALL_EXIT 0
else
CALL_EXIT 1
fi
}

# Call the main function
main
