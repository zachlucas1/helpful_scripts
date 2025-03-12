# Check if Microsoft Quick Assist is installed
$QuickAssist = Get-AppxPackage -AllUsers | Where-Object { $_.Name -eq "MicrosoftCorporationII.QuickAssist" }

if ($QuickAssist) {
    Write-Output "Microsoft Quick Assist found. Attempting to uninstall..."
    
    # Remove Quick Assist for all users, suppress non-terminating errors
    try {
        Get-AppxPackage -AllUsers -Name "MicrosoftCorporationII.QuickAssist" | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 5  # Give it a moment to complete
    } catch {
        Write-Output "An error occurred, but the process may have still succeeded."
    }

    # Confirm removal
    $QuickAssistCheck = Get-AppxPackage -AllUsers | Where-Object { $_.Name -eq "MicrosoftCorporationII.QuickAssist" }
    if (-not $QuickAssistCheck) {
        Write-Output "Microsoft Quick Assist has been successfully uninstalled."
        exit 0  # Explicitly return success
    } else {
        Write-Output "Uninstallation may have failed. Please check manually."
        exit 1  # Return failure if it's still installed
    }
} else {
    Write-Output "Microsoft Quick Assist is not installed on this system."
    exit 0  # Explicitly return success
}
