# CLI Proxy API - Setup Manager (PowerShell)
# Requires PowerShell 5.1 or higher

param(
    [switch]$AutoStart,
    [string]$ConfigFile = "config.yaml"
)

$ErrorActionPreference = "Stop"
$Host.UI.RawUI.WindowTitle = "CLI Proxy API - Setup Manager"

# Colors
function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Type = "Info"
    )
    
    switch ($Type) {
        "Success" { Write-Host $Message -ForegroundColor Green }
        "Error"   { Write-Host $Message -ForegroundColor Red }
        "Warning" { Write-Host $Message -ForegroundColor Yellow }
        "Info"    { Write-Host $Message -ForegroundColor Cyan }
        "Title"   { Write-Host $Message -ForegroundColor Magenta }
        default   { Write-Host $Message }
    }
}

function Show-Banner {
    Clear-Host
    Write-Host ""
    Write-ColorOutput "╔══════════════════════════════════════════════════════════╗" -Type Title
    Write-ColorOutput "║     CLI PROXY API - SETUP MANAGER (PowerShell)           ║" -Type Title
    Write-ColorOutput "╚══════════════════════════════════════════════════════════╝" -Type Title
    Write-Host ""
}

function Show-Menu {
    Write-Host "  ═══════════════════════════════════════════════════" -ForegroundColor DarkGray
    Write-Host "  SETUP & CONFIG" -ForegroundColor Cyan
    Write-Host "  ═══════════════════════════════════════════════════" -ForegroundColor DarkGray
    Write-Host "  [1]  Setup Config File (Auto-Generate API Key)" -ForegroundColor White
    Write-Host "  [2]  Edit Config File" -ForegroundColor White
    Write-Host ""
    Write-Host "  ═══════════════════════════════════════════════════" -ForegroundColor DarkGray
    Write-Host "  PROVIDER LOGIN" -ForegroundColor Cyan
    Write-Host "  ═══════════════════════════════════════════════════" -ForegroundColor DarkGray
    Write-Host "  [3]  Login to Gemini CLI" -ForegroundColor White
    Write-Host "  [4]  Login to OpenAI Codex" -ForegroundColor White
    Write-Host "  [5]  Login to Claude Code" -ForegroundColor White
    Write-Host "  [6]  Login to GitHub Copilot" -ForegroundColor White
    Write-Host "  [7]  Login to Qwen" -ForegroundColor White
    Write-Host "  [8]  Login to iFlow" -ForegroundColor White
    Write-Host "  [9]  Login to Kiro (AWS CodeWhisperer)" -ForegroundColor White
    Write-Host "  [10] Login to Antigravity" -ForegroundColor White
    Write-Host ""
    Write-Host "  ═══════════════════════════════════════════════════" -ForegroundColor DarkGray
    Write-Host "  SERVER OPERATIONS" -ForegroundColor Cyan
    Write-Host "  ═══════════════════════════════════════════════════" -ForegroundColor DarkGray
    Write-Host "  [11] Start Server" -ForegroundColor Green
    Write-Host "  [12] Test API & List Models" -ForegroundColor Green
    Write-Host "  [13] View Server Status" -ForegroundColor Green
    Write-Host ""
    Write-Host "  ═══════════════════════════════════════════════════" -ForegroundColor DarkGray
    Write-Host "  TROUBLESHOOTING" -ForegroundColor Cyan
    Write-Host "  ═══════════════════════════════════════════════════" -ForegroundColor DarkGray
    Write-Host "  [14] Fix 401 Error (Auto-Diagnostic)" -ForegroundColor Yellow
    Write-Host "  [15] Full System Check" -ForegroundColor Yellow
    Write-Host "  [16] View Logs" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  ═══════════════════════════════════════════════════" -ForegroundColor DarkGray
    Write-Host "  MAINTENANCE" -ForegroundColor Cyan
    Write-Host "  ═══════════════════════════════════════════════════" -ForegroundColor DarkGray
    Write-Host "  [17] Update Repository" -ForegroundColor Magenta
    Write-Host "  [18] Backup Config & Auth" -ForegroundColor Magenta
    Write-Host "  [19] View Documentation" -ForegroundColor Magenta
    Write-Host ""
    Write-Host "  [0]  Exit" -ForegroundColor Red
    Write-Host ""
}

