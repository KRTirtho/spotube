@echo off
:: Launches the Spotube GUI uninstaller without showing a console window.
:: -WindowStyle Hidden ensures only the WinForms dialogs are visible.
powershell -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "%~dp0Uninstall-Spotube.ps1"
