@echo off
:: ============================================================
:: Name:        Run Registry Walker v1.0
:: Description: Launcher that requests Admin rights
:: Author:      Vo1ic
:: ============================================================

:: 1. Перевірка на Адміністратора
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [!] Requesting Admin rights...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: 2. Налаштування і запуск PowerShell скрипта
cd /d "%~dp0"
title Registry Walker Launcher

if exist "Registry-Walker.ps1" (
    powershell -NoProfile -ExecutionPolicy Bypass -File "Registry-Walker.ps1"
) else (
    color 0C
    echo [ERROR] File 'Registry-Walker.ps1' not found!
    echo.
    echo Please make sure both files are in the same folder.
    pause
)