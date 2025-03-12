$registryKeys = @(
    @{
        Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
        Name = "AllowDomainPINLogon"
        Value = 1
    },
    @{
        Path = "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\Settings\AllowSignInOptions"
        Name = "value"
        Value = 1
    }
)

foreach ($key in $registryKeys) {
    if (Test-Path $key.Path) {
        Set-ItemProperty -Path $key.Path -Name $key.Name -Value $key.Value
    } else {
        New-Item -Path $key.Path -Force | Out-Null
        Set-ItemProperty -Path $key.Path -Name $key.Name -Value $key.Value
    }
}

# Mimicking the original script's behavior of waiting
Start-Sleep -Seconds 10
