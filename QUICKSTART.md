# Quick Start Guide

Get the WebPrint Agent running in 5 minutes!

## Prerequisites

- **Node.js 16+** installed
- **Windows**: Download SumatraPDF (see below)
- **macOS/Linux**: CUPS should be pre-installed

## Windows Users - Download SumatraPDF

1. Go to [SumatraPDF Downloads](https://www.sumatrapdfreader.org/download-free-pdf-viewer)
2. Download the **portable version** (not installer)
3. Extract and copy `SumatraPDF.exe` to `vendor/sumatra/` folder

## Quick Setup

### 1. Install Dependencies
```bash
npm install
```

### 2. Build the Project
```bash
npm run build
```

### 3. Start the Agent
```bash
npm run dev
```

### 4. Test the Connection
```bash
node scripts/test-connection.js
```

## What You'll See

The console will display:
```
WebPrint Agent listening on http://127.0.0.1:5123
API key: abc123-def456-ghi789...
Data directory: C:\Users\YourName\.webprint-agent
```

## Test the API

### Health Check (no auth required)
```bash
curl http://localhost:5123/health
```

### List Printers (requires API key)
```bash
curl -H "X-API-Key: YOUR_API_KEY" http://localhost:5123/printers
```

### Print a PDF
```bash
curl -X POST \
  -H "X-API-Key: YOUR_API_KEY" \
  -F "file=@path/to/your.pdf" \
  -F "printer=Your Printer Name" \
  http://localhost:5123/print
```

## Next Steps

- Read the full [README.md](README.md) for detailed documentation
- Use the [api.http](api.http) file with VS Code REST Client
- Install as a Windows service: `node scripts/win-service.js install`

## Troubleshooting

### "SumatraPDF not found"
- Ensure `SumatraPDF.exe` is in `vendor/sumatra/` folder
- Check file permissions

### "Connection refused"
- Make sure the agent is running: `npm run dev`
- Check if port 5123 is available

### "Unauthorized"
- Use the API key displayed in the console
- Include it in the `X-API-Key` header

## Need Help?

- Check the [README.md](README.md) for detailed information
- Look at the [troubleshooting section](README.md#troubleshooting)
- Verify your setup with the test script: `node scripts/test-connection.js`
