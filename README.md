# WebPrint Agent

A cross-platform Local Print Agent that runs on your machine, exposes a localhost HTTP API, enumerates installed printers, and prints PDF files silently to a selected printer.

## Features

- **Cross-platform support**: Windows (first-class), macOS, and Linux
- **Silent PDF printing**: No user interaction required
- **Secure API**: API key authentication for all endpoints
- **Printer enumeration**: List available printers and get default printer
- **Job logging**: Track print job history and status
- **Windows service**: Install as a Windows service for automatic startup

## Prerequisites

### Windows
- **SumatraPDF**: Download [SumatraPDF](https://www.sumatrapdfreader.org/download-free-pdf-viewer) and place `SumatraPDF.exe` in the `vendor/sumatra/` directory
- **Node.js**: Version 16.0.0 or higher

### macOS
- **CUPS**: Usually pre-installed
- **lpr command**: Available by default
- **Node.js**: Version 16.0.0 or higher

### Linux
- **CUPS**: Install with `sudo apt-get install cups` (Ubuntu/Debian) or `sudo yum install cups` (CentOS/RHEL)
- **lp command**: Available with CUPS
- **Node.js**: Version 16.0.0 or higher

## Installation

1. **Clone or download** this repository
2. **Install dependencies**:
   ```bash
   npm install
   ```
3. **Download SumatraPDF** (Windows only):
   - Download from [SumatraPDF website](https://www.sumatrapdfreader.org/download-free-pdf-viewer)
   - Extract and place `SumatraPDF.exe` in `vendor/sumatra/` directory
4. **Build the project**:
   ```bash
   npm run build
   ```

## Usage

### Development Mode
```bash
npm run dev
```

### Production Mode
```bash
npm run start
```

The server will start on `http://127.0.0.1:5123` and display your API key in the console.

## API Endpoints

### Authentication
All endpoints except `/health` require the `X-API-Key` header with your API key.

### Health Check
```http
GET /health
```
Returns system status, version, OS, and architecture.

### List Printers
```http
GET /printers
X-API-Key: YOUR_API_KEY
```
Returns an array of available printer names.

### Get Default Printer
```http
GET /printers/default
X-API-Key: YOUR_API_KEY
```
Returns the default printer name or `null` if none is set.

### Print PDF
```http
POST /print
X-API-Key: YOUR_API_KEY
Content-Type: multipart/form-data

printer: "Printer Name" (optional, uses default if not specified)
file: PDF file
```
Prints the PDF file to the specified printer (or default printer).

### Get Print Jobs
```http
GET /jobs?limit=10
X-API-Key: YOUR_API_KEY
```
Returns the history of print jobs. Use `limit` query parameter to specify the number of jobs to return.

## Windows Service Installation

### Install Service
```bash
node scripts/win-service.js install
```

### Uninstall Service
```bash
node scripts/win-service.js uninstall
```

### Start/Stop Service
```bash
node scripts/win-service.js start
node scripts/win-service.js stop
```

## Configuration

The agent creates a configuration file at `~/.webprint-agent/config.json` on first run. You can modify:

- **API Key**: Automatically generated on first run
- **Default Printer**: Set your preferred default printer
- **Port**: Change the listening port (default: 5123)
- **SumatraPDF Path**: Customize the path to SumatraPDF executable

## Client Examples

### Flutter Web
```dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:typed_data';

const base = 'http://localhost:5123';
const apiKey = 'YOUR_API_KEY';

Future<List<String>> loadPrinters() async {
  final response = await http.get(
    Uri.parse('$base/printers'),
    headers: {'X-API-Key': apiKey}
  );
  
  if (response.statusCode == 200) {
    return (jsonDecode(response.body) as List).cast<String>();
  } else {
    throw Exception('Failed to load printers: ${response.body}');
  }
}

Future<void> printPdf(Uint8List pdf, {String? printer}) async {
  final request = http.MultipartRequest('POST', Uri.parse('$base/print'))
    ..headers['X-API-Key'] = apiKey
    ..fields['printer'] = printer ?? ''
    ..files.add(http.MultipartFile.fromBytes('file', pdf, filename: 'document.pdf'));
  
  final response = await request.send();
  if (response.statusCode != 200) {
    throw Exception('Print failed: ${await response.stream.bytesToString()}');
  }
}
```

### JavaScript/Node.js
```javascript
const FormData = require('form-data');
const fs = require('fs');

async function printPdf(pdfPath, printer = null) {
  const form = new FormData();
  form.append('file', fs.createReadStream(pdfPath));
  if (printer) {
    form.append('printer', printer);
  }
  
  const response = await fetch('http://localhost:5123/print', {
    method: 'POST',
    headers: {
      'X-API-Key': 'YOUR_API_KEY'
    },
    body: form
  });
  
  if (!response.ok) {
    throw new Error(`Print failed: ${await response.text()}`);
  }
  
  return response.json();
}
```

## Troubleshooting

### SumatraPDF Not Found (Windows)
- Ensure `SumatraPDF.exe` is placed in `vendor/sumatra/` directory
- Check file permissions
- Verify the executable is not corrupted

### Printer Not Found
- Verify the printer name matches exactly (case-sensitive)
- Check if the printer is shared/network printer
- Ensure the printer driver is properly installed

### Permission Errors
- Run as Administrator on Windows if needed
- Check file permissions for the data directory
- Verify network access for network printers

### Service Installation Issues
- Ensure you're running as Administrator
- Check if the service name conflicts with existing services
- Verify the build output exists at `dist/index.js`

## Security Notes

- The API key is generated automatically on first run
- The server binds only to `127.0.0.1` (localhost)
- CORS is configured to allow only localhost origins
- File uploads are limited to 100MB
- Only PDF files are accepted

## Development

### Project Structure
```
webprint-agent/
├── src/
│   ├── index.ts          # Entry point
│   ├── server.ts         # Express server setup
│   ├── routes/           # API route handlers
│   ├── services/         # Business logic
│   └── utils/            # Utility functions
├── config/               # Configuration files
├── scripts/              # Service installation scripts
├── vendor/               # Third-party executables
└── dist/                 # Build output
```

### Building
```bash
npm run build
```

### Testing
Use the provided `api.http` file with VS Code REST Client, HTTPYac, or Insomnia to test the API endpoints.

## License

MIT License - see LICENSE file for details.
