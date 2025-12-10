# 🛠️ CLI Proxy API Plus - Setup Tools

Kumpulan script helper untuk mempermudah instalasi, konfigurasi, dan testing CLI Proxy API Plus.

## 📦 Apa yang Sudah Dibuat?

### ✅ Script Tools (8 files)

1. **`setup.ps1`** - PowerShell Interactive Setup ⭐ **RECOMMENDED**
2. **`setup.bat`** - Command Prompt Interactive Setup
3. **`start-server.ps1`** - Quick Start Server (PowerShell)
4. **`start-server.bat`** - Quick Start Server (CMD)
5. **`test-api.ps1`** - API Testing & Model Viewer Generator

### ✅ Dokumentasi (3 files)

6. **`SETUP-GUIDE.md`** - Panduan lengkap dengan troubleshooting
7. **`QUICK-START.md`** - Quick reference untuk memulai
8. **`DEMO.md`** - Demo penggunaan dengan contoh output

## 🎯 Fitur Utama

### 📋 Menu Interaktif
- Setup config otomatis dengan API key generator
- Login ke berbagai provider (Gemini, Codex, Claude, dll)
- Start/stop server
- Test API dan list models
- Server status checker
- Config editor

### 🎨 User Experience
- ✨ Colored output (PowerShell)
- ✅ Input validation
- ⚠️ Error handling yang baik
- 📊 Model grouping by provider
- 🌐 Auto-open browser untuk model viewer
- 📁 Generate API reference file

### 🔧 Auto-Generation
- API key otomatis
- models.json (API response)
- models-data.js (untuk HTML viewer)
- API-REFERENCE.txt (quick reference)

## 🚀 Quick Start

### Instalasi Pertama Kali

```powershell
# 1. Buka PowerShell di folder project
cd D:\RioRaditya\Ngoding\CLIProxyAPIPlus

# 2. Jalankan setup
.\setup.ps1

# 3. Ikuti wizard:
#    - Pilih [1] untuk setup config
#    - Pilih [2-9] untuk login provider
#    - Pilih [10] untuk start server
```

### Daily Usage

```powershell
# Start server
.\start-server.ps1

# Test API (di terminal lain)
.\test-api.ps1 -OpenBrowser
```

## 📊 Comparison Table

| Feature | setup.ps1 | setup.bat | start-server | test-api |
|---------|-----------|-----------|--------------|----------|
| Interactive Menu | ✅ | ✅ | ❌ | ❌ |
| Config Setup | ✅ | ✅ | ❌ | ❌ |
| Provider Login | ✅ | ✅ | ❌ | ❌ |
| Start Server | ✅ | ✅ | ✅ | ❌ |
| Test API | ✅ | ✅ | ❌ | ✅ |
| Colored Output | ✅ | ❌ | ✅ | ✅ |
| Status Check | ✅ | ❌ | ❌ | ❌ |
| Config Editor | ✅ | ❌ | ❌ | ❌ |
| API Key Gen | ✅ | ❌ | ❌ | ❌ |

## 🎮 Usage Examples

### Example 1: Setup dari Nol

```powershell
PS> .\setup.ps1
# [1] Setup Config File
# [2] Login to Gemini CLI  
# [10] Start Server
```

### Example 2: Multi-Account Setup

```powershell
PS> .\setup.ps1
# [2] Login to Gemini CLI -> incognito: y (account 1)
# [2] Login to Gemini CLI -> incognito: y (account 2)
# [2] Login to Gemini CLI -> incognito: y (account 3)
# [10] Start Server
```

### Example 3: Testing & Debugging

```powershell
# Terminal 1: Start server dengan debug
PS> notepad config.yaml  # Set debug: true
PS> .\start-server.ps1

# Terminal 2: Test API
PS> .\test-api.ps1 -OpenBrowser

# Terminal 3: Monitor status
PS> .\setup.ps1  # Pilih [12] View Server Status
```

### Example 4: Quick Commands

```powershell
# Login only
.\cli-proxy-api.exe -login

# Start server langsung
.\start-server.ps1

# Test API langsung
.\test-api.ps1 -Port 8317 -ApiKey "sk-xxxxx" -OpenBrowser
```

## 📁 Generated Files

Setelah menjalankan scripts, file-file ini akan di-generate:

```
CLIProxyAPIPlus/
├── config.yaml              # Config utama (dari setup.ps1)
├── models.json              # API response models (dari test-api.ps1)
├── models-data.js           # Data untuk HTML viewer (dari test-api.ps1)
├── API-REFERENCE.txt        # Quick reference (dari test-api.ps1)
└── ~/.cli-proxy-api/        # Auth tokens
    ├── gemini/
    ├── codex/
    ├── claude/
    └── ...
```

## 🎯 Workflow Recommended

### Workflow 1: Development

```powershell
# Setup (sekali)
.\setup.ps1  # [1] Setup + [2-9] Login providers

# Daily dev
.\start-server.ps1               # Start server
.\test-api.ps1 -OpenBrowser      # Test & view models

# Code dengan API
# http://localhost:8317/v1/chat/completions
```

