# CLIProxyAPI Plus

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![GitHub Issues](https://img.shields.io/github/issues/riofach/CLIProxyAIPlus.svg)](https://github.com/riofach/CLIProxyAIPlus/issues)
[![GitHub Stars](https://img.shields.io/github/stars/riofach/CLIProxyAIPlus.svg)](https://github.com/riofach/CLIProxyAIPlus/stargazers)

🚀 **Enhanced fork** of [CLIProxyAPI](https://github.com/router-for-me/CLIProxyAPI) with additional third-party provider support and improved tooling.

## 📖 Table of Contents

- [What's New](#whats-new)
- [Quick Start](#quick-start)
- [Features](#features)
- [Supported Providers](#supported-providers)
- [Usage](#usage)
- [Contributing](#contributing)
- [Troubleshooting](#troubleshooting)
- [License](#license)

## ✨ What's New

### 🔧 Improvements in This Fork

- ✅ **Fixed JSON unmarshaling bug** - Better handling of function responses from Factory/Antigravity
- ✅ **All-in-one setup script** (`setup.ps1`) - Complete management interface
- ✅ **Auto-generated API keys** - No manual configuration needed
- ✅ **Improved debugging** - Enhanced logging for troubleshooting
- ✅ **Better documentation** - Consolidated and streamlined guides

### 📦 Additional Provider Support

- 🔹 **GitHub Copilot** (OAuth login) - Contributed by [em4go](https://github.com/em4go/CLIProxyAPI/tree/feature/github-copilot-auth)
- 🔹 **Kiro** (AWS CodeWhisperer with OAuth) - Contributed by [fuko2935](https://github.com/fuko2935/CLIProxyAPI/tree/feature/kiro-integration)

## 🚀 Quick Start

### Prerequisites

- **Windows** with PowerShell 5.1+
- **Go 1.21+** (for building from source)
- An account with at least one supported provider

### Installation & Setup

1. **Clone the repository**
   ```powershell
   git clone https://github.com/riofach/CLIProxyAIPlus.git
   cd CLIProxyAIPlus
   ```

2. **Run the all-in-one setup script**
   ```powershell
   .\setup.ps1
   ```

3. **Follow the menu**
   ```
   [1] Setup Config File (Auto-Generate API Key)
   [10] Login to Antigravity (or other provider)
   [11] Start Server
   [12] Test API & List Models
   ```

That's it! Your proxy server is now running. 🎉

## 🎯 Features

### 🔐 Authentication

- Multiple provider login support
- OAuth authentication for supported providers
- Account rotation and load balancing
- Secure credential storage

### ⚙️ Setup Script (`setup.ps1`)

Complete management interface with:

#### 🔧 Setup & Config
- `[1]` **Setup Config** - Auto-generates API key and creates config.yaml
- `[2]` **Edit Config** - Modify server settings

#### 🔐 Provider Login
- `[3]` Gemini CLI
- `[4]` OpenAI Codex
- `[5]` Claude Code
- `[6]` GitHub Copilot
- `[7]` Qwen
- `[8]` iFlow
- `[9]` Kiro (AWS CodeWhisperer)
- `[10]` Antigravity

#### ⚙️ Server Operations
- `[11]` **Start Server** - Launch the proxy
- `[12]` **Test API** - Verify connection and list models
- `[13]` **View Status** - Check server health

#### 🔧 Troubleshooting
- `[14]` **Fix 401 Error** - Auto-diagnostic for auth issues
- `[15]` **System Check** - Full health verification
- `[16]` **View Logs** - Check server logs

#### 🛠️ Maintenance
- `[17]` **Update Repository** - Pull latest changes
- `[18]` **Backup** - Save config and auth files
- `[19]` **Documentation** - Access guides

### 📊 API Compatibility

- ✅ OpenAI-compatible `/v1/chat/completions`
- ✅ OpenAI-compatible `/v1/models`
- ✅ Streaming responses
- ✅ Function calling support
- ✅ Multi-provider routing

## 🌐 Supported Providers

| Provider | Login Method | Status | Notes |
|----------|--------------|--------|-------|
| **Gemini CLI** | OAuth | ✅ Stable | Google account required |
| **Antigravity** | OAuth | ✅ Stable | Recommended for testing |
| **OpenAI Codex** | OAuth | ✅ Stable | ChatGPT subscription |
| **Claude Code** | OAuth | ✅ Stable | Claude subscription |
| **GitHub Copilot** | OAuth | ✅ Plus | Copilot subscription |
| **Qwen** | OAuth | ✅ Stable | Qwen account |
| **iFlow** | OAuth | ✅ Stable | iFlow account |
| **Kiro** | OAuth/AWS | ✅ Plus | AWS CodeWhisperer |

## 📝 Usage

### Starting the Server

**Option 1: Using setup.ps1 (Recommended)**
```powershell
.\setup.ps1
# Select [11] Start Server
```

**Option 2: Direct execution**
```powershell
.\cli-proxy-api.exe -config config.yaml
```

### Testing the API

**Using setup.ps1:**
```powershell
.\setup.ps1
# Select [12] Test API & List Models
```

**Using curl:**
```powershell
curl http://localhost:8317/v1/models `
  -H "Authorization: Bearer YOUR-API-KEY"
```

### Example Request

```powershell
$body = @{
  model = "gemini-2.5-flash"
  messages = @(
    @{
      role = "user"
      content = "Hello!"
    }
  )
} | ConvertTo-Json

curl http://localhost:8317/v1/chat/completions `
  -H "Authorization: Bearer YOUR-API-KEY" `
  -H "Content-Type: application/json" `
  -d $body
```

## 🤝 Contributing

Contributions are welcome! This fork focuses on:

1. **Bug fixes** and stability improvements
2. **Third-party provider** integrations
3. **Developer experience** enhancements
4. **Documentation** improvements

### How to Contribute

1. Fork this repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Contribution Guidelines

- **Third-party providers:** PRs adding new provider support are encouraged
- **Core changes:** Major architectural changes should be discussed first via issues
- **Mainline sync:** This fork stays in sync with mainline features
- **Code quality:** Follow existing code style and add tests where applicable

## 🆘 Troubleshooting

### Common Issues

#### 401 Unauthorized Error

**Run auto-diagnostic:**
```powershell
.\setup.ps1
# Select [14] Fix 401 Error
```

The script will:
- ✅ Check config.yaml format
- ✅ Verify API key format
- ✅ Test server connection
- ✅ Provide specific fix recommendations

#### No Models Found

**Cause:** No provider is logged in

**Solution:**
```powershell
.\setup.ps1
# Select [10] Login to Antigravity (or any provider)
# Then [11] Restart Server
```

#### Server Won't Start

**Run system check:**
```powershell
.\setup.ps1
# Select [15] Full System Check
```

### Getting Help

1. Check the [Issues](https://github.com/riofach/CLIProxyAIPlus/issues) page
2. Review built-in documentation: `.\setup.ps1` → `[19] View Documentation`
3. Enable debug logging in `config.yaml`:
   ```yaml
   debug: true
   logging-to-file: true
   ```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Original [CLIProxyAPI](https://github.com/router-for-me/CLIProxyAPI) project
- [em4go](https://github.com/em4go) for GitHub Copilot integration
- [fuko2935](https://github.com/fuko2935) for Kiro (AWS CodeWhisperer) integration
- All contributors to the mainline and Plus versions

## 📞 Links

- **Repository:** https://github.com/riofach/CLIProxyAIPlus
- **Issues:** https://github.com/riofach/CLIProxyAIPlus/issues
- **Mainline Project:** https://github.com/router-for-me/CLIProxyAPI

---

<div align="center">

**Made with ❤️ by the community**

*Star ⭐ this repo if you find it useful!*

</div>
