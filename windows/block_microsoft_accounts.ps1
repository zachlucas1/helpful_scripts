if (Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System") {
    $registryValue = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "NoConnectedUser" -ErrorAction SilentlyContinue
    if ($registryValue) {
        # NoConnectedUser value exists, so we update it to 3
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "NoConnectedUser" -Value 3
    } else {
        # NoConnectedUser value does not exist, so we add it and set it to 3
        New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "NoConnectedUser" -Value 3 -PropertyType DWORD -Force
    }
} else {
    # Registry path not found
    exit
}
