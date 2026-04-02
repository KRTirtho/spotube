<#
.SYNOPSIS
    GUI-based uninstaller for Spotube on Windows.
.DESCRIPTION
    Removes all Spotube installation artifacts: application files, shortcuts,
    user data, and registry entries. Mirrors what the Inno Setup installer
    creates (inno_setup.iss / make_config.yaml).
.PARAMETER Silent
    Suppresses all GUI dialogs and runs non-interactively.
#>
param (
    [switch]$Silent
)

# Application metadata — must match Inno Setup make_config.yaml
$APP_NAME       = "Spotube"
$APP_ID         = "80B901C8-D6FE-494E-8AF7-A2BD440E8644"
$INNO_REG_KEY   = "${APP_ID}_is1"
$CUSTOM_REG_KEY = "SpotubeCustomUninstaller"

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Displays a standard Windows message box and returns the DialogResult.
function Show-MessageBox {
    param(
        [string]$Message,
        [string]$Title   = "Spotube Uninstaller",
        [System.Windows.Forms.MessageBoxButtons]$Buttons = [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]$Icon       = [System.Windows.Forms.MessageBoxIcon]::Information
    )
    return [System.Windows.Forms.MessageBox]::Show($Message, $Title, $Buttons, $Icon)
}

# Creates and displays the progress window. Returns a hashtable of controls
# so the caller can update label text, sub-label, and progress bar value.
function Show-ProgressForm {
    $form                  = New-Object System.Windows.Forms.Form
    $form.Text             = "Spotube Uninstaller"
    $form.Size             = New-Object System.Drawing.Size(460, 200)
    $form.StartPosition    = "CenterScreen"
    $form.FormBorderStyle  = "FixedDialog"
    $form.MaximizeBox      = $false
    $form.MinimizeBox      = $false
    $form.ControlBox       = $false   # Disable X button during active uninstall
    $form.TopMost          = $true

    # Use the installed Spotube executable's icon if available
    foreach ($candidate in @(
        (Join-Path $env:ProgramFiles        "Spotube\spotube.exe"),
        (Join-Path $env:LOCALAPPDATA "Programs\Spotube\spotube.exe")
    )) {
        if (Test-Path $candidate) {
            try { $form.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($candidate) } catch {}
            break
        }
    }

    $lblStatus             = New-Object System.Windows.Forms.Label
    $lblStatus.Location    = New-Object System.Drawing.Point(16, 16)
    $lblStatus.Size        = New-Object System.Drawing.Size(420, 20)
    $lblStatus.Text        = "Preparing..."
    $lblStatus.Font        = New-Object System.Drawing.Font("Segoe UI", 10)
    $form.Controls.Add($lblStatus)

    $progressBar           = New-Object System.Windows.Forms.ProgressBar
    $progressBar.Location  = New-Object System.Drawing.Point(16, 48)
    $progressBar.Size      = New-Object System.Drawing.Size(420, 22)
    $progressBar.Minimum   = 0
    $progressBar.Maximum   = 100
    $progressBar.Value     = 0
    $form.Controls.Add($progressBar)

    $lblDetail             = New-Object System.Windows.Forms.Label
    $lblDetail.Location    = New-Object System.Drawing.Point(16, 80)
    $lblDetail.Size        = New-Object System.Drawing.Size(420, 16)
    $lblDetail.Text        = ""
    $lblDetail.Font        = New-Object System.Drawing.Font("Segoe UI", 8)
    $lblDetail.ForeColor   = [System.Drawing.Color]::DimGray
    $form.Controls.Add($lblDetail)

    $form.Show()
    $form.Refresh()

    return @{
        Form     = $form
        Status   = $lblStatus
        Detail   = $lblDetail
        Progress = $progressBar
    }
}

# Re-elevate as Administrator if the script is not already running elevated.
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator
)
if (-not $isAdmin) {
    $relaunchArgs = "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    if ($Silent) { $relaunchArgs += " -Silent" }
    Start-Process powershell -ArgumentList $relaunchArgs -Verb RunAs
    exit
}