function Setup-Config {
    Write-ColorOutput "`n[INFO] Setting up config file..." -Type Info
    
    if (Test-Path $ConfigFile) {
        Write-ColorOutput "[WARNING] $ConfigFile already exists!" -Type Warning
        $overwrite = Read-Host "Overwrite? (y/n)"
        if ($overwrite -ne "y") {
            return
        }
    }
    
    try {
        Copy-Item "config.example.yaml" $ConfigFile -Force
        Write-ColorOutput "[SUCCESS] Config file created: $ConfigFile" -Type Success
        Write-ColorOutput "[INFO] Generating random API key..." -Type Info
        
        # Generate random API key
        $apiKey = "sk-" + [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes([Guid]::NewGuid().ToString()))
        
        # Update config with generated API key
        $content = Get-Content $ConfigFile -Raw
        $content = $content -replace "api-keys:\s*`n\s*-\s*`"your-api-key-1`"\s*`n\s*-\s*`"your-api-key-2`"", "api-keys:`n  - `"$apiKey`""
        $content | Set-Content $ConfigFile -Encoding UTF8
        
        Write-ColorOutput "[SUCCESS] Generated API Key: $apiKey" -Type Success
        Write-ColorOutput "[INFO] Please save this API key! It's stored in $ConfigFile" -Type Warning
        
        # Ask for additional settings
        Write-Host ""
        $customize = Read-Host "Customize settings now? (y/n)"
        if ($customize -eq "y") {
            $port = Read-Host "Enter port (default: 8317)"
            if ($port) {
                $content = Get-Content $ConfigFile -Raw
                $content = $content -replace 'port:\s*8317', "port: $port"
                $content | Set-Content $ConfigFile -Encoding UTF8
            }
            
            $debug = Read-Host "Enable debug logging? (y/n)"
            if ($debug -eq "y") {
                $content = Get-Content $ConfigFile -Raw
                $content = $content -replace 'debug:\s*false', "debug: true"
                $content | Set-Content $ConfigFile -Encoding UTF8
            }
        }
        
        Write-ColorOutput "[SUCCESS] Configuration completed!" -Type Success
    }
    catch {
        Write-ColorOutput "[ERROR] Failed to create config file: $_" -Type Error
    }
    
    Read-Host "`nPress Enter to continue"
}

function Invoke-Login {
    param(
        [string]$Provider,
        [string]$Flag,
        [switch]$HasOptions
    )
    
    Write-ColorOutput "`n[INFO] Logging in to $Provider..." -Type Info
    
    $incognito = Read-Host "Use incognito/private mode? (y/n)"
    $args = @($Flag)
    
    if ($incognito -eq "y") {
        $args += "-incognito"
    }
    
    # Special handling for Kiro
    if ($Provider -eq "Kiro") {
        Write-Host "`n  [1] Login with Google OAuth"
        Write-Host "  [2] Login with AWS Builder ID"
        Write-Host "  [3] Import from Kiro IDE"
        $kiroChoice = Read-Host "Choose method (1-3)"
        
        switch ($kiroChoice) {
            "1" { $args = @("-kiro-login") }
            "2" { $args = @("-kiro-aws-login") }
            "3" { 
                $args = @("-kiro-import")
                $incognito = "n" # No incognito for import
            }
        }
        
        if ($incognito -eq "y" -and $kiroChoice -ne "3") {
            $args += "-incognito"
        }
    }
    
    try {
        & ".\cli-proxy-api.exe" $args
        if ($LASTEXITCODE -eq 0) {
            Write-ColorOutput "[SUCCESS] Login completed!" -Type Success
        } else {
            Write-ColorOutput "[WARNING] Login may have failed. Check the output above." -Type Warning
        }
    }
    catch {
        Write-ColorOutput "[ERROR] Failed to execute login: $_" -Type Error
    }
    
    Read-Host "`nPress Enter to continue"
}

function Start-ProxyServer {
    Write-ColorOutput "`n[INFO] Starting CLI Proxy API Server..." -Type Info
    
    if (-not (Test-Path $ConfigFile)) {
        Write-ColorOutput "[ERROR] $ConfigFile not found! Please run Setup Config first." -Type Error
        Read-Host "`nPress Enter to continue"
        return
    }
    
    # Read config to get port
    try {
        $configContent = Get-Content $ConfigFile -Raw
        if ($configContent -match 'port:\s*(\d+)') {
            $port = $matches[1]
        } else {
            $port = "8317"
        }
        
        Write-ColorOutput "[INFO] Server will start on port: $port" -Type Info
        Write-ColorOutput "[INFO] API endpoint: http://localhost:$port" -Type Success
        Write-ColorOutput "[INFO] Press Ctrl+C to stop the server" -Type Warning
        Write-Host ""
        
        & ".\cli-proxy-api.exe" -config $ConfigFile
    }
    catch {
        Write-ColorOutput "[ERROR] Failed to start server: $_" -Type Error
        Read-Host "`nPress Enter to continue"
    }
}

function Test-API {
    Write-ColorOutput "`n[INFO] Testing API & Listing Models..." -Type Info
    
    if (-not (Test-Path $ConfigFile)) {
        Write-ColorOutput "[ERROR] $ConfigFile not found!" -Type Error
        Read-Host "`nPress Enter to continue"
        return
    }
    
    # Read port from config
    $configContent = Get-Content $ConfigFile -Raw
    if ($configContent -match 'port:\s*(\d+)') {
        $port = $matches[1]
    } else {
        $port = "8317"
    }
    
    # Try to get API key from config
    $apiKey = ""
    if ($configContent -match "api-keys:\s*`n\s*-\s*`"([^`"]+)`"") {
        $apiKey = $matches[1]
        Write-ColorOutput "[INFO] Using API key from config: $apiKey" -Type Info
    } else {
        $apiKey = Read-Host "Enter your API key"
        if (-not $apiKey) {
            Write-ColorOutput "[ERROR] API key required!" -Type Error
            Read-Host "`nPress Enter to continue"
            return
        }
    }
    
    $url = "http://localhost:$port/v1/models"
    Write-ColorOutput "[INFO] Fetching models from $url..." -Type Info
    
    try {
        $headers = @{
            "Authorization" = "Bearer $apiKey"
        }
        
        $response = Invoke-RestMethod -Uri $url -Headers $headers -Method Get
        
        Write-ColorOutput "`n[SUCCESS] Models fetched successfully!`n" -Type Success
        
        # Save to JSON file
        $response | ConvertTo-Json -Depth 10 | Set-Content "models.json" -Encoding UTF8
        Write-ColorOutput "[INFO] Models saved to models.json" -Type Info
        
        # Display models
        Write-Host "`n========================================" -ForegroundColor Cyan
        Write-Host "Available Models:" -ForegroundColor Cyan
        Write-Host "========================================" -ForegroundColor Cyan
        
        if ($response.data) {
            foreach ($model in $response.data) {
                Write-Host "  • $($model.id)" -ForegroundColor Green
                if ($model.owned_by) {
                    Write-Host "    Provider: $($model.owned_by)" -ForegroundColor Gray
                }
            }
            Write-Host "`nTotal Models: $($response.data.Count)" -ForegroundColor Yellow
        } else {
            Write-ColorOutput "[WARNING] No models found in response" -Type Warning
        }
        
        Write-Host ""
        $openHtml = Read-Host "Open models viewer in browser? (y/n)"
        if ($openHtml -eq "y" -and (Test-Path "models (2).html")) {
            Start-Process "models (2).html"
        }
    }
    catch {
        Write-ColorOutput "[ERROR] Failed to fetch models: $_" -Type Error
        Write-ColorOutput "[INFO] Make sure the server is running on port $port" -Type Warning
    }
    
    Read-Host "`nPress Enter to continue"
}

function Show-ServerStatus {
    Write-ColorOutput "`n[INFO] Checking Server Status..." -Type Info
    
    # Read port from config
    $port = "8317"
    if (Test-Path $ConfigFile) {
        $configContent = Get-Content $ConfigFile -Raw
        if ($configContent -match 'port:\s*(\d+)') {
            $port = $matches[1]
        }
    }
    
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:$port/v1/models" -Method Get -TimeoutSec 2 -UseBasicParsing
        Write-ColorOutput "[SUCCESS] Server is running on port $port" -Type Success
    }
    catch {
        Write-ColorOutput "[ERROR] Server is not running or not accessible on port $port" -Type Error
    }
    
    # Check if process is running
    $process = Get-Process -Name "cli-proxy-api" -ErrorAction SilentlyContinue
    if ($process) {
        Write-ColorOutput "[INFO] Process ID: $($process.Id)" -Type Info
        Write-ColorOutput "[INFO] Memory Usage: $([math]::Round($process.WorkingSet64/1MB, 2)) MB" -Type Info
        Write-ColorOutput "[INFO] CPU Time: $($process.CPU) seconds" -Type Info
    } else {
        Write-ColorOutput "[WARNING] CLI Proxy API process not found" -Type Warning
    }
    
    Read-Host "`nPress Enter to continue"
}

function Edit-ConfigFile {
    if (-not (Test-Path $ConfigFile)) {
        Write-ColorOutput "`n[ERROR] $ConfigFile not found! Please run Setup Config first." -Type Error
        Read-Host "`nPress Enter to continue"
        return
    }
    
    Write-ColorOutput "`n[INFO] Opening $ConfigFile in default editor..." -Type Info
    Start-Process notepad.exe $ConfigFile
    Read-Host "`nPress Enter to continue"
}

function Fix-401Error {
    Write-ColorOutput "`n╔══════════════════════════════════════════════════════════╗" -Type Warning
    Write-ColorOutput "║     FIX 401 UNAUTHORIZED ERROR - AUTO DIAGNOSTIC         ║" -Type Warning
    Write-ColorOutput "╚══════════════════════════════════════════════════════════╝" -Type Warning
    Write-Host ""
    
    $issues = @()
    $fixes = @()
    
    # Step 1: Check Config
    Write-ColorOutput "Step 1: Checking config.yaml..." -Type Info
    if (-not (Test-Path $ConfigFile)) {
        Write-ColorOutput "❌ config.yaml not found!" -Type Error
        $issues += "Config missing"
        $fixes += "Choose menu [1] to setup config"
        Read-Host "`nPress Enter to continue"
        return
    }
    
    $configContent = Get-Content $ConfigFile -Raw
    Write-ColorOutput "✅ config.yaml found" -Type Success
    
    # Step 2: Extract API Key
    Write-ColorOutput "`nStep 2: Checking API key format..." -Type Info
    $apiKey = ""
    
    if ($configContent -match "api-keys:\s*`n\s*-\s*`"([^`"]+)`"") {
        $apiKey = $matches[1]
        Write-ColorOutput "✅ API key found and properly quoted" -Type Success
        Write-ColorOutput "   Key: $($apiKey.Substring(0, [Math]::Min(20, $apiKey.Length)))..." -Type Info
    } 
    elseif ($configContent -match "api-keys:\s*`n\s*-\s*([^\s`n]+)") {
        Write-ColorOutput "❌ API key NOT quoted (this causes 401 error!)" -Type Error
        $badKey = $matches[1]
        Write-ColorOutput "   Current: - $badKey" -Type Error
        Write-ColorOutput '   Should be: - "' -NoNewline; Write-Host $badKey -NoNewline -ForegroundColor Green; Write-Host '"' -ForegroundColor Green
        
        $fix = Read-Host "`nAuto-fix now? (y/n)"
        if ($fix -eq "y") {
            $configContent = $configContent -replace "(api-keys:\s*`n\s*-\s*)([^\s`n`"]+)", "`$1`"`$2`""
            $configContent | Set-Content $ConfigFile -Encoding UTF8
            Write-ColorOutput "✅ Fixed! API key now properly quoted." -Type Success
            $apiKey = $badKey
        } else {
            $issues += "API key format incorrect"
            $fixes += "Choose menu [1] to regenerate config"
        }
    }
    else {
        Write-ColorOutput "❌ No API key found!" -Type Error
        $issues += "API key missing"
        $fixes += "Choose menu [1] to setup config"
    }
    
    # Step 3: Get Port
    $port = 8317
    if ($configContent -match 'port:\s*(\d+)') {
        $port = [int]$matches[1]
    }
    
    # Step 4: Check Server
    Write-ColorOutput "`nStep 3: Checking server..." -Type Info
    $process = Get-Process -Name "cli-proxy-api" -ErrorAction SilentlyContinue
    if (-not $process) {
        Write-ColorOutput "❌ Server not running!" -Type Error
        $issues += "Server not running"
        $fixes += "Choose menu [11] to start server"
    } else {
        Write-ColorOutput "✅ Server running (PID: $($process.Id))" -Type Success
    }
    
    # Step 5: Test API
    if ($process -and $apiKey) {
        Write-ColorOutput "`nStep 4: Testing API with correct key..." -Type Info
        $headers = @{ "Authorization" = "Bearer $apiKey" }
        
        try {
            $response = Invoke-RestMethod -Uri "http://localhost:$port/v1/models" -Headers $headers -TimeoutSec 5
            Write-ColorOutput "✅ API test SUCCESSFUL!" -Type Success
            
            if ($response.data) {
                Write-ColorOutput "`n📊 Models Found: $($response.data.Count)" -Type Info
                $providers = $response.data | Group-Object -Property owned_by
                foreach ($provider in $providers) {
                    Write-ColorOutput "   • $($provider.Name): $($provider.Count) model(s)" -Type Success
                }
            } else {
                Write-ColorOutput "⚠️  API works but no models!" -Type Warning
                $issues += "No models"
                $fixes += "Login to a provider (menu 3-10)"
            }
        }
        catch {
            Write-ColorOutput "❌ API test failed: $($_.Exception.Message)" -Type Error
            if ($_.Exception.Message -like "*401*") {
                $issues += "401 Error persists"
                $fixes += "Regenerate config (menu [1])"
                $fixes += "Restart server (menu [11])"
            }
        }
    }
    
    # Summary
    Write-Host ""
    Write-ColorOutput "══════════════════════════════════════════════════════════" -Type Info
    if ($issues.Count -eq 0) {
        Write-ColorOutput "🎉 NO ISSUES FOUND! System is healthy." -Type Success
    } else {
        Write-ColorOutput "⚠️  Issues: $($issues.Count)" -Type Warning
        foreach ($issue in $issues) {
            Write-ColorOutput "   • $issue" -Type Error
        }
        Write-Host ""
        Write-ColorOutput "💡 Recommended Actions:" -Type Warning
        foreach ($fix in ($fixes | Select-Object -Unique)) {
            Write-ColorOutput "   → $fix" -Type Info
        }
    }
    Write-ColorOutput "══════════════════════════════════════════════════════════" -Type Info
    
    Read-Host "`nPress Enter to continue"
}

function Show-FullSystemCheck {
    Write-ColorOutput "`n╔══════════════════════════════════════════════════════════╗" -Type Info
    Write-ColorOutput "║     FULL SYSTEM CHECK                                    ║" -Type Info
    Write-ColorOutput "╚══════════════════════════════════════════════════════════╝" -Type Info
    Write-Host ""
    
    # Run the check-status script if exists
    if (Test-Path "scripts\check-status.ps1") {
        & ".\scripts\check-status.ps1"
    } else {
        # Inline basic check
        Write-ColorOutput "Running basic system check..." -Type Info
        Write-Host ""
        
        # Config check
        Write-ColorOutput "📄 Config: " -Type Info -NoNewline
        if (Test-Path $ConfigFile) {
            Write-ColorOutput "✅ Found" -Type Success
        } else {
            Write-ColorOutput "❌ Missing" -Type Error
        }
        
        # Auth check
        Write-ColorOutput "🔑 Auth: " -Type Info -NoNewline
        $authPath = "$env:USERPROFILE\.cli-proxy-api"
        if (Test-Path $authPath) {
            $authFiles = Get-ChildItem $authPath -Recurse -File -ErrorAction SilentlyContinue
            if ($authFiles -and $authFiles.Count -gt 0) {
                Write-ColorOutput "✅ $($authFiles.Count) file(s)" -Type Success
            } else {
                Write-ColorOutput "❌ No auth files" -Type Error
            }
        } else {
            Write-ColorOutput "❌ No auth directory" -Type Error
        }
        
        # Server check
        Write-ColorOutput "⚙️  Server: " -Type Info -NoNewline
        $process = Get-Process -Name "cli-proxy-api" -ErrorAction SilentlyContinue
        if ($process) {
            Write-ColorOutput "✅ Running (PID: $($process.Id))" -Type Success
        } else {
            Write-ColorOutput "❌ Not running" -Type Error
        }
        
        Write-Host ""
    }
    
    Read-Host "Press Enter to continue"
}

function Show-Logs {
    Write-ColorOutput "`n[INFO] Viewing logs..." -Type Info
    
    # Check if logging to file is enabled
    if (Test-Path $ConfigFile) {
        $configContent = Get-Content $ConfigFile -Raw
        if ($configContent -match 'logging-to-file:\s*true') {
            if (Test-Path "logs") {
                Write-ColorOutput "[INFO] Log files found. Opening latest..." -Type Info
                $latestLog = Get-ChildItem "logs" -Filter "*.log" | Sort-Object LastWriteTime -Descending | Select-Object -First 1
                if ($latestLog) {
                    Start-Process notepad.exe $latestLog.FullName
                } else {
                    Write-ColorOutput "[WARNING] No log files found in logs/" -Type Warning
                }
            } else {
                Write-ColorOutput "[WARNING] Logs directory not found" -Type Warning
            }
        } else {
            Write-ColorOutput "[INFO] File logging not enabled in config" -Type Info
            Write-ColorOutput "[INFO] To enable: Set 'logging-to-file: true' in config.yaml" -Type Info
            
            $enable = Read-Host "`nEnable file logging now? (y/n)"
            if ($enable -eq "y") {
                $configContent = $configContent -replace 'logging-to-file:\s*false', 'logging-to-file: true'
                $configContent | Set-Content $ConfigFile -Encoding UTF8
                Write-ColorOutput "[SUCCESS] File logging enabled! Restart server to apply." -Type Success
            }
        }
    }
    
    Read-Host "`nPress Enter to continue"
}

function Update-Repository {
    Write-ColorOutput "`n[INFO] Updating repository..." -Type Info
    
    if (Test-Path "scripts\update.ps1") {
        & ".\scripts\update.ps1"
    } else {
        Write-ColorOutput "[ERROR] Update script not found!" -Type Error
        Write-Host ""
        Write-ColorOutput "[INFO] Manual update:" -Type Info
        Write-ColorOutput "   1. Backup config.yaml" -Type Info
        Write-ColorOutput "   2. Download latest from GitHub" -Type Info
        Write-ColorOutput "   3. Extract and replace files" -Type Info
        Write-ColorOutput "   4. Restore config.yaml" -Type Info
    }
    
    Read-Host "`nPress Enter to continue"
}

function Backup-ConfigAuth {
    Write-ColorOutput "`n[INFO] Creating backup..." -Type Info
    
    $date = Get-Date -Format "yyyyMMdd_HHmmss"
    $backupDir = "backup_$date"
    
    try {
        New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
        
        if (Test-Path $ConfigFile) {
            Copy-Item $ConfigFile "$backupDir\config.yaml"
            Write-ColorOutput "[SUCCESS] Config backed up to $backupDir\config.yaml" -Type Success
        }
        
        if (Test-Path "$env:USERPROFILE\.cli-proxy-api") {
            $authBackup = "$backupDir\auth"
            Copy-Item -Recurse "$env:USERPROFILE\.cli-proxy-api" $authBackup
            Write-ColorOutput "[SUCCESS] Auth backed up to $authBackup" -Type Success
        }
        
        Write-ColorOutput "[SUCCESS] Backup completed: $backupDir" -Type Success
    }
    catch {
        Write-ColorOutput "[ERROR] Backup failed: $_" -Type Error
    }
    
    Read-Host "`nPress Enter to continue"
}

function Show-Documentation {
    Write-ColorOutput "`n[INFO] Opening documentation..." -Type Info
    Write-Host ""
    Write-Host "  Available documentation:" -ForegroundColor Cyan
    Write-Host "  [1] Quick Start Guide (README-ID.md)" -ForegroundColor White
    Write-Host "  [2] Fix 401 Error Guide (FIX-401-ERROR.md)" -ForegroundColor White
    Write-Host "  [3] Tutorial Folder" -ForegroundColor White
    Write-Host "  [4] Open in Browser (README-ID.md)" -ForegroundColor White
    Write-Host ""
    
    $docChoice = Read-Host "Choose (1-4)"
    
    switch ($docChoice) {
        "1" { 
            if (Test-Path "README-ID.md") {
                Start-Process notepad.exe "README-ID.md"
            }
        }
        "2" { 
            if (Test-Path "FIX-401-ERROR.md") {
                Start-Process notepad.exe "FIX-401-ERROR.md"
            }
        }
        "3" { 
            if (Test-Path "tutorial") {
                Start-Process explorer.exe "tutorial"
            }
        }
        "4" { 
            if (Test-Path "README-ID.md") {
                Start-Process "README-ID.md"
            }
        }
    }
    
    Read-Host "`nPress Enter to continue"
}

function Start-ServerNewTab {
    Write-ColorOutput "`n[INFO] Starting CLI Proxy API Server..." -Type Info
    Write-Host ""
    
    if (-not (Test-Path $ConfigFile)) {
        Write-ColorOutput "[ERROR] $ConfigFile not found! Please setup config first." -Type Error
        Read-Host "`nPress Enter to continue"
        return
    }
    
    # Check if server already running
    $process = Get-Process -Name "cli-proxy-api" -ErrorAction SilentlyContinue
    if ($process) {
        Write-ColorOutput "[WARNING] Server already running (PID: $($process.Id))" -Type Warning
        $restart = Read-Host "Kill and restart? (y/n)"
        if ($restart -eq "y") {
            Stop-Process -Id $process.Id -Force
            Start-Sleep -Seconds 2
            Write-ColorOutput "[INFO] Server stopped" -Type Info
        } else {
            Read-Host "`nPress Enter to continue"
            return
        }
    }
    
    # Read config for info
    $configContent = Get-Content $ConfigFile -Raw
    $port = "8317"
    if ($configContent -match 'port:\s*(\d+)') {
        $port = $matches[1]
    }
    
    $apiKey = ""
    if ($configContent -match "api-keys:\s*`n\s*-\s*`"([^`"]+)`"") {
        $apiKey = $matches[1]
    }
    
    Write-ColorOutput "[INFO] Port: $port" -Type Info
    if ($apiKey) {
        Write-ColorOutput "[INFO] API Key: $($apiKey.Substring(0, [Math]::Min(20, $apiKey.Length)))..." -Type Info
    }
    Write-ColorOutput "[INFO] Endpoint: http://localhost:$port" -Type Success
    Write-Host ""
    Write-ColorOutput "[INFO] Server will start in THIS terminal" -Type Warning
    Write-ColorOutput "[INFO] Open NEW PowerShell tab if you want to run other commands" -Type Warning
    Write-ColorOutput "[INFO] Press Ctrl+C to stop the server" -Type Warning
    Write-Host ""
    
    $confirm = Read-Host "Start server now? (y/n)"
    if ($confirm -ne "y") {
        return
    }
    
    Write-Host ""
    # Start server in current terminal
    & ".\cli-proxy-api.exe" -config $ConfigFile
}

# Main Loop
if ($AutoStart) {
    Start-ProxyServer
    exit
}

while ($true) {
    Show-Banner
    Show-Menu
    
    $choice = Read-Host "Pilih menu (0-19)"
    
    switch ($choice) {
        "0" {
            Write-ColorOutput "`n[INFO] Exiting..." -Type Info
            exit
        }
        # SETUP & CONFIG
        "1" { Setup-Config }
        "2" { Edit-ConfigFile }
        
        # PROVIDER LOGIN
        "3" { Invoke-Login -Provider "Gemini CLI" -Flag "-login" }
        "4" { Invoke-Login -Provider "OpenAI Codex" -Flag "-codex-login" }
        "5" { Invoke-Login -Provider "Claude Code" -Flag "-claude-login" }
        "6" { Invoke-Login -Provider "GitHub Copilot" -Flag "-github-copilot-login" }
        "7" { Invoke-Login -Provider "Qwen" -Flag "-qwen-login" }
        "8" { Invoke-Login -Provider "iFlow" -Flag "-iflow-login" }
        "9" { Invoke-Login -Provider "Kiro" -Flag "-kiro-login" -HasOptions }
        "10" { Invoke-Login -Provider "Antigravity" -Flag "-antigravity-login" }
        
        # SERVER OPERATIONS
        "11" { Start-ServerNewTab }
        "12" { Test-API }
        "13" { Show-ServerStatus }
        
        # TROUBLESHOOTING
        "14" { Fix-401Error }
        "15" { Show-FullSystemCheck }
        "16" { Show-Logs }
        
        # MAINTENANCE
        "17" { Update-Repository }
        "18" { Backup-ConfigAuth }
        "19" { Show-Documentation }
        
        default {
            Write-ColorOutput "`n[ERROR] Invalid choice! Please choose 0-19" -Type Error
            Start-Sleep -Seconds 1
        }
    }
}
