# ⚡ QUICK FIX - "Total Models: 0" Error

## 🔴 Problem Anda
Dari screenshot, masalahnya adalah:
```
• Total Models: 0
• Providers: 0
• CONNECTION FAILED di browser
```

## ✅ Solusi (3 Langkah Sederhana)

### Langkah 1: Login ke Provider (WAJIB!)
Server butuh minimal 1 provider untuk kerja. Pilih yang termudah:

```powershell
# Login ke Gemini (RECOMMENDED - paling mudah)
.\cli-proxy-api.exe -login
```

**Browser akan buka otomatis**, ikuti petunjuk login Google.

### Langkah 2: Restart Server

Stop server yang sedang jalan (tekan `Ctrl+C`), lalu start lagi:

```powershell
.\start-server.ps1
```

### Langkah 3: Test Lagi

```powershell
.\test-api.ps1 -OpenBrowser
```

Sekarang harusnya muncul models! 🎉

---

## 📊 Verifikasi

Jalankan check status:
```powershell
.\check-status.ps1
```

Output yang benar:
```
✅ Config file exists
✅ API key configured
✅ Auth files exist
✅ gemini: 1 account(s)
✅ Server running
✅ API responding correctly
ℹ️  Total models: 12
   ✅ gemini: 12 model(s)
```

---

## 🎯 Provider Options

Pilih salah satu provider untuk login:

| Provider | Command | Keterangan |
|----------|---------|------------|
| **Gemini** | `.\cli-proxy-api.exe -login` | ⭐ RECOMMENDED |
| Codex | `.\cli-proxy-api.exe -codex-login` | Perlu ChatGPT account |
| Claude | `.\cli-proxy-api.exe -claude-login` | Perlu Claude account |
| GitHub Copilot | `.\cli-proxy-api.exe -github-copilot-login` | Perlu Copilot sub |

---

## 🔄 Cara Update Repository

### Jika Clone dari Git:

```powershell
# 1. Run update script (auto backup)
.\update.ps1

# 2. Restart server
.\start-server.ps1
```

### Jika Download Manual:

```powershell
# 1. Backup config
Copy-Item config.yaml config.backup.yaml

# 2. Download release baru:
# https://github.com/router-for-me/CLIProxyAPI/releases

# 3. Extract dan replace files

# 4. Restore config
Copy-Item config.backup.yaml config.yaml

# 5. Restart
.\start-server.ps1
```

**Note:** Auth tokens di `~/.cli-proxy-api/` akan tetap ada, tidak perlu login ulang.

---

## 📱 Check for Updates

```powershell
# Check jika ada update
git fetch origin main
git status

# Jika ada update
.\update.ps1
```

---

## 🆘 Still Having Issues?

### Issue 1: Browser tidak buka saat login
```powershell
# Pakai flag -no-browser
.\cli-proxy-api.exe -login -no-browser
# Copy URL yang muncul ke browser manual
```

### Issue 2: API Key error
```powershell
# Check API key di config
Get-Content config.yaml | Select-String "api-keys" -Context 0,2

# Atau regenerate
.\setup.ps1  # Pilih [1] Setup Config
```

### Issue 3: Port sudah digunakan
```powershell
# Edit config.yaml, ubah port
port: 8318  # ganti ke port lain
```

### Issue 4: Complete reset
```powershell
# Stop server (Ctrl+C)

# Clean
Remove-Item config.yaml
Remove-Item -Recurse ~/.cli-proxy-api

# Setup ulang
.\setup.ps1
```

---

## 💡 Pro Tips

### Tip 1: Multi-Account
Untuk tambah account kedua/ketiga dari provider yang sama:
```powershell
.\cli-proxy-api.exe -login -incognito
```

### Tip 2: Check Status Cepat
```powershell
.\check-status.ps1
```

### Tip 3: View Models List
Setelah server running:
```powershell
.\test-api.ps1
```
Akan generate `models.json` dan buka `models (2).html` di browser.

---

## 🎬 Complete Flow

```powershell
# 1. Check status
.\check-status.ps1

# 2. Login provider (jika belum)
.\cli-proxy-api.exe -login

# 3. Start server
.\start-server.ps1

# 4. Test (di terminal baru)
.\test-api.ps1 -OpenBrowser

# 5. Enjoy! 🎉
```

---

## 📞 Need More Help?

- Full Guide: `SETUP-GUIDE.md`
- Troubleshooting: `TROUBLESHOOTING.md`
- Demo: `DEMO.md`
- GitHub Issues: https://github.com/router-for-me/CLIProxyAPI/issues
