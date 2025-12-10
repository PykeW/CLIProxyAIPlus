# 🎬 CLI Proxy API Plus - Demo Penggunaan

## 🎯 Demo 1: Setup Pertama Kali

```powershell
# Step 1: Jalankan setup script
PS> .\setup.ps1

# Output:
╔══════════════════════════════════════════════════════════╗
║     CLI PROXY API - SETUP MANAGER (PowerShell)           ║
╚══════════════════════════════════════════════════════════╝

  [1]  Setup Config File
  [2]  Login to Gemini CLI
  ...

# Step 2: Pilih [1] untuk setup config
Pilih menu (0-13): 1

[INFO] Setting up config file...
[INFO] Generating random API key...
[SUCCESS] Generated API Key: sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
[INFO] Please save this API key! It's stored in config.yaml

Customize settings now? (y/n): n
[SUCCESS] Configuration completed!

# Step 3: Pilih [2] untuk login ke Gemini
Pilih menu (0-13): 2

[INFO] Logging in to Gemini CLI...
Use incognito/private mode? (y/n): n

# Browser akan terbuka untuk OAuth login
# Setelah selesai:
[SUCCESS] Login completed!

# Step 4: Pilih [10] untuk start server
Pilih menu (0-13): 10

[INFO] Starting CLI Proxy API Server...
[INFO] Server will start on port: 8317
[INFO] API endpoint: http://localhost:8317
[INFO] Press Ctrl+C to stop the server

Server berjalan...
```

## 🧪 Demo 2: Test API

Buka PowerShell baru (server tetap jalan di PowerShell pertama):

```powershell
# Test API dan list models
PS> .\test-api.ps1

╔══════════════════════════════════════════════════════════╗
║     CLI PROXY API - API TESTER                           ║
╚══════════════════════════════════════════════════════════╝

[INFO] Port from config: 8317
[INFO] API Key from config: sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
[INFO] Testing API at: http://localhost:8317

========================================
Test 1: Fetching Models
========================================
GET http://localhost:8317/v1/models
[SUCCESS] API is working!
[INFO] Response saved to models.json

Available Models (25):

  [gemini]
    • gemini-2.0-flash-exp
    • gemini-2.0-flash-thinking-exp-01-21
    • gemini-1.5-pro-latest
    • gemini-1.5-flash-latest

  [codex]
    • gpt-5-codex
    • gpt-5-medium
    • gpt-5-low

  [claude]
    • claude-3-5-sonnet-20241022
    • claude-3-opus-20240229

========================================
Test 2: Testing Endpoints
========================================
POST http://localhost:8317/v1/chat/completions
  [✓] /v1/chat/completions - OK
GET http://localhost:8317/v1/models
  [✓] /v1/models - OK

========================================
Generating Model Viewer
========================================
[INFO] Model data saved to models-data.js

Open model viewer in browser? (y/n): y
[INFO] Opening model viewer in browser...

========================================
Summary
========================================
  • API Endpoint: http://localhost:8317
  • Total Models: 25
  • Providers: 3
  • Status: Ready

[INFO] Quick reference saved to API-REFERENCE.txt
```

## 🎨 Demo 3: Model Viewer

File `models (2).html` akan terbuka di browser dengan tampilan:

```
╔═══════════════════════════════════════════════════════════╗
║              MODEL REGISTRY // TERMINAL                   ║
╚═══════════════════════════════════════════════════════════╝

🔍 Search models...

📊 AVAILABLE MODELS (25)

┌─────────────────────────────────────────────────────────┐
│ GEMINI MODELS (12)                                       │
├─────────────────────────────────────────────────────────┤
│ • gemini-2.0-flash-exp                                   │
│ • gemini-2.0-flash-thinking-exp-01-21                    │
│ • gemini-1.5-pro-latest                                  │
│ ...                                                      │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│ CODEX MODELS (8)                                         │
├─────────────────────────────────────────────────────────┤
│ • gpt-5-codex                                            │
│ • gpt-5-medium                                           │
│ ...                                                      │
└─────────────────────────────────────────────────────────┘
```

## 🔄 Demo 4: Multi-Account Login

```powershell
PS> .\setup.ps1

# Pilih [2] Login to Gemini CLI
Pilih menu (0-13): 2

[INFO] Logging in to Gemini CLI...
Use incognito/private mode? (y/n): y

# Browser akan buka dalam incognito mode
# Login dengan account kedua
[SUCCESS] Login completed!

# Ulangi untuk account ketiga, keempat, dst...
```

