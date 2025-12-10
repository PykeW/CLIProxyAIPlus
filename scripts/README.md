# 🔧 Scripts Folder - Alternative & Utility Scripts

Folder ini berisi script alternatif dan utility tools.

---

## 📁 Available Scripts

### 🎯 Alternative Scripts

| Script | Fungsi | Kapan Digunakan |
|--------|--------|-----------------|
| **`setup.bat`** | Setup menu (CMD version) | User yang prefer Command Prompt |
| **`start-server.bat`** | Start server (CMD version) | User yang prefer Command Prompt |

### 🔧 Utility Scripts

| Script | Fungsi | Kapan Digunakan |
|--------|--------|-----------------|
| **`check-status.ps1`** | System diagnostic tool | Troubleshooting / health check |
| **`update.ps1`** | Auto-update dari Git | Update repository dengan backup |

---

## 🚀 Usage

### Check Status
```powershell
# Dari root folder
.\scripts\check-status.ps1
```

**Output:**
- ✅ Config file check
- ✅ Auth files check
- ✅ Server process check
- ✅ Network/port check
- ✅ API connectivity test
- ✅ Models availability

### Update Repository
```powershell
# Dari root folder
.\scripts\update.ps1

# Options:
.\scripts\update.ps1 -SkipBackup    # Skip backup
.\scripts\update.ps1 -Force         # Force update tanpa konfirmasi
```

**Features:**
- Auto backup config.yaml
- Auto backup auth tokens
- Show new commits sebelum update
- Auto-restore config setelah update
- Optional server restart

### Command Prompt Users
```cmd
REM Setup
scripts\setup.bat

REM Start server
scripts\start-server.bat
```

---

## 💡 Tips

### Tip 1: Add to PATH
Untuk akses lebih mudah, tambahkan folder ini ke PATH, atau buat alias.

**PowerShell Profile:**
```powershell
# Edit profile
notepad $PROFILE

# Add these lines
$cpaRoot = "D:\RioRaditya\Ngoding\CLIProxyAPIPlus"
function cpa-status { & "$cpaRoot\scripts\check-status.ps1" }
function cpa-update { & "$cpaRoot\scripts\update.ps1" }

# Usage anywhere:
cpa-status
cpa-update
```

### Tip 2: Regular Checks
Jalankan check-status secara berkala:
```powershell
# Weekly check
.\scripts\check-status.ps1
```

### Tip 3: Before Important Changes
Selalu check status sebelum update atau config changes:
```powershell
.\scripts\check-status.ps1
# Jika semua ✅, proceed
.\scripts\update.ps1
```

---

## 🔗 Main Scripts

Script utama tetap ada di **root folder**:
- `setup.ps1` - Main setup menu
- `start-server.ps1` - Start server
- `test-api.ps1` - Test API

---

## 📚 Documentation

Dokumentasi lengkap ada di **folder `tutorial/`**:
- Quick Start
- Setup Guide
- Troubleshooting
- Dan lainnya

---

Kembali ke: **`../README-ID.md`**
