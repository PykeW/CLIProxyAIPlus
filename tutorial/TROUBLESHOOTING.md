# 🔧 Troubleshooting Guide - CLI Proxy API Plus

## ❌ Problem: "CONNECTION FAILED" di Browser + Total Models: 0

### 🔍 Diagnosis
Dari screenshot Anda:
```
• Total Models: 0
• Providers: 0
• Status: Ready
```

**Penyebab:** Belum ada provider yang login, jadi tidak ada models yang tersedia.

### ✅ Solusi

#### Step 1: Login ke Provider (WAJIB!)

Server memerlukan minimal 1 provider untuk bekerja. Pilih salah satu:

**Option A: Gemini CLI (Google) - RECOMMENDED untuk test**
```powershell
.\cli-proxy-api.exe -login
```

**Option B: OpenAI Codex**
```powershell
.\cli-proxy-api.exe -codex-login
```

**Option C: Claude Code**
```powershell
.\cli-proxy-api.exe -claude-login
```

**Option D: GitHub Copilot**
```powershell
.\cli-proxy-api.exe -github-copilot-login
```

#### Step 2: Restart Server

Setelah login provider:
```powershell
# Stop server (Ctrl+C di terminal server)
# Start lagi
.\start-server.ps1
```

#### Step 3: Test Lagi

```powershell
.\test-api.ps1 -OpenBrowser
```

Sekarang seharusnya muncul models!

---

## ❌ Problem: 401 Unauthorized di Logs

### 🔍 Diagnosis
```
[warning] [gin_logger.go:62] [GIN] 2025/12/09 - 20:22:48 | 401
```

**Penyebab:** API key tidak match atau tidak ada di request.

### ✅ Solusi

#### Verify API Key

1. **Cek API key di config:**
```powershell
Get-Content config.yaml | Select-String "api-keys" -Context 0,3
```

Output akan seperti:
```yaml
api-keys:
  - "sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
```

2. **Test dengan API key yang benar:**
```powershell
# Ganti YOUR-API-KEY dengan API key dari config.yaml
curl http://localhost:8317/v1/models -H "Authorization: Bearer YOUR-API-KEY"
```

3. **Atau gunakan test script (otomatis pakai key dari config):**
```powershell
.\test-api.ps1
```

---

## ❌ Problem: Browser Shows "Verify proxy server at http://127.0.0.1:8317"

### 🔍 Diagnosis
File HTML mencoba connect tapi gagal karena:
1. Tidak ada models (belum login provider)
2. API endpoint tidak response dengan benar

### ✅ Solusi

#### Method 1: Login Provider Dulu (Rekomendasi)

```powershell
# 1. Login ke Gemini (paling mudah untuk test)
.\cli-proxy-api.exe -login

# 2. Restart server
# Tekan Ctrl+C di terminal server, lalu:
.\start-server.ps1

# 3. Test API
.\test-api.ps1

# 4. Buka browser
start "models (2).html"
```

#### Method 2: Update models-data.js Manual

Jika sudah ada models tapi browser tidak load:

```powershell
# Generate ulang data
.\test-api.ps1 -OpenBrowser
```

---

## 🔄 Cara Update Repository

### Method 1: Git Pull (Jika Clone dari Git)

```powershell
# 1. Backup config dan auth
Copy-Item config.yaml config.yaml.backup
Copy-Item -Recurse ~/.cli-proxy-api ~/.cli-proxy-api.backup

# 2. Pull update
git pull origin main

# 3. Restore config (jika di-overwrite)
if (!(Test-Path config.yaml) -or (Select-String "your-api-key" config.yaml)) {
    Copy-Item config.yaml.backup config.yaml
}

# 4. Auth tokens seharusnya masih ada di ~/.cli-proxy-api
# Jika hilang, restore:
# Copy-Item -Recurse ~/.cli-proxy-api.backup ~/.cli-proxy-api

# 5. Restart server
.\start-server.ps1
```

### Method 2: Download Fresh (Jika Download Manual)

```powershell
# 1. Backup penting
Copy-Item config.yaml backup_config.yaml
Copy-Item -Recurse ~/.cli-proxy-api backup_auth

# 2. Download release baru dari GitHub
# Extract ke folder baru atau overwrite

# 3. Restore config
Copy-Item backup_config.yaml config.yaml

# 4. Auth tokens sudah di ~/.cli-proxy-api (tetap ada)

# 5. Update scripts (optional)
# Copy script baru: setup.ps1, start-server.ps1, test-api.ps1

# 6. Restart
.\start-server.ps1
```

### Auto-Update Script

Saya buatkan script untuk auto-update:

