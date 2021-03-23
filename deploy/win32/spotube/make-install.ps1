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

    echo "Creating shortcuts"
    foreach($shortcut in $shortcut_paths){
        echo $shortcut
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
    }
    else{
        New-Item -Path Spotube_Location -Name "Spotube" -ItemType "directory"
        [System.IO.Compression.ZipFile]::ExtractToDirectory("$ScriptDir\spotube.data", "$Spotube_Location\Spotube")
    }
    $WannaCreateShortcut = Read-Host -Prompt "Do you want to create shortcuts?[y]Yes/[n]No"
    $WannaCreateShortcut = $WannaCreateShortcut.Trim().ToLower()
    if($WannaCreateShortcut -eq "y"){
        if(!$Spotube_Location.Trim()){
            $Spotube_Location= $Env:Programfiles
        }
        CreateShortcut -InstallLocation "$Spotube_Location\Spotube"
    }
    elseif($WannaCreateShortcut -eq "n"){
        echo "Ok, skipping this part"
    }
    else{
        throw "Wrong Option, use either 'y' or 'n', aborting..."
    }
    
}

if(!(Test-Path $Spotube_Dir)){
    InstallSpotube -PromptLocation $True
}
# reinstallation procedure
else{
    echo "Spotube already exists in $Env:Programfiles\Spotube"
    $WannaReplace = Read-Host -Prompt "Do you want to reinstall?[y]Yes/[n]No"
    $WannaReplace = $WannaReplace.Trim().ToLower()
    if($WannaReplace -eq "y"){
        echo "Removing Old Spotube"
        Remove-Item -Path "$Spotube_Dir" -Recurse
        echo "Installing New Spotube"
        InstallSpotube
    }
    elseif($WannaReplace -eq "n"){
        echo "Keeping the older installation, quitting..."
    }
    else{
        throw "Wrong Option, use either 'y' or 'n', aborting..."
    }

}
