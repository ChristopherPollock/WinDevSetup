<#
    Prerequisites for runningthis script:
    =====================================
    1. set teh execution policy with:
    Set-ExecutionPolicy Bypass -Scope Process
    set-executionpolicy remotesigned
    2. Run this script as an administrator by adding this switch
    -RunAsAdministrator

    Install Overview Notes:
    =======================
    - Install Windows Subsystem for Linux (WSL)
    - Download and Install WSL2 update
    - Download and install Powershell Core
    - Install Windows Terminal
    - Apply Windows Terminal settings.json file
    - Set up Windows ternminal powerline
    - Install Chocolately
    - Run through packagelist to install each choco package
#>

# Install Windows Subsystem for Linux (WSL)
# Old commmand: Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
write-output "Installing Windows Subsystem for Linux (WSL)"
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

# Download the required update for WSL2
write-output "Installing the WSL2 update from https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi"
$WSLUpdateFile="wsl_update_x64.msi"
Invoke-WebRequest https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi -outfile $WSLUpdateFile
Start-Process .\$WSLUpdateFile  -Wait -ArgumentList '/quiet'
remove-item .\$WSLUpdateFile

# install/Boostrap Chocolatey. Detailed instructions: https://chocolatey.org/install
$Chocoinstalled = $false
if (get-command choco.exe -ErrorAction SilentlyContinue){
    $Chocoinstalled = $true
}

if (!$Chocoinstalled) {
    Write-Output "About to install Chocolately"
    Set-ExecutionPolicy Bypass -Scope Process -Force
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

#Choco Intallations installs from community repo: https://chocolatey.org/packages
Get-Content ".\packagelist" | ForEach-Object {$_ -split "\r\n"} | ForEach-Object {choco install -y $_}

# Download Powershell Core installer
$PSInstaller="PowerShell-7.1.0-win-x64.msi"
write-output "Downloading Powershell Core installer"
Invoke-WebRequest https://github.com/PowerShell/PowerShell/releases/download/v7.1.0/PowerShell-7.1.0-win-x64.msi -outfile  $PSInstaller
Start-Process .\$PSInstaller  -Wait -ArgumentList '/quiet'
remove-item .\$PSInstaller

# PowerLine for Windows Terminal install posh-git and oh-my-posh
write-output "Installing posh-git and oh-my-posh in support of powerline customization for Windows Terminal"
install-module oh-my-posh -scope CurrentUser -force
install-module posh-git -Scope CurrentUser -force

# PowerLine Cascadia font download and install for Powerline Customization
write-output "Downloading Cascadia font for powerline customization"
Invoke-WebRequest https://github.com/microsoft/cascadia-code/releases/download/v2009.22/CascadiaCode-2009.22.zip -outfile CascadiaCode-2009.22.zip

# If using PowerShell Core, install PSReadline:
write-output "Installing PSReadline in support of powerline customization for Windows Terminal"
Install-Module -Name PSReadLine -Scope CurrentUser -Force -SkipPublisherCheck

# Customize the powershell prompt
if (!(Test-Path -Path $PROFILE)) {
    New-Item -ItemType File -Path $PROFILE -Force
}

$PoshGit="Import-Module posh-git"
$OhMyGosh="Import-Module oh-my-posh"
$SetTheme="Set-Theme Paradox"

if (!(select-string -path $PROFILE -pattern $PoshGit)) {
    add-content -Path $PROFILE -value $PoshGit
}

if (!(select-string -path $PROFILE -pattern $OhMyGosh)) {
    add-content -Path $PROFILE -value $OhMyGosh
}

if (!(select-string -path $PROFILE -pattern $SetTheme)) {
    add-content -Path $PROFILE -value $SetTheme
}

#write-output "Updating help..."
#update-help