```powershell
# update.ps1
param(
    [switch]$SkipBackup
)

Write-Host "🔄 CLI Proxy API - Auto Update" -ForegroundColor Cyan
Write-Host ""

# Backup
if (-not $SkipBackup) {
    Write-Host "📦 Creating backup..." -ForegroundColor Yellow
    $date = Get-Date -Format "yyyyMMdd_HHmmss"
    
    if (Test-Path config.yaml) {
        Copy-Item config.yaml "config.backup.$date.yaml"
        Write-Host "✅ Config backed up to config.backup.$date.yaml" -ForegroundColor Green
    }
    
    if (Test-Path ~/.cli-proxy-api) {
        Copy-Item -Recurse ~/.cli-proxy-api "~/.cli-proxy-api.backup.$date"
        Write-Host "✅ Auth backed up to ~/.cli-proxy-api.backup.$date" -ForegroundColor Green
    }
}

# Check if git repo
if (Test-Path .git) {
    Write-Host "📥 Pulling from Git..." -ForegroundColor Yellow
    git pull origin main
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Update successful!" -ForegroundColor Green
    } else {
        Write-Host "❌ Update failed!" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "❌ Not a git repository" -ForegroundColor Red
    Write-Host "💡 Download latest release manually from:" -ForegroundColor Yellow
    Write-Host "   https://github.com/router-for-me/CLIProxyAPI/releases" -ForegroundColor Cyan
    exit 1
}

# Restore config if needed
if ((Test-Path config.example.yaml) -and (-not (Test-Path config.yaml))) {
    Write-Host "⚠️  config.yaml not found, checking backup..." -ForegroundColor Yellow
    $latestBackup = Get-ChildItem config.backup.*.yaml | Sort-Object Name -Descending | Select-Object -First 1
    if ($latestBackup) {
        Copy-Item $latestBackup config.yaml
        Write-Host "✅ Restored config from $($latestBackup.Name)" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "🎉 Update complete!" -ForegroundColor Green
Write-Host "💡 Run: .\start-server.ps1 to start server" -ForegroundColor Cyan
```

### Notification untuk Update

Tambahkan di `start-server.ps1` untuk check update:

```powershell
# Check for updates (if git repo)
if (Test-Path .git) {
    Write-Host "[INFO] Checking for updates..." -ForegroundColor Cyan
    git fetch origin main 2>$null
    $LOCAL = git rev-parse @
    $REMOTE = git rev-parse "@{u}"
    
    if ($LOCAL -ne $REMOTE) {
        Write-Host "[UPDATE AVAILABLE] New version available!" -ForegroundColor Yellow
        Write-Host "Run: .\update.ps1" -ForegroundColor Yellow
        Write-Host ""
        $update = Read-Host "Update now? (y/n)"
        if ($update -eq "y") {
            & ".\update.ps1"
            exit
        }
    }
}
```

---

## 📋 Checklist Troubleshooting

Gunakan checklist ini untuk troubleshooting:

```
✅ Config file exists (config.yaml)
✅ API key set in config
✅ Login to at least 1 provider
✅ Auth files exist in ~/.cli-proxy-api/
✅ Server running (check with: Get-Process cli-proxy-api)
✅ Port 8317 accessible (check with: Test-NetConnection localhost -Port 8317)
✅ Models available (check with: .\test-api.ps1)
✅ API key correct in requests
```

### Quick Check Script

