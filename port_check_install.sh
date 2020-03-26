#!/bin/bash
# This is a file for communicating between PowerShell and Bash
# Change the variable below according to your configuration
# [ CHANGE IO_FILE LOCATION VARIABLE BELOW  ]

PROGRAM_DIR="/mnt/c/linwin"

function main()
{
# Make the directory where the scripts will be saved
mkdir -p ${PROGRAM_DIR} 2> /dev/null
# Attempt to change to the directory where the scripts will be saved
cd ${PROGRAM_DIR} 2> /dev/null
# Determine if changing to the PROGRAM_DIR directory worked
declare -i SUCCESS_STATUS=`echo $?`
# If changing to the directory failed, exit
if [ $SUCCESS_STATUS -ne 0 ]
then
echo ""
echo "Error: Insufficient rights to create and access directory: ${INSTALL_DIR}"
echo ""
exit 1
fi

# Download the scripts and the readme file
echo ""
echo "Process: Downloading the Port Check Bash Script"
echo ""
curl -LJO https://raw.githubusercontent.com/cimitrasoftware/blog_scripts/master/port_check.sh
echo ""
echo "Process: Downloading the Port Check PowerShell Script"
echo ""
curl -LJO https://raw.githubusercontent.com/cimitrasoftware/blog_scripts/master/port_check.ps1
chmod +x ./port_check.sh 2> /dev/null
echo "Now read the instructions"
echo ""
curl -LJO https://raw.githubusercontent.com/cimitrasoftware/blog_scripts/master/README.md
cat ./README.md

}

# Run the main function
main
