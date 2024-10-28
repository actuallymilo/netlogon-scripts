# Define the source and destination paths
$sourcePath = "\\srv3\Group Policy Files$\DesktopInfo"
$destinationPath = "C:\DesktopInfo"
$markerFile = "$destinationPath\run_once_marker.txt"

# Check if the destination directory exists, if not create it
if (-Not (Test-Path -Path $destinationPath)) {
    New-Item -Path $destinationPath -ItemType Directory
}

# Copy the desktopinfo.exe and desktopinfo.ini from the network share to the local folder
Copy-Item -Path "$sourcePath\desktopinfo64.exe" -Destination $destinationPath -Force
Copy-Item -Path "$sourcePath\desktopinfo.ini" -Destination $destinationPath -Force

# Define the path of the executable
$executable = "$destinationPath\desktopinfo64.exe"

# Add the application to run at user logon via registry
$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
$regName = "DesktopInfo"

# Check if the registry key already exists and set it if not
if (-Not (Test-Path -Path "$regPath\$regName")) {
    Set-ItemProperty -Path $regPath -Name $regName -Value $executable
}

# Check if the marker file exists (indicating the app has already been run once)
if (-Not (Test-Path -Path $markerFile)) {
    # Run the application only once
    Start-Process -FilePath $executable

    # Create the marker file to indicate that the application has been run
    New-Item -Path $markerFile -ItemType File

    Write-Output "DesktopInfo has been successfully launched and marked as run once."
} else {
    Write-Output "DesktopInfo has already been launched previously."
}
