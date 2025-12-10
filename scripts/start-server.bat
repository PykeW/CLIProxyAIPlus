@echo off
chcp 65001 >nul
title CLI Proxy API Server

echo ╔══════════════════════════════════════════════════════════╗
echo ║     CLI PROXY API - STARTING SERVER                      ║
echo ╚══════════════════════════════════════════════════════════╝
echo.

if not exist config.yaml (
    echo [ERROR] config.yaml not found!
    echo [INFO] Please run setup.bat first to create config.yaml
    pause
    exit /b 1
)

echo [INFO] Starting CLI Proxy API Server...
echo [INFO] Press Ctrl+C to stop the server
echo.

cli-proxy-api.exe -config config.yaml

pause
