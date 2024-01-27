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
    - Install Windows Subsystem for Linux (WSL)
    - Install Chocolately

    - Run through packagelist to install each choco package
    - Download and Install WSL2 update
    - Download and install Powershell Core
    - Apply Windows Terminal settings.json file
    - Set up Windows ternminal powerline

    Next Mods required
    ==================
    - install "MesloLGM NF" Font set
    - install WTTerminal to add ability to modify config from command.

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
    "terminal.integrated.fontFamily": "MesloLGM NF",
    "terminal.integrated.fontFamily": "Cascadia Code PL",
    "terminal.integrated.shellArgs.windows": ["-NoLogo"]
#>

#Install WSL
wsl --install
wsl --install -d kali-linux
wsl --install -d Ubuntu

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
#Winget installs (try to use winget by default, use choco for packages that aren't available in the Microsoft public repos) https://chocolatey.org/packages
Get-Content ".\winget_PackageList" | ForEach-Object {$_ -split "\r\n"} | ForEach-Object {
    if ($_.substring(0,1) -ne '#') {
        winget install $_ --silent --accept-package-agreements --accept-source-agreements
    }
}

#Choco Installations from community repo: https://chocolatey.org/packages
Get-Content ".\Choco_PackageList" | ForEach-Object {$_ -split "\r\n"} | ForEach-Object {
    if ($_.substring(0,1) -ne '#') {
        choco install -y $_
    }
}

#install the oh-my-posh fonts  https://ohmyposh.dev/docs/installation/fonts
$env:Path += ";C:\Users\user\AppData\Local\Programs\oh-my-posh\bin"
oh-my-posh font install

# Install  the required update for WSL2
#.\Install_WSL2.ps1


# PowerLine for Windows Terminal install posh-git and oh-my-posh
#.\Install_Powerline.ps1
