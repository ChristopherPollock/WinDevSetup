<#
    Prerequisites for runningthis script:
    =====================================
    1. set the execution policy with:
        Set-ExecutionPolicy Bypass -Scope Process
        set-executionpolicy remotesigned
    2. Run this script as an administrator by adding this switch
        .\bootstrap.ps1 -RunAsAdministrator

    Install Overview Notes:
    =======================
    - Install Chocolately
    - Install Windows Subsystem for Linux (WSL)
    - Run through packagelist to install each choco package
    - Download and Install WSL2 update
    - Download and install Powershell Core
    - Apply Windows Terminal settings.json file
    - Set up Windows ternminal powerline

    Next Mods required
    ==================

    Manual Installation steps after this script is complete (will figure out how to script some of this stuff later)
    =======================================================
    - VSCode Plugin Install: Shell Launcher + change keymap (https://github.com/Tyriar/vscode-shell-launcher)
    - VSCode github connect and sync settings
    - Putty full installer (choco package only seems to be the limited )
    - Enable and autostart OpenSSH Agent Service
    - set up SSH keys & adding to local vault
    - Set up GNU Privacy Guard
    - Set up Git default options
    - 

    vscode settings.json
    ====================
    "terminal.integrated.fontFamily": "Cascadia Code PL",
    "terminal.integrated.shellArgs.windows": ["-NoLogo"]
#>

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

#Choco Intallations from community repo: https://chocolatey.org/packages
Get-Content ".\Choco_PackageList" | ForEach-Object {$_ -split "\r\n"} | ForEach-Object {
    if ($_.substring(0,1) -ne '#') {
        choco install -y $_
    }
}

# Install  the required update for WSL2
.\Install_WSL2.ps1

# Install Powershell Core
.\Install_PSCore.ps1

# PowerLine for Windows Terminal install posh-git and oh-my-posh
.\Install_Powerline.ps1

#write-output "Updating help..."
#update-help