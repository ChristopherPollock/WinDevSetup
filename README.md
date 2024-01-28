# Windows Installer Automation
A Powershell project that installs a number of software titles specified in either the "winget_packagelist" or "choco_packagelist" files. 

Before you run bootstrap.ps1, you will need to first set the execution policy with the following two commands:

   ```powershell
    Set-ExecutionPolicy Bypass -Scope Process
    set-executionpolicy remotesigned
   ```

Run the bootstrap.ps1 file from an elevated prompt:
  ```powershell
  .\bootstrap.ps1 -RunAsAdministrator
  ```

  I do not warranty any of this code.  Read the code before you run it.  I am not responsible for any damages you incur from this. 