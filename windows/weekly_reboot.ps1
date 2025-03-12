$bootuptime = (Get-CimInstance -ClassName Win32_OperatingSystem).LastBootUpTime
$CurrentDate = Get-Date
$uptime = $CurrentDate - $bootuptime


if ($uptime.days -gt 6)
{
Invoke-Command {shutdown.exe /r /t 300 /c "Computer will reboot in 5 minutes"}
return $uptime.days
}
else
{
return $uptime.days
exit
}