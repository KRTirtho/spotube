<#
.SYNOPSIS
    Registers the Spotube custom uninstaller in Windows Programs and Features.
.DESCRIPTION
    Writes a registry entry to HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall
    so that Spotube appears in Control Panel -> Programs and Features and in
    Settings -> Apps -> Installed Apps. The UninstallString points to Uninstall-Spotube.bat
    which must be in the same directory as this script.
.NOTES
    Requires: Uninstall-Spotube.bat in the same folder.
    Run as Administrator.
#>
param()

# Re-elevate if not already running as Administrator.
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator
)
if (-not $isAdmin) {
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

$scriptDir     = Split-Path -Parent $PSCommandPath
$uninstallBat  = Join-Path $scriptDir "Uninstall-Spotube.bat"

if (-Not (Test-Path $uninstallBat)) {
    Write-Error "Uninstall-Spotube.bat not found in '$scriptDir'. Ensure all uninstaller files are kept together."
    pause
    exit 1
}

# Version sourced from pubspec.yaml (5.1.1+44). Override if the installed exe exposes a FileVersion.
$displayVersion = "5.1.1"
$iconPath       = ""

foreach ($candidate in @(
    (Join-Path $env:ProgramFiles        "Spotube\spotube.exe"),
    (Join-Path $env:LOCALAPPDATA "Programs\Spotube\spotube.exe")
)) {
    if (Test-Path $candidate) {
        $fileVer = (Get-Item $candidate).VersionInfo.FileVersion
        if ($fileVer) { $displayVersion = $fileVer }
        $iconPath = $candidate
        break
    }
}

$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\SpotubeCustomUninstaller"

if (-Not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Registry values follow the standard Windows "Add/Remove Programs" schema.
$stringValues = @{
    DisplayName     = "Spotube"
    DisplayVersion  = $displayVersion
    Publisher       = "KRTirtho, OSS"
    URLInfoAbout    = "https://github.com/KRTirtho/spotube"
    HelpLink        = "https://github.com/KRTirtho/spotube/issues"
    UninstallString = "`"$uninstallBat`""
    InstallDate     = (Get-Date -Format "yyyyMMdd")
}
$dwordValues = @{
    NoModify       = 1
    NoRepair       = 1
    EstimatedSize  = 80000   # Approximate installed size in KB
}

foreach ($kv in $stringValues.GetEnumerator()) {
    Set-ItemProperty -Path $regPath -Name $kv.Key -Value $kv.Value
}
foreach ($kv in $dwordValues.GetEnumerator()) {
    Set-ItemProperty -Path $regPath -Name $kv.Key -Value $kv.Value -Type DWord
}
if ($iconPath) {
    Set-ItemProperty -Path $regPath -Name "DisplayIcon" -Value "$iconPath,0"
}

Write-Host ""
Write-Host "Spotube registered in Programs and Features." -ForegroundColor Green
Write-Host "Open Control Panel -> Programs and Features (or Settings -> Apps) to uninstall."
Write-Host ""
pause
