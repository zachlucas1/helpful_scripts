$Path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search\"
New-ItemProperty -Path $Path -Name "BingSearchEnabled" -Value 0 -PropertyType DWORD -Force | Out-Null
New-ItemProperty -Path $Path -Name "CortanaConsent" -Value 0 -PropertyType DWORD -Force | Out-Null