```powershell
# check-status.ps1
Write-Host "🔍 CLI Proxy API - Status Check" -ForegroundColor Cyan
Write-Host ""

# 1. Config
if (Test-Path config.yaml) {
    Write-Host "✅ Config file exists" -ForegroundColor Green
    $config = Get-Content config.yaml -Raw
    if ($config -match 'api-keys:\s*\n\s*-\s*"([^"]+)"') {
        Write-Host "✅ API key set: $($matches[1].Substring(0,10))..." -ForegroundColor Green
    } else {
        Write-Host "❌ API key not set!" -ForegroundColor Red
    }
} else {
    Write-Host "❌ Config file missing!" -ForegroundColor Red
}

# 2. Auth files
$authPath = "$env:USERPROFILE\.cli-proxy-api"
if (Test-Path $authPath) {
    $authFiles = Get-ChildItem $authPath -Recurse -File
    if ($authFiles.Count -gt 0) {
        Write-Host "✅ Auth files: $($authFiles.Count) files" -ForegroundColor Green
        
        # List providers
        $providers = Get-ChildItem $authPath -Directory
        foreach ($provider in $providers) {
            $files = Get-ChildItem $provider.FullName -File
            if ($files.Count -gt 0) {
                Write-Host "   • $($provider.Name): $($files.Count) accounts" -ForegroundColor Cyan
            }
        }
    } else {
        Write-Host "❌ No auth files! Please login to a provider." -ForegroundColor Red
    }
} else {
    Write-Host "❌ Auth directory missing! Please login to a provider." -ForegroundColor Red
}

# 3. Server process
$process = Get-Process cli-proxy-api -ErrorAction SilentlyContinue
if ($process) {
    Write-Host "✅ Server running (PID: $($process.Id))" -ForegroundColor Green
} else {
    Write-Host "❌ Server not running" -ForegroundColor Red
}

# 4. Port check
try {
    $port = 8317
    if (Test-Path config.yaml) {
        $configContent = Get-Content config.yaml -Raw
        if ($configContent -match 'port:\s*(\d+)') {
            $port = [int]$matches[1]
        }
    }
    
    $connection = Test-NetConnection localhost -Port $port -WarningAction SilentlyContinue
    if ($connection.TcpTestSucceeded) {
        Write-Host "✅ Port $port accessible" -ForegroundColor Green
    } else {
        Write-Host "❌ Port $port not accessible" -ForegroundColor Red
    }
} catch {
    Write-Host "⚠️  Cannot test port" -ForegroundColor Yellow
}

# 5. API test
if ($process -and (Test-Path config.yaml)) {
    Write-Host ""
    Write-Host "🧪 Testing API..." -ForegroundColor Cyan
    try {
        $configContent = Get-Content config.yaml -Raw
        $apiKey = ""
        if ($configContent -match 'api-keys:\s*\n\s*-\s*"([^"]+)"') {
            $apiKey = $matches[1]
        }
        
        $port = 8317
        if ($configContent -match 'port:\s*(\d+)') {
            $port = $matches[1]
        }
        
        $headers = @{
            "Authorization" = "Bearer $apiKey"
        }
        
        $response = Invoke-RestMethod -Uri "http://localhost:$port/v1/models" -Headers $headers -TimeoutSec 5
        
        if ($response.data) {
            Write-Host "✅ API working: $($response.data.Count) models" -ForegroundColor Green
            
            # Group by provider
            $providers = $response.data | Group-Object -Property owned_by
            foreach ($provider in $providers) {
                Write-Host "   • $($provider.Name): $($provider.Count) models" -ForegroundColor Cyan
            }
        } else {
            Write-Host "⚠️  API working but no models found" -ForegroundColor Yellow
        }
    } catch {
        Write-Host "❌ API test failed: $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "💡 Recommendations:" -ForegroundColor Yellow

if (-not (Test-Path config.yaml)) {
    Write-Host "   1. Run: .\setup.ps1 and choose [1] Setup Config" -ForegroundColor White
}

if (-not (Test-Path $authPath) -or (Get-ChildItem $authPath -Recurse -File).Count -eq 0) {
    Write-Host "   1. Run: .\setup.ps1 and choose [2-9] to login" -ForegroundColor White
}

if (-not $process) {
    Write-Host "   2. Run: .\start-server.ps1" -ForegroundColor White
}
```

---

## 🎯 Quick Fix Commands

### Scenario 1: Fresh Start (No Models)
```powershell
# 1. Login
.\cli-proxy-api.exe -login

# 2. Start
.\start-server.ps1

# 3. Test
.\test-api.ps1 -OpenBrowser
```

### Scenario 2: Update Repository
```powershell
# 1. Backup
Copy-Item config.yaml config.backup.yaml
Copy-Item -Recurse ~/.cli-proxy-api ~/.cli-proxy-api.backup

# 2. Update
git pull origin main

# 3. Restart
.\start-server.ps1
```

### Scenario 3: Complete Reset
```powershell
# 1. Stop server (Ctrl+C)

# 2. Clean
Remove-Item config.yaml
Remove-Item -Recurse ~/.cli-proxy-api

# 3. Setup ulang
.\setup.ps1
```

---

## 📞 Still Having Issues?

Jika masih ada masalah:

1. **Check logs dengan debug mode:**
   ```powershell
   # Edit config.yaml
   debug: true
   logging-to-file: true
   
   # Restart server
   .\start-server.ps1
   
   # Logs ada di folder logs/
   ```

2. **Run status check:**
   ```powershell
   .\check-status.ps1
   ```

3. **Manual test:**
   ```powershell
   # Get API key
   $apiKey = (Get-Content config.yaml | Select-String 'api-keys' -Context 0,1 | Select-Object -First 1).ToString().Split('"')[1]
   
   # Test
   curl http://localhost:8317/v1/models -H "Authorization: Bearer $apiKey"
   ```

4. **Open issue di GitHub:**
   https://github.com/router-for-me/CLIProxyAPI/issues
