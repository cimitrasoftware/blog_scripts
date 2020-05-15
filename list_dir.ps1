# [ SCRIPT INFORMATION SECTION ]
# ------------------------------
# This script makes a directory listing of a Windows directory from a Linux command
# Author: Tay Kratzer tay@cimitra.com
# Get input for what directory to get a listing of
# Actual Linux command recipe obtained from: https://www.commandlinefu.com/commands/view/24692/graphical-tree-of-sub-directories-with-files

$DIRECTORY_LOCATION=$args[0]
$ExecutingScript = $MyInvocation.MyCommand.Name

# This function properly exits the script with a "exit code" that is useful if this script is called from another script
function CALL_EXIT {
$EXIT_CODE=$args[0]
Write-Output ""
exit $EXIT_CODE
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

# This function is just an output function to inform
function HELP_SCREEN{
Write-Output ""
Write-Output "List Directory Tree Tool"
Write-Output ""
Write-Output "Syntax:  ./$ExecutingScript <directory path>"
Write-Output ""
Write-Output "Example: ./$ExecutingScript c:\linwin"
Write-Output ""
CALL_EXIT "1"
}

function CHECK_PATH{

    # Test to see if the directory location exists
    if ((Test-Path $DIRECTORY_LOCATION) -eq $false){
    HELP_SCREEN
    }
}

# This is the main function
function main{

# Check for Windows Subsystem for Linux
WSL_CHECK

# See if the path input to the script exits
CHECK_PATH

# Create Linux type path
$LINUX_PATH = "/mnt/{0}" -f ($DIRECTORY_LOCATION -replace "\\", "/" -replace " ", "%20" -replace ":", "")

# Make UI
Write-Output ""
Write-Output "[Directory: $DIRECTORY_LOCATION | Contents]"
Write-Output ""
Write-Output ""
Write-Output ""
Write-Output "Directories"
Write-Output ""
Write-Output "-------------------------------------"
Write-Output ""

# Run Linux command 
C:\Windows\System32\bash.exe -l -c "ls -R $LINUX_PATH  | grep ':$' | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g
' -e 's/^/ /' -e 's/-/|/'"

Write-Output ""
Write-Output "-------------------------------------"

# Make UI
Write-Output "Directories & Files"
Write-Output ""
Write-Output "-------------------------------------"
Write-Output ""

# Run Linux command 
C:\Windows\System32\bash.exe -l -c "find ${LINUX_PATH} -print | sed -e 's;[^/]*/;|-- ;g;s;-- |; |;g'" 

Write-Output ""
Write-Output "-------------------------------------"
}

# Call the main function
main