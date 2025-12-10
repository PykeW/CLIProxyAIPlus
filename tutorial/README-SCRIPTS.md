# 📚 CLI Proxy API Plus - Scripts Documentation

Panduan lengkap untuk semua helper scripts yang tersedia.

## 📋 Table of Contents

- [Quick Start](#-quick-start)
- [Available Scripts](#-available-scripts)
- [Common Issues](#-common-issues)
- [Update Guide](#-update-guide)
- [Documentation Files](#-documentation-files)

---

## 🚀 Quick Start

### Untuk User Baru (First Time Setup)

```powershell
# 1. Setup & Login
.\setup.ps1
   # Pilih [1] Setup Config
   # Pilih [2] Login to Gemini

# 2. Start Server  
.\start-server.ps1

# 3. Test
.\test-api.ps1 -OpenBrowser
```

### Untuk Daily Usage

```powershell
# Start server
.\start-server.ps1

# Test API (optional)
.\test-api.ps1
```

---

## 📁 Available Scripts

### 🎯 Main Scripts

#### 1. `setup.ps1` ⭐ RECOMMENDED
**Menu interaktif lengkap untuk setup dan management**

```powershell
.\setup.ps1
```

**Features:**
- ✅ Setup config dengan auto-generate API key
- ✅ Login ke berbagai providers
- ✅ Start server
- ✅ Test API & list models
- ✅ Server status checker
- ✅ Config editor
- ✅ Colored output

**Menu Options:**
```
[1]  Setup Config File          [8]  Login to Kiro
[2]  Login to Gemini CLI        [9]  Login to Antigravity  
[3]  Login to OpenAI Codex      [10] Start Server
[4]  Login to Claude Code       [11] Test API & List Models
[5]  Login to GitHub Copilot    [12] View Server Status
[6]  Login to Qwen              [13] Edit Config File
[7]  Login to iFlow             [0]  Exit
```

---

#### 2. `setup.bat`
**Command Prompt version dari setup.ps1**

```cmd
setup.bat
```

**Features:**
- ✅ Menu interaktif untuk CMD users
- ✅ Semua fitur penting tersedia
- ❌ Tidak ada colored output

---

#### 3. `start-server.ps1`
**Quick start server tanpa menu**

```powershell
.\start-server.ps1

# Atau dengan custom config
.\start-server.ps1 -ConfigFile "config.custom.yaml"
```

**Features:**
- ✅ Quick start tanpa menu
- ✅ Menampilkan port dan API key
- ✅ Auto-detect config

---

#### 4. `start-server.bat`
**Command Prompt version**

```cmd
start-server.bat
```

---

#### 5. `test-api.ps1`
**Test API endpoints dan generate model viewer**

```powershell
# Auto-detect dari config
.\test-api.ps1

# Custom parameters
.\test-api.ps1 -Port 8317 -ApiKey "sk-xxxxx"

# Auto-open browser
.\test-api.ps1 -OpenBrowser
```

**Features:**
- ✅ Test `/v1/models` endpoint
- ✅ Test `/v1/chat/completions` endpoint
- ✅ Group models by provider
- ✅ Generate `models.json`
- ✅ Generate `models-data.js` untuk HTML viewer
- ✅ Generate `API-REFERENCE.txt`
- ✅ Auto-open browser

**Generated Files:**
- `models.json` - API response
- `models-data.js` - Data untuk HTML viewer
- `API-REFERENCE.txt` - Quick reference

---

### 🔧 Utility Scripts

#### 6. `check-status.ps1`
**Comprehensive system status checker**

```powershell
.\check-status.ps1
```

**Checks:**
- ✅ Config file existence and validity
- ✅ API key configuration
- ✅ Auth files and provider accounts
- ✅ Server process status
- ✅ Network/port accessibility
- ✅ API endpoint connectivity
- ✅ Models availability

**Exit Codes:**
- `0` - All checks passed
- `1` - Issues found

---

#### 7. `update.ps1`
**Auto-update script untuk git repositories**

```powershell
# Update dengan backup otomatis
.\update.ps1

# Update tanpa backup
.\update.ps1 -SkipBackup

# Force update tanpa konfirmasi
.\update.ps1 -Force
```

**Features:**
- ✅ Auto backup config dan auth
- ✅ Check for uncommitted changes
- ✅ Show new commits
- ✅ Auto-restore config after update
- ✅ Server restart option

---

## 🎯 Common Issues

### Issue 1: "Total Models: 0" 🔴

**Symptom:**
```
• Total Models: 0
• Providers: 0
• CONNECTION FAILED di browser
```

**Solution:**
```powershell
# 1. Login ke provider
.\cli-proxy-api.exe -login

# 2. Restart server
# Ctrl+C untuk stop, lalu:
.\start-server.ps1

# 3. Test lagi
.\test-api.ps1 -OpenBrowser
```

**Root Cause:** Belum login ke provider manapun.

---

### Issue 2: 401 Unauthorized

**Symptom:**
```
[warning] [gin_logger.go:62] [GIN] 2025/12/09 - 20:22:48 | 401
```

**Solution:**
```powershell
# Check API key
Get-Content config.yaml | Select-String "api-keys" -Context 0,2

# Test dengan key yang benar
.\test-api.ps1
```

---

### Issue 3: Connection Refused

**Symptom:**
Browser atau curl tidak bisa connect ke `http://localhost:8317`

**Solution:**
```powershell
# Check status
.\check-status.ps1

# Start server jika belum running
.\start-server.ps1
```

---

### Issue 4: Port Already in Use

**Symptom:**
```
[ERROR] Failed to start: address already in use
```

**Solution:**
```powershell
# Edit config.yaml
notepad config.yaml
# Ubah: port: 8318

# Atau kill process yang pakai port
Get-Process -Name "cli-proxy-api" | Stop-Process -Force
```

---

## 🔄 Update Guide

### Method 1: Git Clone (Recommended)

```powershell
# Auto update dengan backup
.\update.ps1

# Update akan:
# ✅ Backup config.yaml
# ✅ Backup auth tokens
# ✅ Pull latest dari git
# ✅ Restore config
# ✅ Offer server restart
```

### Method 2: Manual Download

```powershell
# 1. Backup
Copy-Item config.yaml config.backup.yaml
Copy-Item -Recurse ~/.cli-proxy-api ~/.cli-proxy-api.backup

# 2. Download dari:
# https://github.com/router-for-me/CLIProxyAPI/releases

# 3. Extract dan replace files

# 4. Restore
Copy-Item config.backup.yaml config.yaml
# Auth di ~/.cli-proxy-api tetap ada

# 5. Restart
.\start-server.ps1
```

### Check for Updates

```powershell
# Jika git clone
git fetch origin main
git status

# Jika ada update tersedia:
.\update.ps1
```

---

## 📚 Documentation Files

### Quick References

| File | Description | Use Case |
|------|-------------|----------|
| `QUICK-START.md` | 3-step quick start | First time users |
| `QUICK-FIX.md` | Fix common errors | Troubleshooting |
| `API-REFERENCE.txt` | API endpoints & examples | Generated after test |

### Full Guides

| File | Description | Use Case |
|------|-------------|----------|
| `SETUP-GUIDE.md` | Complete setup guide | Detailed setup |
| `TROUBLESHOOTING.md` | Comprehensive troubleshooting | Complex issues |
| `DEMO.md` | Usage examples with output | Learning |
| `README-SETUP-TOOLS.md` | Scripts overview | Understanding tools |
| `README-SCRIPTS.md` | This file | Quick reference |

### Original Documentation

| File | Description |
|------|-------------|
| `README.md` | Main project README |
| `README_CN.md` | Chinese version |
| `docs/` | Official documentation |

---

## 🎓 Best Practices

### 1. Setup Workflow

```powershell
# Day 1: Initial Setup
.\setup.ps1
# [1] Setup Config
# [2] Login Gemini
# [3] Login Codex (optional)
# [10] Start Server

# Day 2+: Daily Usage
.\start-server.ps1
```

### 2. Multi-Account Setup

```powershell
# Account 1
.\cli-proxy-api.exe -login

# Account 2 (incognito)
.\cli-proxy-api.exe -login -incognito

# Account 3 (incognito)
.\cli-proxy-api.exe -login -incognito

# Models dari semua accounts akan available
```

### 3. Maintenance

```powershell
# Weekly: Check status
.\check-status.ps1

# Monthly: Update
.\update.ps1

# As needed: Re-login
.\cli-proxy-api.exe -login
```

### 4. Troubleshooting Flow

```powershell
# 1. Check status
.\check-status.ps1

# 2. If issues, follow recommendations

# 3. Test API
.\test-api.ps1

# 4. If still failing, check logs
# Set debug: true in config.yaml
```

---

## 💡 Tips & Tricks

### Tip 1: PowerShell Aliases

Add to your PowerShell profile (`notepad $PROFILE`):

```powershell
# Add these lines
$cpaRoot = "D:\RioRaditya\Ngoding\CLIProxyAPIPlus"

function cpa-setup { & "$cpaRoot\setup.ps1" }
function cpa-start { & "$cpaRoot\start-server.ps1" }
function cpa-test { & "$cpaRoot\test-api.ps1" -OpenBrowser }
function cpa-status { & "$cpaRoot\check-status.ps1" }
function cpa-update { & "$cpaRoot\update.ps1" }

# Usage:
# cpa-setup
# cpa-start
# cpa-test
```

### Tip 2: Quick Commands Cheat Sheet

```powershell
# Setup
.\setup.ps1

# Login
.\cli-proxy-api.exe -login -incognito

# Start
.\start-server.ps1

# Test
.\test-api.ps1 -OpenBrowser

# Status
.\check-status.ps1

# Update
.\update.ps1
```

### Tip 3: Monitoring

```powershell
# Enable logging
# Edit config.yaml:
debug: true
logging-to-file: true

# View logs
Get-Content -Wait -Tail 50 logs/app.log
```

### Tip 4: Multiple Instances

```powershell
# Instance 1 (port 8317)
.\start-server.ps1 -ConfigFile config1.yaml

# Instance 2 (port 8318)
.\start-server.ps1 -ConfigFile config2.yaml
```

---

## 🔗 Quick Links

- **GitHub:** https://github.com/router-for-me/CLIProxyAPI
- **Docs:** https://help.router-for.me/
- **Releases:** https://github.com/router-for-me/CLIProxyAPI/releases
- **Issues:** https://github.com/router-for-me/CLIProxyAPI/issues

---

## 📞 Support

### Quick Help

1. Read `QUICK-FIX.md` for common issues
2. Run `.\check-status.ps1` for diagnosis
3. Check `TROUBLESHOOTING.md` for detailed solutions

### Getting Help

1. **Check existing issues:** https://github.com/router-for-me/CLIProxyAPI/issues
2. **Open new issue** with:
   - Output dari `.\check-status.ps1`
   - Error messages
   - Steps to reproduce
3. **Enable debug mode** and attach logs

---

## 🎉 Summary

**Quick Start (3 Commands):**
```powershell
.\setup.ps1              # Setup & login
.\start-server.ps1       # Start server
.\test-api.ps1           # Test & view models
```

**Daily Usage:**
```powershell
.\start-server.ps1       # Just this!
```

**Maintenance:**
```powershell
.\check-status.ps1       # Check health
.\update.ps1             # Update repo
```

Happy coding! 🚀
