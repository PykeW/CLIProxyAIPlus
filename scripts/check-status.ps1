# CLI Proxy API - Status Checker
# Check system status and diagnose issues

$ErrorActionPreference = "SilentlyContinue"

Write-Host ""
Write-Host "╔══════════════════════════════════════════════════════════╗" -ForegroundColor Magenta
Write-Host "║     CLI PROXY API - STATUS CHECK                         ║" -ForegroundColor Magenta
Write-Host "╚══════════════════════════════════════════════════════════╝" -ForegroundColor Magenta
Write-Host ""

$issues = @()
$recommendations = @()

# 1. Config Check
Write-Host "📄 Config File Check" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray

if (Test-Path config.yaml) {
    Write-Host "✅ Config file exists: config.yaml" -ForegroundColor Green
    
    $config = Get-Content config.yaml -Raw
    
    # Check API key
    if ($config -match "api-keys:\s*`n\s*-\s*`"([^`"]+)`"") {
        $apiKey = $matches[1]
        Write-Host "✅ API key configured: $($apiKey.Substring(0,10))..." -ForegroundColor Green
    } else {
        Write-Host "❌ API key not configured!" -ForegroundColor Red
        $issues += "API key missing"
        $recommendations += "Run: .\setup.ps1 and choose [1] to setup config"
    }
    
    # Check port
    if ($config -match 'port:\s*(\d+)') {
        $port = [int]$matches[1]
        Write-Host "✅ Port configured: $port" -ForegroundColor Green
    } else {
        $port = 8317
        Write-Host "⚠️  Port not specified, using default: 8317" -ForegroundColor Yellow
    }
    
    # Check debug mode
    if ($config -match 'debug:\s*true') {
        Write-Host "ℹ️  Debug mode: enabled" -ForegroundColor Cyan
    } else {
        Write-Host "ℹ️  Debug mode: disabled" -ForegroundColor Gray
    }
} else {
    Write-Host "❌ Config file not found!" -ForegroundColor Red
    $issues += "Config file missing"
    $recommendations += "Run: .\setup.ps1 and choose [1] to create config"
}

Write-Host ""

# 2. Auth Files Check
Write-Host "🔑 Authentication Check" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray

$authPath = "$env:USERPROFILE\.cli-proxy-api"
if (Test-Path $authPath) {
    $authFiles = Get-ChildItem $authPath -Recurse -File -ErrorAction SilentlyContinue
    
    if ($authFiles -and $authFiles.Count -gt 0) {
        Write-Host "✅ Auth directory exists: $authPath" -ForegroundColor Green
        Write-Host "ℹ️  Total auth files: $($authFiles.Count)" -ForegroundColor Cyan
        Write-Host ""
        
        # List providers with accounts
        $providers = Get-ChildItem $authPath -Directory -ErrorAction SilentlyContinue
        $hasAccounts = $false
        
        foreach ($provider in $providers) {
            $files = Get-ChildItem $provider.FullName -File -ErrorAction SilentlyContinue
            if ($files -and $files.Count -gt 0) {
                Write-Host "   ✅ $($provider.Name): $($files.Count) account(s)" -ForegroundColor Green
                $hasAccounts = $true
            }
        }
        
        if (-not $hasAccounts) {
            Write-Host "❌ No valid provider accounts found!" -ForegroundColor Red
            $issues += "No provider accounts"
            $recommendations += "Login to a provider: .\cli-proxy-api.exe -login"
        }
    } else {
        Write-Host "❌ Auth directory empty!" -ForegroundColor Red
        $issues += "No auth files"
        $recommendations += "Login to a provider: .\cli-proxy-api.exe -login"
    }
} else {
    Write-Host "❌ Auth directory not found: $authPath" -ForegroundColor Red
    $issues += "Auth directory missing"
    $recommendations += "Login to a provider: .\cli-proxy-api.exe -login"
}

Write-Host ""

# 3. Server Process Check
Write-Host "⚙️  Server Process Check" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray

$process = Get-Process -Name "cli-proxy-api" -ErrorAction SilentlyContinue
if ($process) {
    Write-Host "✅ Server process running" -ForegroundColor Green
    Write-Host "   • PID: $($process.Id)" -ForegroundColor Gray
    Write-Host "   • Memory: $([math]::Round($process.WorkingSet64/1MB, 2)) MB" -ForegroundColor Gray
    Write-Host "   • CPU Time: $([math]::Round($process.TotalProcessorTime.TotalSeconds, 2))s" -ForegroundColor Gray
} else {
    Write-Host "❌ Server not running!" -ForegroundColor Red
    $issues += "Server not running"
    $recommendations += "Start server: .\start-server.ps1"
}

Write-Host ""

# 4. Network/Port Check
Write-Host "🌐 Network Check" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray

if (Test-Path config.yaml) {
    $configContent = Get-Content config.yaml -Raw
    $port = 8317
    if ($configContent -match 'port:\s*(\d+)') {
        $port = [int]$matches[1]
    }
    
    try {
        $tcpClient = New-Object System.Net.Sockets.TcpClient
        $tcpClient.Connect("localhost", $port)
        $tcpClient.Close()
        
        Write-Host "✅ Port $port is accessible" -ForegroundColor Green
    } catch {
        Write-Host "❌ Port $port not accessible!" -ForegroundColor Red
        $issues += "Port $port not accessible"
        
        if (-not $process) {
            $recommendations += "Server not running. Start with: .\start-server.ps1"
        } else {
            $recommendations += "Port may be blocked by firewall"
        }
    }
} else {
    Write-Host "⚠️  Cannot check port (config missing)" -ForegroundColor Yellow
}

Write-Host ""

# 5. API Endpoint Test
Write-Host "🧪 API Test" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray

if ($process -and (Test-Path config.yaml)) {
    try {
        $configContent = Get-Content config.yaml -Raw
        $apiKey = ""
        
        if ($configContent -match "api-keys:\s*`n\s*-\s*`"([^`"]+)`"") {
            $apiKey = $matches[1]
        }
        
        $port = 8317
        if ($configContent -match 'port:\s*(\d+)') {
            $port = $matches[1]
        }
        
        $headers = @{
            "Authorization" = "Bearer $apiKey"
        }
        
        $ErrorActionPreference = "Stop"
        $response = Invoke-RestMethod -Uri "http://localhost:$port/v1/models" -Headers $headers -TimeoutSec 5
        $ErrorActionPreference = "SilentlyContinue"
        
        if ($response.data) {
            Write-Host "✅ API responding correctly" -ForegroundColor Green
            Write-Host "ℹ️  Total models: $($response.data.Count)" -ForegroundColor Cyan
            Write-Host ""
            
            # Group by provider
            $providers = $response.data | Group-Object -Property owned_by
            
            if ($providers -and $providers.Count -gt 0) {
                Write-Host "   Models by Provider:" -ForegroundColor Gray
                foreach ($provider in $providers) {
                    $providerName = if ($provider.Name) { $provider.Name } else { "unknown" }
                    Write-Host "   ✅ $providerName`: $($provider.Count) model(s)" -ForegroundColor Green
                }
                
                if ($response.data.Count -eq 0) {
                    Write-Host ""
                    Write-Host "⚠️  No models available!" -ForegroundColor Yellow
                    $issues += "No models available"
                    $recommendations += "Login to a provider: .\cli-proxy-api.exe -login"
                }
            }
        } else {
            Write-Host "⚠️  API responding but no models found" -ForegroundColor Yellow
            $issues += "No models available"
            $recommendations += "Login to a provider: .\cli-proxy-api.exe -login"
        }
    } catch {
        Write-Host "❌ API test failed!" -ForegroundColor Red
        Write-Host "   Error: $($_.Exception.Message)" -ForegroundColor Red
        $issues += "API not responding"
        
        if ($_.Exception.Message -like "*401*" -or $_.Exception.Message -like "*Unauthorized*") {
            $recommendations += "API key may be incorrect. Check config.yaml"
        } else {
            $recommendations += "Check server logs for errors"
        }
    }
} else {
    if (-not $process) {
        Write-Host "⚠️  Cannot test API (server not running)" -ForegroundColor Yellow
    } else {
        Write-Host "⚠️  Cannot test API (config missing)" -ForegroundColor Yellow
    }
}

Write-Host ""

# 6. Summary
Write-Host "══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "SUMMARY" -ForegroundColor Cyan
Write-Host "══════════════════════════════════════════════════════════" -ForegroundColor Cyan

if ($issues.Count -eq 0) {
    Write-Host "🎉 All checks passed! System is healthy." -ForegroundColor Green
} else {
    Write-Host "⚠️  Issues Found: $($issues.Count)" -ForegroundColor Yellow
    Write-Host ""
    
    foreach ($issue in $issues) {
        Write-Host "   • $issue" -ForegroundColor Red
    }
}

if ($recommendations.Count -gt 0) {
    Write-Host ""
    Write-Host "💡 Recommendations:" -ForegroundColor Yellow
    Write-Host ""
    
    $recommendations | Select-Object -Unique | ForEach-Object {
        Write-Host "   → $_" -ForegroundColor White
    }
}

Write-Host ""
Write-Host "══════════════════════════════════════════════════════════" -ForegroundColor Cyan

# Exit code based on issues
if ($issues.Count -gt 0) {
    exit 1
} else {
    exit 0
}
