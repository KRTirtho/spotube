$CWD = Split-Path $script:MyInvocation.MyCommand.Path
$CWD = "$CWD\..\"
$Build_Dir = "$CWD\deploy\win32\build\spotube\"
$files = Get-ChildItem -Path $Build_Dir -Exclude @("make-install.ps1", "install.bat")

echo "Archiving the code...."
Compress-Archive -Path $files -DestinationPath "$Build_Dir\spotube.zip" -CompressionLevel Fastest -Force
Rename-Item "$Build_Dir\spotube.zip" "spotube.data"

$packageJson = Get-Content "$CWD\package.json" | Out-String | ConvertFrom-Json
$Version = $packageJson.version

echo "Now compressing the portable binary..."
Compress-Archive -Path @("$Build_Dir\spotube.data", "$Build_Dir\install.bat", "$Build_Dir\make-install.ps1") -DestinationPath "$Build_Dir\Spotube-winx64-v$Version.zip" -Force

echo "Removing temp build files..."
Remove-Item -Path "$Build_Dir\spotube.data"

echo "Done building"
echo "Zip located at $Build_Dir\Spotube-winx64-v$Version.zip"