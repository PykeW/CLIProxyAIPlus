# CLI Proxy API Plus - Setup Guide

Panduan lengkap untuk instalasi dan konfigurasi CLI Proxy API Plus dengan script helper yang mudah digunakan.

## 📋 Daftar Isi

- [Persyaratan](#persyaratan)
- [Quick Start](#quick-start)
- [Script Helper](#script-helper)
- [Provider Login](#provider-login)
- [Testing API](#testing-api)
- [Troubleshooting](#troubleshooting)

## 🔧 Persyaratan

- Windows 10/11 (untuk script .bat dan .ps1)
- File `cli-proxy-api.exe` (sudah tersedia di folder ini)
- Browser (untuk OAuth login)
- curl atau PowerShell (untuk testing API)

## 🚀 Quick Start

### Cara Termudah (PowerShell - RECOMMENDED)

1. **Jalankan Setup Script:**
   ```powershell
   .\setup.ps1
   ```

2. **Pilih Menu:**
   - Pilih `[1]` untuk setup config (otomatis generate API key)
   - Pilih provider yang ingin Anda gunakan (misal `[2]` untuk Gemini)
   - Pilih `[10]` untuk start server

3. **Test API:**
   - Pilih `[11]` untuk test API dan list models
   - Models akan ditampilkan di terminal dan browser

### Cara Alternatif (Command Prompt)

1. **Jalankan Setup Script:**
   ```cmd
   setup.bat
   ```

2. **Ikuti Menu Interaktif:**
   - Sama seperti PowerShell versi

## 📁 Script Helper

### 1. **setup.ps1** (PowerShell - RECOMMENDED)
Script interaktif lengkap dengan fitur:
- ✅ Auto-generate API key
- ✅ Colored output
- ✅ Config validation
- ✅ Server status checker
- ✅ Integrated model viewer
- ✅ Quick config editor

**Cara Pakai:**
```powershell
.\setup.ps1
```

**Fitur Menu:**
```
[1]  Setup Config File          - Buat config.yaml dengan API key otomatis
[2]  Login to Gemini CLI        - Login ke Google Gemini
[3]  Login to OpenAI Codex      - Login ke ChatGPT Codex
[4]  Login to Claude Code       - Login ke Claude
[5]  Login to GitHub Copilot    - Login ke GitHub Copilot
[6]  Login to Qwen              - Login ke Qwen
[7]  Login to iFlow             - Login ke iFlow
[8]  Login to Kiro              - Login ke Kiro (AWS CodeWhisperer)
[9]  Login to Antigravity       - Login ke Antigravity
[10] Start Server               - Jalankan server
[11] Test API & List Models     - Test dan list semua models
[12] View Server Status         - Cek status server
[13] Edit Config File           - Edit config.yaml
[0]  Exit                       - Keluar
```

### 2. **setup.bat** (Command Prompt)
Script untuk pengguna yang lebih suka Command Prompt.

**Cara Pakai:**
```cmd
setup.bat
```

### 3. **start-server.ps1** / **start-server.bat**
Script untuk quick start server tanpa menu.

**PowerShell:**
```powershell
.\start-server.ps1
```

**Command Prompt:**
```cmd
start-server.bat
```

### 4. **test-api.ps1**
Script untuk test API dan generate model viewer.

**Cara Pakai:**
```powershell
# Otomatis baca dari config.yaml
.\test-api.ps1

# Custom port dan API key
.\test-api.ps1 -Port 8317 -ApiKey "your-key"

# Langsung buka browser
.\test-api.ps1 -OpenBrowser
```

**Output:**
- `models.json` - Data models dalam format JSON
- `models-data.js` - Data untuk HTML viewer
- `API-REFERENCE.txt` - Quick reference untuk API

## 🔐 Provider Login

### Gemini CLI (Google)
```powershell
.\cli-proxy-api.exe -login
```

### OpenAI Codex
```powershell
.\cli-proxy-api.exe -codex-login
```

### Claude Code
```powershell
.\cli-proxy-api.exe -claude-login
```

### GitHub Copilot
```powershell
.\cli-proxy-api.exe -github-copilot-login
```

### Qwen
```powershell
.\cli-proxy-api.exe -qwen-login
```

### iFlow
```powershell
.\cli-proxy-api.exe -iflow-login
```

### Kiro (AWS CodeWhisperer)
```powershell
# Google OAuth
.\cli-proxy-api.exe -kiro-login

# AWS Builder ID
.\cli-proxy-api.exe -kiro-aws-login

# Import dari Kiro IDE
.\cli-proxy-api.exe -kiro-import
```

### Antigravity
```powershell
.\cli-proxy-api.exe -antigravity-login
```

### 🎭 Multi-Account Support

Untuk login dengan multiple accounts, gunakan flag `-incognito`:

```powershell
.\cli-proxy-api.exe -login -incognito
.\cli-proxy-api.exe -codex-login -incognito
```

## 🧪 Testing API

### Cara 1: Menggunakan Script (RECOMMENDED)
```powershell
.\test-api.ps1
```

### Cara 2: Menggunakan cURL
```bash
# List models
curl http://localhost:8317/v1/models \
  -H "Authorization: Bearer your-api-key"

# Chat completion
curl http://localhost:8317/v1/chat/completions \
  -H "Authorization: Bearer your-api-key" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gemini-2.0-flash-exp",
    "messages": [{"role": "user", "content": "Hello!"}]
  }'
```

### Cara 3: Menggunakan PowerShell
```powershell
$headers = @{
    "Authorization" = "Bearer your-api-key"
}

# List models
Invoke-RestMethod -Uri "http://localhost:8317/v1/models" -Headers $headers

# Chat completion
$body = @{
    model = "gemini-2.0-flash-exp"
    messages = @(
        @{
            role = "user"
            content = "Hello!"
        }
    )
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:8317/v1/chat/completions" `
    -Headers $headers `
    -Method Post `
    -Body $body `
    -ContentType "application/json"
```

## 📊 Model Viewer

File `models (2).html` adalah viewer interaktif untuk melihat semua models yang tersedia.

**Cara Membuka:**

1. Otomatis dari script:
   ```powershell
   .\test-api.ps1 -OpenBrowser
   ```

2. Manual:
   - Double click `models (2).html`
   - Atau: `start "models (2).html"` di Command Prompt

**Data Models:**
- Models akan di-load otomatis dari `models-data.js`
- File ini di-generate oleh script `test-api.ps1`

## 🔧 Konfigurasi

### File Config: `config.yaml`

Struktur dasar:
```yaml
host: ""                    # Kosong = all interfaces, "127.0.0.1" = localhost only
port: 8317                  # Port server

api-keys:
  - "sk-generated-key-xxx"  # API key untuk autentikasi

debug: false                # Enable debug logging
incognito-browser: true     # Use incognito untuk OAuth

# Provider configurations
# gemini-api-key:
# codex-api-key:
# claude-api-key:
# ...
```

### Edit Config

**Menggunakan Script:**
```powershell
.\setup.ps1
# Pilih menu [13] Edit Config File
```

**Manual:**
```powershell
notepad config.yaml
```

## 🐛 Troubleshooting

### Server Tidak Bisa Start

**Problem:** `config.yaml not found`
**Solution:**
```powershell
.\setup.ps1
# Pilih menu [1] untuk setup config
```

---

**Problem:** Port sudah digunakan
**Solution:**
```yaml
# Edit config.yaml, ubah port
port: 8318  # atau port lain yang available
```

### Login Gagal

**Problem:** Browser tidak terbuka
**Solution:**
```powershell
# Gunakan -no-browser dan ikuti URL manual
.\cli-proxy-api.exe -login -no-browser
```

---

**Problem:** Perlu multi-account
**Solution:**
```powershell
# Login dengan incognito mode
.\cli-proxy-api.exe -login -incognito
```

### API Test Gagal

**Problem:** Connection refused
**Solution:**
- Pastikan server sudah running
- Cek server status: pilih menu `[12]` di `setup.ps1`

---

**Problem:** Unauthorized (401)
**Solution:**
- Pastikan API key benar
- Cek `config.yaml` untuk API key yang valid

### Models Tidak Muncul

**Problem:** No models found
**Solution:**
- Pastikan sudah login ke minimal 1 provider
- Cek auth files di `~/.cli-proxy-api/`
- Re-login: `.\cli-proxy-api.exe -login`

## 📝 Tips & Best Practices

### 1. **Gunakan PowerShell Script**
Script PowerShell lebih feature-rich dengan colored output dan validasi yang lebih baik.

### 2. **Multi-Account Setup**
Untuk multiple accounts dari provider yang sama:
```powershell
# Account 1
.\cli-proxy-api.exe -login

# Account 2 (dengan incognito)
.\cli-proxy-api.exe -login -incognito

# Account 3 (dengan incognito)
.\cli-proxy-api.exe -login -incognito
```

### 3. **API Key Security**
- Jangan commit `config.yaml` ke Git
- Gunakan environment variable untuk production
- Rotate API key secara berkala

### 4. **Testing Development**
Untuk development, aktifkan debug mode:
```yaml
debug: true
logging-to-file: true  # Logs ke file
```

### 5. **Production Setup**
Untuk production:
```yaml
host: "127.0.0.1"  # Localhost only
tls:
  enable: true
  cert: "/path/to/cert.pem"
  key: "/path/to/key.pem"
```

## 🔗 Links & Resources

- **GitHub Repo:** https://github.com/router-for-me/CLIProxyAPI
- **Documentation:** https://help.router-for.me/
- **Management API:** Lihat `MANAGEMENT_API.md`

## 📞 Support

Jika mengalami masalah:

1. Cek troubleshooting guide di atas
2. Lihat logs dengan `debug: true` di config
3. Buka issue di GitHub repo
4. Join community di Discord/Telegram (jika ada)

## 🎉 Selesai!

Anda sudah siap menggunakan CLI Proxy API Plus!

**Quick Recap:**
```powershell
# 1. Setup
.\setup.ps1  # Pilih [1] untuk setup config

# 2. Login
.\setup.ps1  # Pilih [2-9] untuk login ke provider

# 3. Start Server
.\start-server.ps1

# 4. Test
.\test-api.ps1 -OpenBrowser
```

Selamat coding! 🚀
