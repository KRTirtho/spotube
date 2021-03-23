@echo off

Powershell.exe -Command "& {Start-Process Powershell.exe -ArgumentList '-ExecutionPolicy Bypass -File %~dp0make-install.ps1' -Verb RunAs}"