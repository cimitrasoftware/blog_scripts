# [ SCRIPT INFORMATION SECTION ]
# ------------------------------
# This script takes in two parameters call it in this manner: ./port_check.ps1 <address> <port>
# Author: Tay Kratzer tay@cimitra.com
# [ UNUSED METHOD, USING AN IO FILE  ]
# This is a file for communicating between PowerShell and Bash
# $IO_FILE="c:\linwin\io.txt"
# Remove the file if it is there
# Remove-Item $IO_FILE 2> $null
$ExecutingScript = $MyInvocation.MyCommand.Name
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

function HELP_SCREEN{
Write-Output ""
Write-Output "Check Port Tool"
Write-Output ""
Write-Output "Use Syntax: ./$ExecutingScript address port"
Write-Output ""
Write-Output "Example | ./$ExecutingScript 192.168.99.1 443"
Write-Output ""
CALL_EXIT "1"
}

# If they didn't enter 2 arguments, show the Help Screen
if ($args[1] -eq $null){
HELP_SCREEN
}

# This function is just an output function to inform
function WSL_INFORM{
Write-Output ""
Write-Output "Error: Install Windows Subsystem for Linux to use this script"
Write-Output ""
CALL_EXIT "1"
}

# This function determine if Windows Subsystem for Linux is installed
function WSL_CHECK{

Get-Command bash 1> $null 2> $null
# Capture Get-Command return code
$RETURN_CODE=$?

    if ($RETURN_CODE -eq $false){
        WSL_INFORM
    }

}


function main {

# Check for Windows Subsystem for Linux
WSL_CHECK

# Make a friendly user experience
Write-Output ""
Write-Output "Process: Checking Address and Port ${SERVER_ADDRESS}:${SERVER_PORT}"
Write-Output ""
# [ UNUSED METHOD, USING AN IO FILE  ]
# Add the two parameters passed in to this script to an I/O File
# Add-Content -Path $IO_FILE -Value("SERVER_ADDRESS=${SERVER_ADDRESS}")
# Add-Content -Path $IO_FILE -Value("SERVER_PORT=${SERVER_PORT}")

# Run Bash, tell it to run the port_check Bash script
C:\Windows\System32\bash.exe -l -c "/mnt/c/linwin/port_check.sh ${SERVER_ADDRESS} ${SERVER_PORT}" 1> $null 2> $null

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