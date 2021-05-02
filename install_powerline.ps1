# PowerLine for Windows Terminal install posh-git and oh-my-posh
<# write-output "Installing posh-git and oh-my-posh in support of powerline customization for Windows Terminal"
install-module oh-my-posh -scope CurrentUser -force
install-module posh-git -Scope CurrentUser -force
install-module wttoolbox -Scope CurrentUser -force #>


# Customize the powershell prompt
write-output "Writing customizations for Powershell command prompt..."
if (!(Test-Path -Path $PROFILE)) {
    New-Item -ItemType File -Path $PROFILE -Force
}

$PoshGit="Import-Module posh-git"
$OhMyGosh="Import-Module oh-my-posh"
$PSRL="import-module PSReadLine"
$SetTheme="Set-PoshPrompt -Theme paradox"

if (!(select-string -path $PROFILE -pattern $PoshGit)) {
    add-content -Path $PROFILE -value $PoshGit
}

if (!(select-string -path $PROFILE -pattern $OhMyGosh)) {
    add-content -Path $PROFILE -value $OhMyGosh
}

if (!(select-string -path $PROFILE -pattern $PSRL)) {
    add-content -Path $PROFILE -value $PSRL
}

if (!(select-string -path $PROFILE -pattern $SetTheme)) {
    add-content -Path $PROFILE -value $SetTheme 
}

# PowerLine Cascadia font download and install for Powerline customization.  This font contains the special git-related glyphs that powerline needs to fancy-up the prompt.
write-output "Downloading Powerline font for powerline customization..."
$FontFile="CascadiaCode.zip"
$Fontdir = ".\CascadiaCode\"
#Invoke-WebRequest -Uri 'https://github.com/powerline/fonts/archive/master.zip' -OutFile $FontFile
Invoke-WebRequest -Uri 'https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/CascadiaCode.zip' -OutFile $FontFile
Expand-Archive $FontFile
Remove-item $FontFile

$FontItem = Get-Item -Path $Fontdir
$FontList = Get-ChildItem -Path "$FontItem\*" -Include ('*.fon','*.otf','*.ttc','*.ttf')

foreach ($Font in $FontList) {
    Write-Host 'Installing font -' $Font.BaseName
    Copy-Item $Font "C:\Windows\Fonts"
    New-ItemProperty -Name $Font.BaseName -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" -PropertyType string -Value $Font.name
}
Remove-Item -Recurse -force $Fontdir



# Installs new fonts for "All users" - requires elevated admin priv to run this
write-output "Downloading Meslo Nerd font for powerline customization..."
$FontFile ="Meslo.zip"
$Fontdir = ".\Meslo\"
Invoke-WebRequest -Uri 'https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Meslo.zip' -OutFile $FontFile
Expand-Archive $FontFile
Remove-item $FontFile

$FontItem = Get-Item -Path $Fontdir
$FontList = Get-ChildItem -Path "$FontItem\*" -Include ('*.fon','*.otf','*.ttc','*.ttf')

foreach ($Font in $FontList) {
    Write-Host 'Installing font -' $Font.BaseName
    Copy-Item $Font "C:\Windows\Fonts"
    New-ItemProperty -Name $Font.BaseName -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" -PropertyType string -Value $Font.name
}

Remove-Item -Recurse -force $Fontdir
write-output "Completed Powerline Installation and Config!  Open a new terminal Windows Terminal window to see the changes."