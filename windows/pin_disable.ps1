$passportFolder = "C:\Windows\ServiceProfiles\LocalService\AppData\Local\Microsoft\Ngc" 

if (Test-Path -Path $passportFolder) {
    Start-Process cmd -ArgumentList '/s,/c,"takeown /f C:\Windows\ServiceProfiles\LocalService\AppData\Local\Microsoft\NGC /r /d y & icacls C:\Windows\ServiceProfiles\LocalService\AppData\Local\Microsoft\NGC /grant administrators:F /t & RD /S /Q C:\Windows\ServiceProfiles\LocalService\AppData\Local\Microsoft\Ngc & MD C:\Windows\ServiceProfiles\LocalService\AppData\Local\Microsoft\Ngc & icacls C:\Windows\ServiceProfiles\LocalService\AppData\Local\Microsoft\Ngc /T /Q /C /RESET"' -Verb runAs
}

# Wait for the previous commands to complete before proceeding
Start-Sleep -Seconds 10

# Set the registry keys separately
Set-ItemProperty HKLM:\SOFTWARE\Policies\Microsoft\Windows\System -Name "AllowDomainPINLogon" -Value 0
Set-ItemProperty HKLM:\SOFTWARE\Microsoft\PolicyManager\default\Settings\AllowSignInOptions -Name "value" -Value 0
