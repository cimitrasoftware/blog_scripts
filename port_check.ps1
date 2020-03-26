# This is a file for communicating between PowerShell and Bash
# NOTE: ** You may also need to change the content of the line that calls bash.exe **
# [ CHANGE IO_FILE LOCATION VARIABLE BELOW  ]

$IO_FILE="c:\linwin\io.txt"

# [ CHANGE IO_FILE LOCATION VARIABLE ABOVE  ]

#
# [ SCRIPT INFORMATION SECTION ]
# ------------------------------
# This script takes in two parameters call it in this manner: ./port_check.ps1 <address> <port>
# Author: Tay Kratzer tay@cimitra.com
# GitHub Location: https://github.com/cimitrasoftware/blog_scripts/blob/master/port_check.ps1
# This script has a dependency on the port_check.sh Bash script
# Get Bash Script Here...
#
# C:\Windows\System32\curl.exe -LJO https://raw.githubusercontent.com/cimitrasoftware/blog_scripts/master/port_check.sh
# 
# NOTE: Get the latest version of this PowerShell Script Here...
#
# C:\Windows\System32\curl.exe -LJO https://raw.githubusercontent.com/cimitrasoftware/blog_scripts/master/port_check.ps1
# ------------------------------

# Remove the file if it is there
Remove-Item $IO_FILE 2> $null

# Get the first argument and assign it to $SERVER_ADDRESS
$SERVER_ADDRESS=$args[0]
# Get the second argument and assign it to $SERVER_PORT
$SERVER_PORT=$args[1]

# This function properly exits the script with a "exit code" that is useful if this script is called from another script
function CALL_EXIT {
$EXIT_CODE=$args[0]
Write-Output ""
exit $EXIT_CODE
}

function main {
# Make a friendly user experience
Write-Output ""
Write-Output "Process: Checking Address and Port ${SERVER_ADDRESS}:${SERVER_PORT}"
Write-Output ""
# Add the two parameters passed in to this script to the communication file
Add-Content -Path $IO_FILE -Value("SERVER_ADDRESS=${SERVER_ADDRESS}")
Add-Content -Path $IO_FILE -Value("SERVER_PORT=${SERVER_PORT}")

# Run Bash, tell it to run the port_check Bash script
C:\Windows\System32\bash.exe -l -c "/mnt/c/linwin/port_check.sh" 1> $null 2> $null

# Capture the return code from the Bash script
$RETURN_CODE=$?

if($RETURN_CODE){
Write-Output "Success: The Address and Port Are Open"
CALL_EXIT "0"
}else{
Write-Output "Fail: The Address and Port Aren't Open"
CALL_EXIT "1"
}


}

main