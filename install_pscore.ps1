# installs Powershell Core and sets up environment.  Once this is added to the community choco repo will deprecate this script.
write-output "Downloading Powershell Core installer..."

$PSInstaller="PowerShell-7.1.0-win-x64.msi"
Invoke-WebRequest https://github.com/PowerShell/PowerShell/releases/download/v7.1.0/PowerShell-7.1.0-win-x64.msi -outfile  $PSInstaller
write-output "Installing Powershell Core..."
Start-Process .\$PSInstaller  -Wait -ArgumentList '/quiet'
remove-item .\$PSInstaller

# If using PowerShell Core, install PSReadline:
write-output "Installing PSReadline in support of ""Powerline"" customization for Windows Terminal"

Install-Module -Name PSReadLine -Scope CurrentUser -Force -SkipPublisherCheck

write-output "Completed Powershell Core installation!"