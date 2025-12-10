@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:MENU
cls
echo ╔══════════════════════════════════════════════════════════╗
echo ║     CLI PROXY API - SETUP MANAGER                        ║
echo ╚══════════════════════════════════════════════════════════╝
echo.
echo   [1] Setup Config (Copy config.example.yaml)
echo   [2] Login to Gemini CLI
echo   [3] Login to OpenAI Codex
echo   [4] Login to Claude Code
echo   [5] Login to GitHub Copilot
echo   [6] Login to Qwen
echo   [7] Login to iFlow
echo   [8] Login to Kiro (AWS CodeWhisperer)
echo   [9] Login to Antigravity
echo   [10] Start Server
echo   [11] Test API & List Models
echo   [0] Exit
echo.
set /p choice="Pilih menu (0-11): "

if "%choice%"=="0" goto EXIT
if "%choice%"=="1" goto SETUP_CONFIG
if "%choice%"=="2" goto LOGIN_GEMINI
if "%choice%"=="3" goto LOGIN_CODEX
if "%choice%"=="4" goto LOGIN_CLAUDE
if "%choice%"=="5" goto LOGIN_COPILOT
if "%choice%"=="6" goto LOGIN_QWEN
if "%choice%"=="7" goto LOGIN_IFLOW
if "%choice%"=="8" goto LOGIN_KIRO
if "%choice%"=="9" goto LOGIN_ANTIGRAVITY
if "%choice%"=="10" goto START_SERVER
if "%choice%"=="11" goto TEST_API
goto MENU

:SETUP_CONFIG
echo.
echo [INFO] Setting up config file...
if exist config.yaml (
    echo [WARNING] config.yaml already exists!
    set /p overwrite="Overwrite? (y/n): "
    if /i not "!overwrite!"=="y" goto MENU
)
copy config.example.yaml config.yaml >nul
if %errorlevel% equ 0 (
    echo [SUCCESS] Config file created: config.yaml
    echo [INFO] Please edit config.yaml and set your api-keys!
) else (
    echo [ERROR] Failed to create config file
)
pause
goto MENU

:LOGIN_GEMINI
echo.
echo [INFO] Logging in to Gemini CLI...
set /p incognito="Use incognito mode? (y/n): "
if /i "!incognito!"=="y" (
    cli-proxy-api.exe -login -incognito
) else (
    cli-proxy-api.exe -login
)
pause
goto MENU

:LOGIN_CODEX
echo.
echo [INFO] Logging in to OpenAI Codex...
set /p incognito="Use incognito mode? (y/n): "
if /i "!incognito!"=="y" (
    cli-proxy-api.exe -codex-login -incognito
) else (
    cli-proxy-api.exe -codex-login
)
pause
goto MENU

:LOGIN_CLAUDE
echo.
echo [INFO] Logging in to Claude Code...
set /p incognito="Use incognito mode? (y/n): "
if /i "!incognito!"=="y" (
    cli-proxy-api.exe -claude-login -incognito
) else (
    cli-proxy-api.exe -claude-login
)
pause
goto MENU

:LOGIN_COPILOT
echo.
echo [INFO] Logging in to GitHub Copilot...
set /p incognito="Use incognito mode? (y/n): "
if /i "!incognito!"=="y" (
    cli-proxy-api.exe -github-copilot-login -incognito
) else (
    cli-proxy-api.exe -github-copilot-login
)
pause
goto MENU

:LOGIN_QWEN
echo.
echo [INFO] Logging in to Qwen...
set /p incognito="Use incognito mode? (y/n): "
if /i "!incognito!"=="y" (
    cli-proxy-api.exe -qwen-login -incognito
) else (
    cli-proxy-api.exe -qwen-login
)
pause
goto MENU

:LOGIN_IFLOW
echo.
echo [INFO] Logging in to iFlow...
set /p incognito="Use incognito mode? (y/n): "
if /i "!incognito!"=="y" (
    cli-proxy-api.exe -iflow-login -incognito
) else (
    cli-proxy-api.exe -iflow-login
)
pause
goto MENU

:LOGIN_KIRO
echo.
echo [INFO] Logging in to Kiro (AWS CodeWhisperer)...
echo   [1] Login with Google OAuth
echo   [2] Login with AWS Builder ID
echo   [3] Import from Kiro IDE
set /p kiro_choice="Choose method (1-3): "
set /p incognito="Use incognito mode? (y/n): "
if "!kiro_choice!"=="1" (
    if /i "!incognito!"=="y" (
        cli-proxy-api.exe -kiro-login -incognito
    ) else (
        cli-proxy-api.exe -kiro-login
    )
) else if "!kiro_choice!"=="2" (
    if /i "!incognito!"=="y" (
        cli-proxy-api.exe -kiro-aws-login -incognito
    ) else (
        cli-proxy-api.exe -kiro-aws-login
    )
) else if "!kiro_choice!"=="3" (
    cli-proxy-api.exe -kiro-import
)
pause
goto MENU

:LOGIN_ANTIGRAVITY
echo.
echo [INFO] Logging in to Antigravity...
set /p incognito="Use incognito mode? (y/n): "
if /i "!incognito!"=="y" (
    cli-proxy-api.exe -antigravity-login -incognito
) else (
    cli-proxy-api.exe -antigravity-login
)
pause
goto MENU

:START_SERVER
echo.
echo [INFO] Starting CLI Proxy API Server...
if not exist config.yaml (
    echo [ERROR] config.yaml not found! Please run Setup Config first.
    pause
    goto MENU
)
echo [INFO] Server will start on configured port (default: 8317)
echo [INFO] Press Ctrl+C to stop the server
echo.
cli-proxy-api.exe -config config.yaml
pause
goto MENU

:TEST_API
echo.
echo [INFO] Testing API & Listing Models...
if not exist config.yaml (
    echo [ERROR] config.yaml not found!
    pause
    goto MENU
)
set /p port="Enter port (default 8317): "
if "!port!"=="" set port=8317
set /p apikey="Enter your API key: "
if "!apikey!"=="" (
    echo [ERROR] API key required!
    pause
    goto MENU
)
echo.
echo [INFO] Fetching models from http://localhost:!port!/v1/models...
echo.
curl -s http://localhost:!port!/v1/models -H "Authorization: Bearer !apikey!" > models.json
if %errorlevel% equ 0 (
    echo [SUCCESS] Models saved to models.json
    type models.json
    echo.
    echo.
    echo [INFO] Opening models in browser...
    start "" "models (2).html"
) else (
    echo [ERROR] Failed to fetch models. Is the server running?
)
pause
goto MENU

:EXIT
echo.
echo [INFO] Exiting...
exit /b 0
