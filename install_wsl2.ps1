# Downloads and Installs the required update for WSL2
write-output "Enabling WSL feature.  A reboot may be required after which this script should be run again."
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

write-output "Installing WSL2 from Choco Repo..."
choco install WSL2 -y

write-output "Installing the WSL2 update from https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi..."

$WSLUpdateFile="wsl_update_x64.msi"
Invoke-WebRequest https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi -outfile $WSLUpdateFile
Start-Process .\$WSLUpdateFile  -Wait -ArgumentList '/quiet'
remove-item .\$WSLUpdateFile

write-output "Completed the WSL2 update!"