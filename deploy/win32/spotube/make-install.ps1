# Don't edit this file, this can cause serious damage
# Use install.bat to install Spotube 
Add-Type -AssemblyName System.IO.Compression.FileSystem

$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path
$shortcut_paths = @(
        "$HOME\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Spotube.lnk", 
        "$HOME\Desktop\Spotube.lnk"
     )
# for creating shortcuts
function CreateShortcut([String]$InstallLocation) {
    $Target = "$InstallLocation\qode.exe"
    $WshShell = New-Object -comObject WScript.Shell

    Write-Output "Creating shortcuts"
    foreach($shortcut in $shortcut_paths){
        Write-Output $shortcut
        $StartShortcut = $WshShell.CreateShortcut($shortcut)
        $StartShortcut.TargetPath = $Target
        $StartShortcut.WorkingDirectory = $InstallLocation
        $StartShortcut.IconLocation = "$InstallLocation\icon.ico"
        $StartShortcut.Save()
    }
}

$Spotube_Dir = "$Env:Programfiles\Spotube"
# extracts & installs spotube
function InstallSpotube {
    param([bool]$PromptLocation)
    $Spotube_Location=""
    # checking if reinstalling
    if($PromptLocation){
        $Spotube_Location = Read-Host -Prompt "Give an absolute path (e.g C:\My Folder\) to install Spotube or leave it empty to install in {$Spotube_Dir}: "
    }
    # now creating/installing spotube
    if(!$Spotube_Location.Trim()){
        New-Item -Path $Env:Programfiles -Name "Spotube" -ItemType "directory"
        [System.IO.Compression.ZipFile]::ExtractToDirectory("$ScriptDir\spotube.data", $Spotube_Dir)
        Install-Mpv -SpotubeLocation $Spotube_Dir
    }
    else{
        New-Item -Path Spotube_Location -Name "Spotube" -ItemType "directory"
        $Spotube_Location = "$Spotube_Location\Spotube"
        [System.IO.Compression.ZipFile]::ExtractToDirectory("$ScriptDir\spotube.data", $Spotube_Location)
        Install-Mpv -SpotubeLocation $Spotube_Location
    }
    $WannaCreateShortcut = Read-Host -Prompt "Do you want to create shortcuts?[y]Yes/[n]No"
    $WannaCreateShortcut = $WannaCreateShortcut.Trim().ToLower()
    if($WannaCreateShortcut -eq "y"){
        if(!$Spotube_Location.Trim()){
            $Spotube_Location= $Spotube_Dir
        }
        CreateShortcut -InstallLocation $Spotube_Location
    }
    elseif($WannaCreateShortcut -eq "n"){
        Write-Output "Ok, skipping this part"
    }
    else{
        throw "Wrong Option, use either 'y' or 'n', aborting..."
    }
    
}

function Install-Mpv{
    param([String]$SpotubeLocation)
    $Mpv_Dir = "$Env:ProgramData"
    if(!(Test-Path "$Mpv_Dir\Spotube")){
        New-Item -Path $Mpv_Dir -Name "Spotube" -ItemType "directory"
    }
    $Mpv_Dir = "$Env:ProgramData\Spotube"
    if(!(Test-Path "$Mpv_Dir\mpv")){
        New-Item -Path $Mpv_Dir -Name "mpv" -ItemType "directory"
    }
    $Mpv_Dir = "$Mpv_Dir\mpv"
    # invoking the scripts for downloading mpv player
    Write-Output "Downloading mpv player"
    Invoke-Expression "& '$SpotubeLocation\deps\bootstrap-mpv.ps1' -CWD '$Mpv_Dir'"
    # setting the env vars
    if (!($ENV:Path.Contains($Mpv_Dir))) {
        Write-Output "Setting environment vars"
        [System.Environment]::SetEnvironmentVariable("Path", "$ENV:Path;$Mpv_Dir", [System.EnvironmentVariableTarget]::Machine)
        [System.Environment]::SetEnvironmentVariable("Path", "$ENV:Path;$Mpv_Dir", [System.EnvironmentVariableTarget]::User)
    }
}

if(!(Test-Path $Spotube_Dir)){
    InstallSpotube -PromptLocation $True
}
# reinstallation procedure
else{
    Write-Output "Spotube already exists in $Env:Programfiles\Spotube"
    $WannaReplace = Read-Host -Prompt "Do you want to reinstall?[y]Yes/[n]No"
    $WannaReplace = $WannaReplace.Trim().ToLower()
    if($WannaReplace -eq "y"){
        Write-Output "Removing Old Spotube"
        Remove-Item -Path "$Spotube_Dir" -Recurse -Exclude "$Spotube_Dir\mpv"
        Write-Output "Installing New Spotube"
        InstallSpotube
    }
    elseif($WannaReplace -eq "n"){
        Write-Output "Keeping the older installation, quitting..."
    }
    else{
        throw "Wrong Option, use either 'y' or 'n', aborting..."
    }

}