# Prompt the user before making any changes.
if (-not $Silent) {
    $confirmMsg = @"
Are you sure you want to uninstall Spotube?

This will permanently remove:
  • Application files
  • Desktop, Start Menu, and Startup shortcuts
  • User configuration and cached data
  • Windows registry entries
"@
    $result = Show-MessageBox -Message $confirmMsg -Title "Uninstall Spotube" `
        -Buttons ([System.Windows.Forms.MessageBoxButtons]::YesNo) `
        -Icon   ([System.Windows.Forms.MessageBoxIcon]::Question)

    if ($result -ne [System.Windows.Forms.DialogResult]::Yes) {
        Show-MessageBox -Message "Uninstallation was cancelled. No changes were made." `
            -Title "Cancelled" -Icon ([System.Windows.Forms.MessageBoxIcon]::Information)
        exit
    }
}

$ui = Show-ProgressForm

# Updates the progress window with new status text and a percentage value.
function Update-Progress ([string]$status, [string]$detail, [int]$percent) {
    $ui.Status.Text       = $status
    $ui.Detail.Text       = $detail
    $ui.Progress.Value    = [Math]::Min($percent, 100)
    $ui.Form.Refresh()
}

# Silently removes a file or directory; no-ops if the path does not exist.
function Safe-Remove ([string]$path) {
    if ($path -and (Test-Path $path)) {
        try { Remove-Item -Path $path -Recurse -Force -ErrorAction Stop } catch {}
    }
}

# Step 1: Terminate any running Spotube processes before touching files.
Update-Progress "Stopping Spotube..." "Terminating running processes" 5
Get-Process -Name "spotube" -ErrorAction SilentlyContinue |
    Stop-Process -Force -ErrorAction SilentlyContinue
Start-Sleep -Milliseconds 1500

# Step 2: Delete the installation directory.
# Inno Setup installs to {autopf}\Spotube — covers both admin and per-user installs.
Update-Progress "Removing application files..." "Deleting installation directory" 20
@(
    (Join-Path $env:ProgramFiles        $APP_NAME),
    (Join-Path $env:ProgramW6432        $APP_NAME),
    (Join-Path $env:LOCALAPPDATA "Programs\$APP_NAME")
) | Select-Object -Unique | ForEach-Object { Safe-Remove $_ }

# Step 3: Remove shortcuts created by the Inno Setup [Icons] section.
# Covers: {autoprograms} (Start Menu), {autodesktop} (Desktop), {userstartup} (Startup).
Update-Progress "Removing shortcuts..." "Cleaning Start Menu, Desktop, and Startup" 40
@(
    (Join-Path $env:ProgramData "Microsoft\Windows\Start Menu\Programs\$APP_NAME.lnk"),
    (Join-Path $env:APPDATA     "Microsoft\Windows\Start Menu\Programs\$APP_NAME.lnk"),
    (Join-Path $env:ProgramData "Microsoft\Windows\Start Menu\Programs\$APP_NAME"),
    (Join-Path $env:APPDATA     "Microsoft\Windows\Start Menu\Programs\$APP_NAME"),
    (Join-Path ([Environment]::GetFolderPath("CommonDesktopDirectory")) "$APP_NAME.lnk"),
    (Join-Path ([Environment]::GetFolderPath("Desktop"))               "$APP_NAME.lnk"),
    (Join-Path $env:APPDATA "Microsoft\Windows\Start Menu\Programs\Startup\$APP_NAME.lnk")
) | ForEach-Object { Safe-Remove $_ }

# Step 4: Remove Flutter application data stored in AppData.
Update-Progress "Removing user data..." "Clearing configuration and cache" 60
@(
    (Join-Path $env:APPDATA      "com.krtirtho.spotube"),
    (Join-Path $env:LOCALAPPDATA "com.krtirtho.spotube"),
    (Join-Path $env:APPDATA      "spotube"),
    (Join-Path $env:LOCALAPPDATA "spotube")
) | ForEach-Object { Safe-Remove $_ }

# Step 5: Remove all Windows registry entries.
# Targets the Inno Setup key ({AppId}_is1) and our custom Control Panel key.
Update-Progress "Removing registry entries..." "Cleaning uninstall records" 80
foreach ($root in @("HKLM:\SOFTWARE", "HKCU:\SOFTWARE", "HKLM:\SOFTWARE\WOW6432Node")) {
    foreach ($key in @($INNO_REG_KEY, $CUSTOM_REG_KEY)) {
        Safe-Remove "$root\Microsoft\Windows\CurrentVersion\Uninstall\$key"
    }
}
Safe-Remove "HKCU:\SOFTWARE\KRTirtho"
Safe-Remove "HKCU:\SOFTWARE\Spotube"

Update-Progress "Complete" "Spotube has been removed." 100
Start-Sleep -Milliseconds 500
$ui.Form.Close()
$ui.Form.Dispose()

# Show the final confirmation dialog with an OK button to dismiss.
if (-not $Silent) {
    Show-MessageBox `
        -Message "Spotube has been successfully uninstalled.`n`nClick OK to close." `
        -Title   "Uninstall Complete" `
        -Buttons ([System.Windows.Forms.MessageBoxButtons]::OK) `
        -Icon    ([System.Windows.Forms.MessageBoxIcon]::Information)
}
