#execution policy manipulation
get-executionpolicy -list
Set-ExecutionPolicy Bypass -Scope Process -Force
set-executionpolicy remotesigned

#Disable the the hyper-v hypervisor on next boot
bcdedit /set hypervisorlaunchtype off

#Enable the the hyper-v hypervisor on next boot
bcdedit /set hypervisorlaunchtype auto