### Workflow 2: Production

```powershell
# Setup
.\setup.ps1  # [1] Setup config
# Edit config.yaml:
#   - host: "127.0.0.1"  # localhost only
#   - tls: enable
#   - debug: false

# Login providers
.\setup.ps1  # [2-9] Login

# Start with nohup/PM2/systemd
.\cli-proxy-api.exe -config config.yaml
```

## 🔐 Security Notes

### API Key
- ✅ Auto-generated dengan format `sk-{base64}`
- ⚠️ Jangan commit `config.yaml` ke Git
- 🔄 Rotate secara berkala
- 💾 Backup di secure location

### OAuth Tokens
- 📁 Disimpan di `~/.cli-proxy-api/`
- 🔒 File permissions: user only
- 🔄 Auto-refresh oleh aplikasi
- 🧹 Hapus token untuk logout: hapus folder provider

### Network
```yaml
# Development (semua IP)
host: ""

# Production (localhost only)
host: "127.0.0.1"

# Production with TLS
host: ""
tls:
  enable: true
  cert: "/path/to/cert.pem"
  key: "/path/to/key.pem"
```

## 🐛 Troubleshooting

### Script Tidak Jalan

**PowerShell Execution Policy**
```powershell
# Check current policy
Get-ExecutionPolicy

# Allow scripts (pilih salah satu)
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
Set-ExecutionPolicy Bypass -Scope Process

# Atau run dengan bypass
powershell -ExecutionPolicy Bypass -File .\setup.ps1
```

### Config Error

**Config not found**
```powershell
.\setup.ps1  # [1] Setup Config File
```

**Invalid config format**
```powershell
# Restore dari example
Copy-Item config.example.yaml config.yaml -Force
.\setup.ps1  # [1] Setup lagi
```

### API Error

**Connection refused**
```powershell
# Check server running
.\setup.ps1  # [12] View Server Status

# Restart server
Ctrl+C  # Stop server
.\start-server.ps1
```

**401 Unauthorized**
```powershell
# Check API key di config.yaml
Get-Content config.yaml | Select-String "api-keys" -Context 0,2

# Atau regenerate
.\setup.ps1  # [1] Setup Config (overwrite)
```

## 📚 Documentation Links

- **Quick Start:** `QUICK-START.md`
- **Full Guide:** `SETUP-GUIDE.md`
- **Demo:** `DEMO.md`
- **Main README:** `README.md`
- **Official Docs:** https://help.router-for.me/

## 🎓 Tips & Tricks

### Tip 1: Keyboard Shortcuts
```powershell
# Ctrl+C - Stop server
# Ctrl+Z - Suspend (PowerShell)
# Tab - Auto-complete path
```

### Tip 2: Aliases (PowerShell Profile)
```powershell
# Tambahkan ke profile: notepad $PROFILE
Set-Alias cpa-setup "D:\Path\To\setup.ps1"
Set-Alias cpa-start "D:\Path\To\start-server.ps1"
Set-Alias cpa-test "D:\Path\To\test-api.ps1"

# Usage:
cpa-setup
cpa-start
cpa-test -OpenBrowser
```

### Tip 3: Multiple Instances
```powershell
# Instance 1 (port 8317)
.\start-server.ps1 -ConfigFile config1.yaml

# Instance 2 (port 8318)  
.\start-server.ps1 -ConfigFile config2.yaml
```

### Tip 4: Log Monitoring
```powershell
# Enable logging di config.yaml
debug: true
logging-to-file: true

# Monitor logs
Get-Content -Wait -Tail 50 logs/app.log
```

## 🔄 Update & Maintenance

### Update Scripts
```powershell
# Pull latest dari Git
git pull origin main

# Atau download manual dari repo
```

### Backup Config
```powershell
# Backup config + auth
$date = Get-Date -Format "yyyyMMdd"
Copy-Item config.yaml "config.backup.$date.yaml"
Copy-Item -Recurse ~/.cli-proxy-api ~/.cli-proxy-api.backup.$date
```

### Clean Install
```powershell
# Remove config
Remove-Item config.yaml

# Remove auth
Remove-Item -Recurse ~/.cli-proxy-api

# Setup ulang
.\setup.ps1
```

## 🎉 Conclusion

Tools ini dibuat untuk mempermudah instalasi dan penggunaan CLI Proxy API Plus. 

**Rekomendasi:**
1. Gunakan `setup.ps1` untuk setup awal
2. Gunakan `start-server.ps1` untuk daily usage
3. Gunakan `test-api.ps1` untuk testing
4. Baca `SETUP-GUIDE.md` untuk dokumentasi lengkap

**Quick Commands:**
```powershell
.\setup.ps1              # Setup everything
.\start-server.ps1       # Start server
.\test-api.ps1           # Test API
```

Happy coding! 🚀

---

**Created by:** Droid (Factory AI Assistant)  
**Date:** December 9, 2025  
**Version:** 1.0  
**License:** Same as main project (MIT)
