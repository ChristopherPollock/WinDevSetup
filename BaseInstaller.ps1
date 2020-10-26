# install/Boostrap Chocolatey. Detailed instructions: https://chocolatey.org/install
# Requires -RunAsAdministrator, Set-ExecutionPolicy Bypass -Scope Process
# Old commmand: Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

$Chocoinstalled = $false
if (get-command choco.exe -ErrorAction SilentlyContinue){
    $Chocoinstalled = $true
}

if (!$Chocoinstalled) {
    Write-Output "About to install Chocolately"
    Set-ExecutionPolicy Bypass -Scope Process -Force
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

#Base installs from community repo: https://chocolatey.org/packages
Get-Content ".\packagelist" | ForEach-Object {$_ -split "\r\n"} | ForEach-Object {choco install -y $_}

#.\dockerinstaller.ps1