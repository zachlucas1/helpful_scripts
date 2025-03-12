# Get the list of all user profiles
$profiles = Get-ChildItem -Path "C:\Users" -Directory

# Iterate through each user profile
foreach ($profile in $profiles) {
    # Define the path to the Downloads folder for the current user
    $downloadsPath = Join-Path -Path $profile.FullName -ChildPath "Downloads"

    # Check if the Downloads folder exists for the current user
    if (Test-Path -Path $downloadsPath -PathType Container) {
        # Remove all files and folders within the Downloads folder
        Get-ChildItem -Path $downloadsPath | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
    }
}

Write-Host "Downloads folders cleared for all users."
