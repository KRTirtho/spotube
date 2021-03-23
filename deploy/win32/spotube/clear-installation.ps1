# Don't edit this file without understanding, this can lead to major damage to the system
# Use uninstall.bat to remove Spotube
Add-Type -AssemblyName System.IO.Compression.FileSystem
$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path
if(Test-Path "$ScriptDir\qode.exe"){  
    $WannaRemove = Read-Host -Prompt "Are you sure to uninstall?[y]Yes/[n]No"
    $WannaRemove = $WannaRemove.Trim().ToLower()
    if($WannaRemove -eq "y"){
        echo "Removing all the contents"
        Get-ChildItem $ScriptDir -Recurse | Remove-Item

        $DeleteData = Read-Host -Prompt "Do you want to delete all data & caches?[y]Yes/[n]No"
        $DeleteData = $DeleteData.Trim().ToLower()
        if ($DeleteData -eq "y") {
            echo "Deleting data & caches"
            Remove-Item -Path "$Home\.config\spotube" -Recurse
            Remove-Item -Path "$Home\.cache\spotube" -Recurse
            echo "Deleted caches & data"
        }
        elseif($DeleteData -eq "n") {
            echo "Ok, keeping those"
        }
        else{
            throw "Wrong Option, use either 'y' or 'n', aborting..."
        }

        echo "Uninstall complete, just delete the Spotube folder now"
        echo "Will miss you💕!"
    }
    elseif($WannaRemove -eq "n"){
        echo "Thank god you didn't, quitting..."
    }
    else{
        throw "Wrong Option, use either 'y' or 'n', aborting..."
    }
}
else{
    throw "Script isn't being executed desired location, aborting for abuse"
}