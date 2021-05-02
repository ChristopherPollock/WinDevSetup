# PowerLine for Windows Terminal install posh-git and oh-my-posh
write-output "Installing posh-git and oh-my-posh in support of powerline customization for Windows Terminal"
install-module oh-my-posh -scope CurrentUser -force
install-module posh-git -Scope CurrentUser -force

# Customize the powershell prompt
write-output "Writing customizations for Powershell command prompt..."
if (!(Test-Path -Path $PROFILE)) {
    New-Item -ItemType File -Path $PROFILE -Force
}

$PoshGit="Import-Module posh-git"
$OhMyGosh="Import-Module oh-my-posh"
$PSRL="PSReadLine"
$SetTheme="Set-Theme Paradox"

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
write-output "Downloading Cascadia font for powerline customization..."
$FontFile="PowerlineFonts.zip"
$SourceDir   = ".\font\"
$Source      = ".\font\*"
$Destination = (New-Object -ComObject Shell.Application).Namespace(0x14)
$TempFolder  = "C:\Windows\Temp\Fonts"
#Invoke-WebRequest https://github.com/microsoft/cascadia-code/releases/download/v2009.22/CascadiaCode-2009.22.zip -outfile $FontFile
Invoke-WebRequest -Uri 'https://github.com/powerline/fonts/archive/master.zip' -OutFile $FontFile
Expand-Archive $FontFile
.\PowerlineFonts\fonts-master\install.ps1
#Remove-Item $FontFile

<# write-output "Installing Cascadia fonts for powerline customization..."
New-Item $TempFolder -Type Directory -Force | Out-Null
Get-ChildItem -Path $Source -Include '*PL*.otf' -Recurse | ForEach-Object {

    If (!(Test-Path $env:windir\Fonts\$($_.Name))) {
        #$msg=$env:windir + "\Fonts\" + $($_.Name) + "; " + (Test-Path $env:windir\Fonts\$($_.Name)).ToString()
        #[System.Windows.MessageBox]::Show($msg)

        $Font = "$TempFolder\$($_.Name)"
        
        # Copy font to local temporary folder
        Copy-Item $($_.FullName) -Destination $TempFolder
        
        # Install font
        $Destination.CopyHere($Font,0x16)

        # Delete temporary copy of font
        Remove-Item $Font -Force
    }
} #>
Remove-Item -Recurse -force $SourceDir
write-output "Completed Powerline Installation and Config!  Open a new terminal Windows Terminal window to see the changes."