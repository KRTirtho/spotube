# Don't edit this file without understanding, this can lead to major damage to the system
# Use uninstall.bat to remove Spotube
Add-Type -AssemblyName System.IO.Compression.FileSystem
$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path
if(Test-Path "$ScriptDir\qode.exe"){  
    $WannaRemove = Read-Host -Prompt "Are you sure to uninstall?[y]Yes/[n]No"
    $WannaRemove = $WannaRemove.Trim().ToLower()
    if($WannaRemove -eq "y"){
        Write-Output "Removing all the contents"
        Get-ChildItem $ScriptDir -Recurse | Remove-Item

        # now deleting mpv player
        $DeleteMpv = Read-Host -Prompt "Do you want to delete mpv player?[y]Yes/[n]No"
        if ($DeleteMpv -eq "y") {
            $Mpv_Dir = "$Env:ProgramData\Spotube"
            Write-Output "Deleting Mpv player"
            Remove-Item -Path $Mpv_Dir -Recurse
            Write-Output "Deleted Mpv player"
            Write-Output "Removing environment variables"
            # Get it
            $pathMachine = [System.Environment]::GetEnvironmentVariable('PATH','Machine')
            $pathUser = [System.Environment]::GetEnvironmentVariable('PATH','User')
            # Remove unwanted elements
            $pathMachine = ($pathMachine.Split(';') | Where-Object { $_ -ne "$Mpv_Dir\mpv" }) -join ';'
            $pathUser = ($pathUser.Split(';') | Where-Object { $_ -ne "$Mpv_Dir\mpv" }) -join ';'
            # Set it
            [System.Environment]::SetEnvironmentVariable('PATH', $pathMachine, 'Machine')
            [System.Environment]::SetEnvironmentVariable('PATH', $pathUser, 'User')
        }
        elseif($DeleteMpv -eq "n") {
            Write-Output "Ok, keeping mpv player"
        }
        else{
            throw "Wrong Option, use either 'y' or 'n', aborting..."
        }

        $DeleteData = Read-Host -Prompt "Do you want to delete all data & caches?[y]Yes/[n]No"
        $DeleteData = $DeleteData.Trim().ToLower()
        if ($DeleteData -eq "y") {
            Write-Output "Deleting data & caches"
            Remove-Item -Path "$Home\.config\spotube" -Recurse
            Remove-Item -Path "$Home\.cache\spotube" -Recurse
            Write-Output "Deleted caches & data"
        }
        elseif($DeleteData -eq "n") {
            Write-Output "Ok, keeping those"
        }
        else{
            throw "Wrong Option, use either 'y' or 'n', aborting..."
        }
        # removing all the shortcuts
        $shortcut_paths = @(
        "$HOME\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Spotube.lnk", 
        "$HOME\Desktop\Spotube.lnk"
        )

        foreach($shortcut in $shortcut_paths){
            if(Test-Path $shortcut){
                Write-Output "Deleting Shortcut: $shortcut"
                Remove-Item -Path $shortcut
            }
        }


        Write-Output "Uninstall complete, just delete the Spotube folder now"
        Write-Output "Will miss you💕!"
    }
    elseif($WannaRemove -eq "n"){
        Write-Output "Thank god you didn't, quitting..."
    }
    else{
        throw "Wrong Option, use either 'y' or 'n', aborting..."
    }
}
else{
    throw "Script isn't being executed desired location, aborting for abuse"
}