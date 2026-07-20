@echo off
cd /d "%~dp0"
python OpenInCLion.py
if %ERRORLEVEL% neq 0 (
    pause
)