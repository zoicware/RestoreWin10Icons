If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) 
{	Start-Process PowerShell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
    Exit	}

#COPY FROM HERE DOWN AND PASTE INTO POWERSHELL AS ADMIN IF SCRIPT DOESNT RUN


$option = Read-Host -Prompt "Enter 1 to Enable Windows 10 icons `nEnter 2 to revert`n"


if($option -eq 1){

#make backup
Copy-Item -Path "C:\Windows\SystemResources\imageres.dll.mun" -Destination "$env:USERPROFILE\Desktop" -Force
Rename-Item -Path "$env:USERPROFILE\Desktop\imageres.dll.mun" -NewName "imageresBACKUP.dll.mun" -Force

#take ownership of the file and folder
takeown.exe /f "C:\Windows\SystemResources"
icacls.exe "C:\Windows\SystemResources" /grant Administrators:F /T /C
takeown.exe /f "C:\Windows\SystemResources\imageres.dll.mun"
icacls.exe "C:\Windows\SystemResources\imageres.dll.mun" /grant Administrators:F /T /C
#delete win 11 icons and replace with win 10
 Remove-Item "C:\Windows\SystemResources\imageres.dll.mun" -Force   
 $win10icons = Get-ChildItem -Path C:\ -Filter imageres10.dll.mun -Recurse -ErrorAction SilentlyContinue -Force |select-object -first 1 | % { $_.FullName; }
 Move-Item -Path $win10icons -Destination "C:\Windows\SystemResources" -Force
 Rename-Item -Path "C:\Windows\SystemResources\imageres10.dll.mun" -NewName "imageres.dll.mun" -Force

 #clear icon cache
 taskkill /f /im explorer.exe
 Remove-Item -Path "$env:USERPROFILE\AppData\Local\Microsoft\Windows\Explorer\*iconcache_*" -Force
 Remove-Item -Path "$env:USERPROFILE\AppData\Local\Microsoft\Windows\Explorer\*thumbcache_*" -Force
 #restart explorer
start explorer.exe
 
  }
  elseif($option -eq 2){
  $win11icons = $null
  $win11icons = Get-ChildItem -Path C:\ -Filter imageres11.dll.mun -Recurse -ErrorAction SilentlyContinue -Force |select-object -first 1 | % { $_.FullName; }
  if($win11icons -eq $null){
  Write-Host "UNABLE TO FIND WIN11 ICON FILE, SELECT THE BACKUP"

  Add-Type -AssemblyName System.Windows.Forms

# Create a file selection dialog
$fileDialog = New-Object System.Windows.Forms.OpenFileDialog
$fileDialog.Title = "Select a backup file"
$fileDialog.InitialDirectory = [System.Environment+SpecialFolder]::Desktop
$fileDialog.Filter = "All Files (*.*)|*.*"

# Show the dialog and get the selected file
$result = $fileDialog.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
    $selectedFile = $fileDialog.FileName
    $win11icons = $selectedFile
} else {
    exit
}
}


#take ownership of the file and folder
takeown.exe /f "C:\Windows\SystemResources"
icacls.exe "C:\Windows\SystemResources" /grant Administrators:F /T /C
takeown.exe /f "C:\Windows\SystemResources\imageres.dll.mun"
icacls.exe "C:\Windows\SystemResources\imageres.dll.mun" /grant Administrators:F /T /C
#delete win 10 icons and replace with win 11
 Remove-Item "C:\Windows\SystemResources\imageres.dll.mun" -Force   
 
 Move-Item -Path $win11icons -Destination "C:\Windows\SystemResources" -Force
$file = Get-Item "C:\Windows\SystemResources\imageres*.dll.mun"
Rename-Item -Path $file.FullName -NewName "imageres.dll.mun" -Force

 #clear icon cache
 taskkill /f /im explorer.exe
 Remove-Item -Path "$env:USERPROFILE\AppData\Local\Microsoft\Windows\Explorer\*iconcache_*" -Force
 Remove-Item -Path "$env:USERPROFILE\AppData\Local\Microsoft\Windows\Explorer\*thumbcache_*" -Force
 #restart explorer
start explorer.exe

}






  

  
