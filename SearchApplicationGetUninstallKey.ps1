﻿# Define the registry paths for uninstall information
$registryPaths = @(
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall",
    "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall",
    "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
)

# Specify the application name to search for
$targetAppName = "Your Application"

# Loop through each registry path and retrieve the list of subkeys
foreach ($path in $registryPaths) {
    $uninstallKeys = Get-ChildItem -Path $path -ErrorAction SilentlyContinue

    # Skip if the registry path doesn't exist
    if (-not $uninstallKeys) {
        continue
    }

    # Loop through each uninstall key and display the properties of the target application
    foreach ($key in $uninstallKeys) {
        $keyPath = Join-Path -Path $path -ChildPath $key.PSChildName

        $displayName = (Get-ItemProperty -Path $keyPath -Name "DisplayName" -ErrorAction SilentlyContinue).DisplayName
        $uninstallString = (Get-ItemProperty -Path $keyPath -Name "UninstallString" -ErrorAction SilentlyContinue).UninstallString
        $version = (Get-ItemProperty -Path $keyPath -Name "DisplayVersion" -ErrorAction SilentlyContinue).DisplayVersion
        $publisher = (Get-ItemProperty -Path $keyPath -Name "Publisher" -ErrorAction SilentlyContinue).Publisher
        $installLocation = (Get-ItemProperty -Path $keyPath -Name "InstallLocation" -ErrorAction SilentlyContinue).InstallLocation

        if ($displayName -match $targetAppName) {
            Write-Host "DisplayName: $displayName"
            Write-Host "UninstallString: $uninstallString"
            Write-Host "Version: $version"
            Write-Host "Publisher: $publisher"
            Write-Host "InstallLocation: $installLocation"
            Write-Host "---------------------------------------------------"
        }
    }
}
