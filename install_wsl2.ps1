# Downloads and Installs the required update for WSL2
write-output "Installing the WSL2 update from https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi"
$WSLUpdateFile="wsl_update_x64.msi"
Invoke-WebRequest https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi -outfile $WSLUpdateFile
Start-Process .\$WSLUpdateFile  -Wait -ArgumentList '/quiet'
remove-item .\$WSLUpdateFile