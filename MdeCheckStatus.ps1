#You use this script as is, and you have a full responsability to use this script on all enviorments
# Product by gaudium1991 on Github to help people in the World to solve MDE problem

function DisplayMenu {
Clear-Host
Write-Host @"
+===============================================+
|  Check Microsoft Defender for Endpoint        | 
+===============================================+
|                                               |
|    1) Verify Tamper Protection State          |
|    2) Check if MDE Module is Installed        |
|    3) MDE Client Analyzer                     |
|    4) Verify MDE Is Oboarded into Tenant      |
|    5) Check ForcePassive Mode RegKey          |
|    6) EXIT                                    |
+===============================================+

"@

$MENU = Read-Host "OPTION"
Switch ($MENU)
{
1 {
#Selection 1
#View Tamper protection State and give you a result on Powershell
$TamperState = Get-MpComputerStatus | select -ExpandProperty IsTamperProtected
if ($TamperState -eq $True)
{
  Write-Host "Tamper Protection is ACTIVE" -ForegroundColor DarkGreen -BackgroundColor White
}
else
{
  Write-Host "Tamper Protection is NOT ACTIVE" -ForegroundColor DarkRed -BackgroundColor White
}

Start-Sleep -Seconds 5 #Wait 5 second and after clear screen and return to menu selection
DisplayMenu
}
2 {
#Selection 2
if (-not (Get-Command -Name Get-MpComputerStatus -ErrorAction SilentlyContinue)) {
    Write-Host "The 'Get-MpComputerStatus' cmdlet is not available on this system." -ForegroundColor DarkYellow -BackgroundColor White
    
    # Prompt to install the module
    $install = Read-Host "Would you like to install the 'Windows Defender' module? (Y/N)"
    
    if ($install -eq 'Y' -or $install -eq 'y') {
        # Install the Windows Defender feature
        try {
            Install-WindowsFeature -Name Windows-Defender-Features
            Write-Host "'Windows Defender' has been installed. You may need to restart your session."
        }
        catch {
            Write-Host "Failed to install 'Windows Defender'. Please ensure you have the necessary permissions." -ForegroundColor DarkRed -BackgroundColor White
        }
    } else {
        Write-Host "The 'Windows Defender' module was not installed. The script will now exit." -ForegroundColor DarkRed -BackgroundColor White
        #exit
    }
}
else {
        Write-Host "The 'Windows Defender' module is just present on your machine! The Script will now Exit" -ForegroundColor DarkGreen -BackgroundColor White
        #exit
    }

Start-Sleep -Seconds 5
DisplayMenu
}
3 {
#Selection 3
#View Tamper protection State and give you a result on Powershell
# Define the URL of the file to download
$url = "https://aka.ms/MDEAnalyzer"
$extension = ".zip"

# Prompt the user to select a destination folder
$destinationFolder = (New-Object -ComObject Shell.Application).BrowseForFolder(0, "Select the destination folder", 0).Self.Path

if ($destinationFolder) {
    # Extract the file name with extension from the URL
    $fileName = [System.IO.Path]::GetFileName($url)
    
    # Define the destination path including the file name and extension
    $destinationPath = Join-Path -Path $destinationFolder -ChildPath $fileName
    
    # Download the file
    try {
        Write-Host "Downloading file..." -ForegroundColor Green
        Invoke-WebRequest -Uri $url -OutFile $destinationPath
        # Define the file path and the new extension
        $filePath = $destinationPath  # Replace with the actual file path
        $newExtension = ".zip"                  # Replace with the desired new extension

        # Get the file's directory and its current name without the extension
        $directory = [System.IO.Path]::GetDirectoryName($filePath)
        $fileNameWithoutExtension = [System.IO.Path]::GetFileNameWithoutExtension($filePath)

        # Construct the new file name with the new extension
        $newFileName = "$fileNameWithoutExtension$newExtension"
        $newFilePath = Join-Path -Path $directory -ChildPath $newFileName

        # Rename the file with the new extension and estract Zip File
        Rename-Item -Path $filePath -NewName $newFileName
        Expand-Archive -path $newFileName -DestinationPath $filePath
        Write-Host "File downloaded successfully to $destinationPath" -ForegroundColor DarkGreen -BackgroundColor White
        #Open Client Analyzer
        $ClientAnalyzerPath = $destinationPath + "\MDEClientAnalyzer.cmd"
        #Run Client Analyzer
        Start-Process -FilePath $ClientAnalyzerPath
    }
    catch {
        Write-Host "Failed to download the file. Please check the URL or your network connection." -ForegroundColor DarkRed -BackgroundColor White
    }
} else {
    Write-Host "No destination folder selected. The script will now exit." -ForegroundColor DarkRed -BackgroundColor White
    exit
}

Start-Sleep -Seconds 5 #Wait 5 second and after clear screen and return to menu selection
DisplayMenu
}
4 {
#SELECTION 4

# Check RegKey for Onboardinf Process
 $OnboardStatus = Get-ItemProperty -Path "HKLM:\Software\Microsoft\Windows Advanced Threat Protection\Status\" -ErrorAction silentlycontinue
 if (-not [string]::isnullorempty($OnboardStatus.OnboardingState)) {
    switch ($OnboardStatus.OnboardingState) {
        0 {write-host -ForegroundColor DarkRed -BackgroundColor White "Defender for Endpoint is Offboarded";break}
        1 {write-host -ForegroundColor DarkGreen -BackgroundColor White "Defender for Endpoint is Correctly Onboarded";break}
        default {write-host -ForegroundColor DarkYellow -BackgroundColor White "Defender for Endpoint have an Unknown Value";break}
    }
} else {
    write-host -ForegroundColor DarkYellow -BackgroundColor White "Defender for Endpoint have an Unknown Value - Click Enter to Return Menu"
    pause
}


Start-Sleep -Seconds 5 #Wait 5 second and after clear screen and return to menu selection
DisplayMenu
}
5 {
#Selection 5
#Check if Regkey is set forcepassive mode and set it to 0
 #DA COMPLETARE
 $ForcePassiveModeKey = Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Advanced Threat Protection" -Name "ForcePassiveMode" -ErrorAction silentlycontinue
 if (-not [string]::isnullorempty($ForcePassiveModeKey.ForcePassiveMode)) {
    switch ($ForcePassiveModeKey.ForcePassiveMode) {
        0 {write-host -ForegroundColor DarkGreen -BackgroundColor White "Force Passive Mode Is DISABLED!";break}
        1 { Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Advanced Threat Protection" -Name "ForcePassiveMode" -Value "0" ;write-host -ForegroundColor DarkRed -BackgroundColor White "Force Passive Mode Is ENABLED and I set it to Disable!!!";break;}
        default {write-host -ForegroundColor DarkYellow -BackgroundColor White "The Regkey does not Exist!";break}
    }
} else {
    write-host -ForegroundColor DarkYellow -BackgroundColor White "The Regkey does not Exist! - Click Enter to Return Menu"
    pause
}

Start-Sleep -Seconds 5 #Wait 5 second and after clear screen and return to menu selection
DisplayMenu
}
6 {
#OPTION3 - EXIT
Write-Host "Thanks to use my Script! Bye"
Break
}
default {
#DEFAULT OPTION
Write-Host "You Select an Option that is not Present"
Start-Sleep -Seconds 5
DisplayMenu
}
}
}
DisplayMenu