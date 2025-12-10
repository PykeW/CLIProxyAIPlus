# 🚀 CLI Proxy API Plus - Quick Start

Panduan super cepat untuk mulai menggunakan CLI Proxy API Plus dalam 3 langkah!

## ⚡ 3 Langkah Setup

### 1️⃣ Setup Config
```powershell
.\setup.ps1
# Pilih [1] Setup Config File
```
✅ Config file akan dibuat otomatis dengan API key

### 2️⃣ Login Provider
```powershell
# Di menu setup.ps1, pilih provider:
[2] Gemini CLI
[3] OpenAI Codex
[4] Claude Code
[5] GitHub Copilot
# dst...
```
✅ Browser akan terbuka untuk OAuth login

### 3️⃣ Start Server
```powershell
.\start-server.ps1
```
✅ Server running di `http://localhost:8317`

## 🧪 Test API

```powershell
.\test-api.ps1 -OpenBrowser
```

Atau manual dengan curl:
```bash
curl http://localhost:8317/v1/models -H "Authorization: Bearer YOUR-API-KEY"
```

## 📁 Script Files

| Script | Deskripsi |
|--------|-----------|
| `setup.ps1` | Menu interaktif lengkap (RECOMMENDED) |
| `setup.bat` | Menu untuk Command Prompt |
| `start-server.ps1` | Quick start server |
| `start-server.bat` | Quick start (CMD) |
| `test-api.ps1` | Test API dan list models |

## 🎯 Common Tasks

### Multi-Account Login
```powershell
.\cli-proxy-api.exe -login -incognito
```

### View Models
```powershell
.\test-api.ps1 -OpenBrowser
# Buka file: models (2).html
```

### Edit Config
```powershell
notepad config.yaml
```

### Check Server Status
```powershell
.\setup.ps1
# Pilih [12] View Server Status
```

## 🔑 API Key

API key otomatis di-generate saat setup. Cek di:
```powershell
# Lihat di config.yaml
Get-Content config.yaml | Select-String "api-keys" -Context 0,2
```

## 📊 Endpoints

- **Models:** `GET http://localhost:8317/v1/models`
- **Chat:** `POST http://localhost:8317/v1/chat/completions`
- **Completions:** `POST http://localhost:8317/v1/completions`

## 🆘 Troubleshooting

| Problem | Solution |
|---------|----------|
| Config not found | Jalankan `setup.ps1` pilih `[1]` |
| Port in use | Edit `config.yaml` ubah `port:` |
| Login failed | Tambahkan flag `-incognito` |
| No models | Login dulu ke provider |

## 📖 Full Documentation

Lihat `SETUP-GUIDE.md` untuk dokumentasi lengkap.

## 🎉 That's It!

Sekarang Anda bisa mulai menggunakan AI models via API!

```powershell
# Quick Example
curl http://localhost:8317/v1/chat/completions \
  -H "Authorization: Bearer YOUR-KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gemini-2.0-flash-exp",
    "messages": [{"role": "user", "content": "Hello AI!"}]
  }'
```

Happy coding! 🚀
