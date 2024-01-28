# Windows Installer Automation
A Powershell project that installs a number of software titles specified in either the "winget_packagelist" or "choco_packagelist" files. 

Before you run bootstrap.ps1, you will need to first set the execution policy with the following two commands:

Set-ExecutionPolicy Bypass -Scope Process
set-executionpolicy remotesigned

Run the bootstrap.ps1 file from an elevated prompt.  .\bootstrap.ps1 -RunAsAdministrator


