Linux and Windows Integration Scripts by Cimitra Version: 1.0

Author: Tay Kratzer tay@cimitra.com

On a Windows 10 box, in a **Bash** terminal on the Windows box:

1. DOWNLOAD AND RUN install script as shown on the next line below, (NOTE: Get the entire next line)

curl -LJO https://raw.githubusercontent.com/cimitrasoftware/blog_scripts/master/port_check_install.sh -o ./ ; chmod +x ./port_check_install.sh  ; ./port_check_install.sh 

2. Now open up a Windows PowerShell terminal and go to the directory c:\linwin and run the command: 

./check_port.ps1 <ip address> <ip port>

Example: 

./check_port.ps1 192.168.99.1 443
