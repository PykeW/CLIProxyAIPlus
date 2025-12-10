# CLI Proxy API - Auto Update Script
param(
    [switch]$SkipBackup,
    [switch]$Force
)

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "╔══════════════════════════════════════════════════════════╗" -ForegroundColor Magenta
Write-Host "║     CLI PROXY API - AUTO UPDATE                          ║" -ForegroundColor Magenta
Write-Host "╚══════════════════════════════════════════════════════════╝" -ForegroundColor Magenta
Write-Host ""

# Check if git repo
if (-not (Test-Path .git)) {
    Write-Host "❌ Not a git repository!" -ForegroundColor Red
    Write-Host ""
    Write-Host "💡 This folder is not cloned from git." -ForegroundColor Yellow
    Write-Host "   To update manually:" -ForegroundColor Yellow
    Write-Host "   1. Download latest release from:" -ForegroundColor White
    Write-Host "      https://github.com/router-for-me/CLIProxyAPI/releases" -ForegroundColor Cyan
    Write-Host "   2. Extract and replace files (keep your config.yaml)" -ForegroundColor White
    Write-Host "   3. Auth tokens in ~/.cli-proxy-api will be preserved" -ForegroundColor White
    Write-Host ""
    exit 1
}

# Backup
if (-not $SkipBackup) {
    Write-Host "📦 Creating backup..." -ForegroundColor Yellow
    $date = Get-Date -Format "yyyyMMdd_HHmmss"
    $backupDir = "backup_$date"
    
    try {
        New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
        
        if (Test-Path config.yaml) {
            Copy-Item config.yaml "$backupDir\config.yaml"
            Write-Host "✅ Config backed up to $backupDir\config.yaml" -ForegroundColor Green
        }
        
        if (Test-Path "~/.cli-proxy-api") {
            $authBackupPath = "$env:USERPROFILE\.cli-proxy-api.backup.$date"
            Copy-Item -Recurse "~/.cli-proxy-api" $authBackupPath
            Write-Host "✅ Auth backed up to $authBackupPath" -ForegroundColor Green
        }
        
        Write-Host ""
    } catch {
        Write-Host "⚠️  Backup failed: $_" -ForegroundColor Yellow
        if (-not $Force) {
            $continue = Read-Host "Continue without backup? (y/n)"
            if ($continue -ne "y") {
                Write-Host "Update cancelled." -ForegroundColor Red
                exit 1
            }
        }
    }
}

# Check for uncommitted changes
Write-Host "🔍 Checking for local changes..." -ForegroundColor Cyan
$status = git status --porcelain

if ($status) {
    Write-Host "⚠️  You have uncommitted changes:" -ForegroundColor Yellow
    Write-Host $status -ForegroundColor Gray
    Write-Host ""
    
    if (-not $Force) {
        $stash = Read-Host "Stash changes and continue? (y/n)"
        if ($stash -eq "y") {
            Write-Host "📦 Stashing changes..." -ForegroundColor Yellow
            git stash save "Auto-stash before update at $date"
            Write-Host "✅ Changes stashed" -ForegroundColor Green
        } else {
            Write-Host "Update cancelled." -ForegroundColor Red
            exit 1
        }
    }
}

# Fetch updates
Write-Host "📥 Fetching updates from remote..." -ForegroundColor Cyan
try {
    git fetch origin main
    
    $LOCAL = git rev-parse @
    $REMOTE = git rev-parse "@{u}"
    
    if ($LOCAL -eq $REMOTE) {
        Write-Host "✅ Already up to date!" -ForegroundColor Green
        Write-Host ""
        exit 0
    }
    
    # Show what will be updated
    Write-Host ""
    Write-Host "📋 New commits available:" -ForegroundColor Yellow
    git log --oneline "$LOCAL..$REMOTE" | ForEach-Object {
        Write-Host "   • $_" -ForegroundColor Cyan
    }
    Write-Host ""
    
    if (-not $Force) {
        $confirm = Read-Host "Continue with update? (y/n)"
        if ($confirm -ne "y") {
            Write-Host "Update cancelled." -ForegroundColor Red
            exit 1
        }
    }
    
} catch {
    Write-Host "❌ Failed to fetch updates: $_" -ForegroundColor Red
    exit 1
}

# Pull updates
Write-Host "📥 Pulling updates..." -ForegroundColor Cyan
try {
    git pull origin main
    Write-Host "✅ Update successful!" -ForegroundColor Green
    Write-Host ""
} catch {
    Write-Host "❌ Update failed: $_" -ForegroundColor Red
    Write-Host ""
    Write-Host "💡 Try manual update:" -ForegroundColor Yellow
    Write-Host "   git pull origin main" -ForegroundColor White
    exit 1
}

# Restore config if needed
if (-not (Test-Path config.yaml)) {
    Write-Host "⚠️  config.yaml not found after update" -ForegroundColor Yellow
    
    # Try to restore from backup
    if (Test-Path $backupDir) {
        if (Test-Path "$backupDir\config.yaml") {
            Copy-Item "$backupDir\config.yaml" config.yaml
            Write-Host "✅ Restored config from backup" -ForegroundColor Green
        }
    } else {
        # Check for any backup
        $latestBackup = Get-ChildItem config.backup.*.yaml -ErrorAction SilentlyContinue | 
            Sort-Object Name -Descending | 
            Select-Object -First 1
        
        if ($latestBackup) {
            Copy-Item $latestBackup config.yaml
            Write-Host "✅ Restored config from $($latestBackup.Name)" -ForegroundColor Green
        } else {
            Write-Host "⚠️  No backup found. You need to run setup again." -ForegroundColor Yellow
        }
    }
}

# Check if server is running
$process = Get-Process -Name "cli-proxy-api" -ErrorAction SilentlyContinue
if ($process) {
    Write-Host "⚠️  Server is currently running (PID: $($process.Id))" -ForegroundColor Yellow
    Write-Host "   You need to restart it to apply updates." -ForegroundColor Yellow
    Write-Host ""
    
    $restart = Read-Host "Restart server now? (y/n)"
    if ($restart -eq "y") {
        Write-Host "🔄 Stopping server..." -ForegroundColor Cyan
        Stop-Process -Id $process.Id -Force
        Start-Sleep -Seconds 2
        
        Write-Host "🚀 Starting server..." -ForegroundColor Cyan
        if (Test-Path "start-server.ps1") {
            Start-Process powershell -ArgumentList "-NoExit", "-File", ".\start-server.ps1"
            Write-Host "✅ Server restarted in new window" -ForegroundColor Green
        } else {
            Write-Host "⚠️  start-server.ps1 not found. Start manually:" -ForegroundColor Yellow
            Write-Host "   .\cli-proxy-api.exe -config config.yaml" -ForegroundColor White
        }
    }
}

# Summary
Write-Host ""
Write-Host "══════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "UPDATE COMPLETE!" -ForegroundColor Green
Write-Host "══════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host ""
Write-Host "✅ Repository updated to latest version" -ForegroundColor Green
Write-Host "✅ Config preserved: config.yaml" -ForegroundColor Green
Write-Host "✅ Auth tokens preserved: ~/.cli-proxy-api" -ForegroundColor Green

if (Test-Path $backupDir) {
    Write-Host "✅ Backup created: $backupDir" -ForegroundColor Green
}

Write-Host ""
Write-Host "💡 Next steps:" -ForegroundColor Yellow
Write-Host "   • Start server: .\start-server.ps1" -ForegroundColor White
Write-Host "   • Test API: .\test-api.ps1" -ForegroundColor White
Write-Host "   • Check status: .\check-status.ps1" -ForegroundColor White
Write-Host ""