## 📱 Demo 5: Menggunakan API dari Aplikasi

### Python
```python
import requests

API_KEY = "sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
BASE_URL = "http://localhost:8317"

headers = {
    "Authorization": f"Bearer {API_KEY}",
    "Content-Type": "application/json"
}

# List models
response = requests.get(f"{BASE_URL}/v1/models", headers=headers)
models = response.json()
print(f"Available models: {len(models['data'])}")

# Chat completion
data = {
    "model": "gemini-2.0-flash-exp",
    "messages": [
        {"role": "user", "content": "Hello! What can you do?"}
    ]
}

response = requests.post(
    f"{BASE_URL}/v1/chat/completions", 
    headers=headers, 
    json=data
)
print(response.json()['choices'][0]['message']['content'])
```

### JavaScript (Node.js)
```javascript
const axios = require('axios');

const API_KEY = 'sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx';
const BASE_URL = 'http://localhost:8317';

async function chat(message) {
    const response = await axios.post(
        `${BASE_URL}/v1/chat/completions`,
        {
            model: 'gemini-2.0-flash-exp',
            messages: [{ role: 'user', content: message }]
        },
        {
            headers: {
                'Authorization': `Bearer ${API_KEY}`,
                'Content-Type': 'application/json'
            }
        }
    );
    return response.data.choices[0].message.content;
}

chat('Hello AI!').then(console.log);
```

### cURL
```bash
# List models
curl http://localhost:8317/v1/models \
  -H "Authorization: Bearer sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

# Chat
curl http://localhost:8317/v1/chat/completions \
  -H "Authorization: Bearer sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gemini-2.0-flash-exp",
    "messages": [
      {"role": "user", "content": "Hello!"}
    ]
  }'
```

## 🎯 Demo 6: Troubleshooting

### Problem: Server tidak bisa start
```powershell
PS> .\start-server.ps1

[ERROR] config.yaml not found!
[INFO] Please run setup.ps1 first to create config.yaml

# Solution:
PS> .\setup.ps1  # Pilih [1] untuk setup
```

### Problem: Check server status
```powershell
PS> .\setup.ps1
# Pilih [12] View Server Status

[INFO] Checking Server Status...
[SUCCESS] Server is running on port 8317
[INFO] Process ID: 12345
[INFO] Memory Usage: 45.23 MB
[INFO] CPU Time: 12.34 seconds
```

### Problem: Edit config
```powershell
PS> .\setup.ps1
# Pilih [13] Edit Config File

[INFO] Opening config.yaml in default editor...
# Notepad akan terbuka dengan config.yaml
```

## 📊 Demo 7: Output Files

Setelah test API, beberapa file akan di-generate:

### models.json
```json
{
  "object": "list",
  "data": [
    {
      "id": "gemini-2.0-flash-exp",
      "object": "model",
      "created": 1702424222,
      "owned_by": "gemini"
    },
    ...
  ]
}
```

### models-data.js
```javascript
// Auto-generated model data from API
// Generated at: 2025-12-09 20:15:30

const apiModels = {"object":"list","data":[...]};
const apiEndpoint = "http://localhost:8317";
const apiPort = "8317";
```

### API-REFERENCE.txt
```
CLI PROXY API - QUICK REFERENCE
================================

API Endpoint: http://localhost:8317
API Key: sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

Available Endpoints:
  GET  http://localhost:8317/v1/models
  POST http://localhost:8317/v1/chat/completions
  POST http://localhost:8317/v1/completions

Example cURL:
  curl http://localhost:8317/v1/models \
    -H "Authorization: Bearer sk-xxxxx"

Total Models: 25

Models by Provider:

gemini (12 models):
  - gemini-2.0-flash-exp
  - gemini-2.0-flash-thinking-exp-01-21
  ...

codex (8 models):
  - gpt-5-codex
  - gpt-5-medium
  ...

Generated: 2025-12-09 20:15:30
```

## 🎉 Selesai!

Sekarang Anda sudah tahu cara menggunakan semua script helper yang tersedia!

### Quick Commands Cheat Sheet:

```powershell
# Setup lengkap
.\setup.ps1

# Quick start server
.\start-server.ps1

# Test API
.\test-api.ps1 -OpenBrowser

# Login with incognito
.\cli-proxy-api.exe -login -incognito
```

Happy coding! 🚀
