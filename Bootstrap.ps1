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
    - Install Winget package manager (Prefer this over Chocolatey)
    - Install Chocolatey Package Manager
    - Install WInget applist from flatfile
    - Install Chocolately applist from flatfile 

    Todo's
    ==================
    - Check/validate: are there any windows features needed or services that need to be enabled?
    - Use a single list for apps and use chocolatey only for apps that can't be found in winget repos
    - for VSCode: read in and then modify some of the config elements (such as terminal font selection to use installed nerdfonts) 
    - for Python:Add PIP package manager, conditional on python installer
    - Write out MS terminal config files
    - Log to a file 
    - script out GIT options
    - Script out SSH key generation and adding to local vault

    Manual Installation steps after this script is complete (will figure out how to script some of this stuff later)
    =======================================================
    - VSCode Plugin Install: Shell Launcher + change keymap (https://github.com/Tyriar/vscode-shell-launcher)
    - VSCode github connect and sync settings
    - Enable and autostart OpenSSH Agent Service
    - set up SSH keys & adding to local vault
    - Set up GNU Privacy Guard
    - Set up Git default options

    vscode settings.json
    ====================
    "terminal.integrated.fontFamily": "MesloLGM NF",
    "terminal.integrated.fontFamily": "Cascadia Code PL",
    "terminal.integrated.shellArgs.windows": ["-NoLogo"]
#>

#==================================================================================================
#Windows Prep/ configuration
#==================================================================================================
write-host "=============================================================="
Write-host "Enabling Windows features and enabling required services "
write-host "=============================================================="

#Install WSL
wsl --install
wsl --install -d kali-linux
wsl --install -d Ubuntu

#==================================================================================================
#Package Manager Installation  (Winget and Chocolatey) 
#==================================================================================================
write-host "=============================================================="
Write-host "Installing Package Managers (Winget and Chocolatey)"
write-host "=============================================================="

#Install & Configure WinGet.  Based on this gist: https://gist.github.com/crutkas/6c2096eae387e544bd05cde246f23901
$hasPackageManager = Get-AppPackage -name 'Microsoft.DesktopAppInstaller'
if (!$hasPackageManager -or [version]$hasPackageManager.Version -lt [version]"1.10.0.0") {
    "Installing winget Dependencies"
    Add-AppxPackage -Path 'https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx'

    $releases_url = 'https://api.github.com/repos/microsoft/winget-cli/releases/latest'

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $releases = Invoke-RestMethod -uri $releases_url
    $latestRelease = $releases.assets | Where-Object { $_.browser_download_url.EndsWith('msixbundle') } | Select-Object -First 1

    "Installing winget from $($latestRelease.browser_download_url)"
    Add-AppxPackage -Path $latestRelease.browser_download_url
}
else {
    "winget already installed"
}
#Configure WinGet
Write-Output "Configuring winget"

#winget config path from: https://github.com/microsoft/winget-cli/blob/master/doc/Settings.md#file-location
$settingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\settings.json";
$settingsJson = 
@"
    {
        // For documentation on these settings, see: https://aka.ms/winget-settings
        "experimentalFeatures": {
          "experimentalMSStore": true,
        }
    }
"@;
$settingsJson | Out-File $settingsPath -Encoding utf8

# install Chocolatey. Detailed instructions: https://chocolatey.org/install
$Chocoinstalled = $false
if (get-command choco.exe -ErrorAction SilentlyContinue){
    $Chocoinstalled = $true
    "Chocolatey already installed"
}

if (!$Chocoinstalled) {
    Write-Output "About to install Chocolately"
    Set-ExecutionPolicy Bypass -Scope Process -Force
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

#==================================================================================================
#Winget app installs.  Assumes whatever source (community?) repos were set up in the config.
#==================================================================================================

# Define the path to your text file
$textFilePath = ".\winget_PackageList"

# Create an empty hash table
$Applist = @{}

# Initialize an index counter
$index = 0

# Read each line from the file
Get-Content $textFilePath | ForEach-Object {
    # Increment the index counter
    $index++

    #check if the item is not a comment 
    if ($_.substring(0,1) -ne '#') {
        # Add the line (as key) and index (as value) to the hash table
        $Applist[$index] = $_.Trim()
        # $Applist[$_.Trim()] = $index
    }
}

#install the apps
write-host "=============================================================="
Write-host "Installing apps from winget from file '"$textFilePath"'"
write-host "=============================================================="
foreach ($key in $Applist.keys) {
    $listApp = winget list -q $Applist[$key]
    # Write-host  "Value:" $Applist[$key] "Key:" $key
    if (![String]::Join("", $listApp).Contains($Applist[$key])) {
        Write-host "Installing:" $Applist[$key] "(line" $key")"
        winget install --silent $Applist[$key] --accept-package-agreements
    }
    else {
        Write-host "Skipping Install of" $Applist[$key]"(line" $key")"
    }
}

#==================================================================================================
#Choco App Installs. from community repo: https://chocolatey.org/packages
#==================================================================================================
# Define the path to your text file
$textFilePath = ".\choco_PackageList"

# Create an empty hash table
$Applist = @{}

# Initialize an index counter
$index = 0

# Read each line from the file
Get-Content $textFilePath | ForEach-Object {
    # Increment the index counter
    $index++

    #check if the item is not a comment 
    if ($_.substring(0,1) -ne '#') {
        # Add the line (as key) and index (as value) to the hash table
        $Applist[$index] = $_.Trim()
    }
}
write-host "=============================================================="
Write-host "Installing apps from winget from file '"$textFilePath"'"
write-host "=============================================================="
#install the apps
foreach ($key in $Applist.keys) {
    $listApp = choco list $Applist[$key]
    # Write-host  "Value:" $Applist[$key] "Key:" $key
    if (![String]::Join("", $listApp).Contains($Applist[$key])) {
        Write-host "Installing:" $Applist[$key] "(line" $key")"
        choco install -y $Applist[$key]
    }
    else {
        Write-host "Skipping Install of" $Applist[$key]"(line" $key")"
    }
}

#==================================================================================================
#Download and install VST plugins for audio production
#==================================================================================================
#the following VSTs are not in any public repos and also not downloadable without a login/licensee, so will need to set up and maintain a custom repo for these
# La Petite Excite (by Fine Cut Bodies https://www.finecutbodies.com/?p=sound)
# TDR Nova (by Tokyo Dawn Records https://www.tokyodawn.net/tdr-nova/)
# Renegate (by Auburn Sounds https://www.auburnsounds.com/products/Renegate.html)
# Frontier (by D16 Group https://d16.pl/frontier)
# T-DEsser (by Techivation https://techivation.com/t-de-esser/)

#==================================================================================================
#App Configurations
#==================================================================================================

#oh-my-posh font installation  https://ohmyposh.dev/docs/installation/fonts
$env:Path += ";C:\Users\user\AppData\Local\Programs\oh-my-posh\bin"
oh-my-posh font install