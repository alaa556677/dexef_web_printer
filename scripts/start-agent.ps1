# WebPrint Agent Startup Script
# Run this script to start the WebPrint Agent

Write-Host "Starting WebPrint Agent..." -ForegroundColor Green
Write-Host ""

# Check if Node.js is installed
try {
    $nodeVersion = node --version 2>$null
    if ($LASTEXITCODE -ne 0) {
        throw "Node.js not found"
    }
    Write-Host "Node.js version: $nodeVersion" -ForegroundColor Yellow
} catch {
    Write-Host "Error: Node.js is not installed or not in PATH" -ForegroundColor Red
    Write-Host "Please install Node.js from https://nodejs.org/" -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit 1
}

# Check if dependencies are installed
if (-not (Test-Path "node_modules")) {
    Write-Host "Installing dependencies..." -ForegroundColor Yellow
    npm install
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Error: Failed to install dependencies" -ForegroundColor Red
        Read-Host "Press Enter to exit"
        exit 1
    }
}

# Build the project
Write-Host "Building project..." -ForegroundColor Yellow
npm run build
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error: Build failed" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

# Start the agent
Write-Host "Starting WebPrint Agent..." -ForegroundColor Green
Write-Host ""
Write-Host "The agent will be available at: http://127.0.0.1:5123" -ForegroundColor Cyan
Write-Host "Your API key will be displayed in the console below." -ForegroundColor Cyan
Write-Host ""
Write-Host "Press Ctrl+C to stop the agent." -ForegroundColor Yellow
Write-Host ""

npm run start

Read-Host "Press Enter to exit"
