# WebPrint Agent Examples

This directory contains examples demonstrating how to use the WebPrint Agent Dart package.

## Examples

### basic_usage.dart
A comprehensive example showing all the main features of the package:

- Connection testing
- Health status checking
- Printer enumeration
- Default printer retrieval
- Print job history
- Error handling patterns
- Complete printing workflow

**Run with:**
```bash
dart run example/basic_usage.dart
```

### simple_usage.dart
A simpler example focused on basic functionality:

- Basic client initialization
- Simple API calls
- Basic error handling
- Example printing function

**Run with:**
```bash
dart run example/simple_usage.dart
```

## Prerequisites

Before running the examples:

1. **Install the WebPrint Agent** on your machine
2. **Start the agent** with `npm run dev`
3. **Copy your API key** from the console output
4. **Update the API key** in the example files

## Configuration

Update these values in the example files:

```dart
final client = WebPrintAgentClient(
  apiKey: 'your-api-key-here', // Replace with your actual API key
  baseUrl: 'http://127.0.0.1:5123', // Update if using different port
);
```

## Expected Output

When running successfully, you should see:

```
=== WebPrint Agent Basic Usage Example ===

1. Testing connection...
   Connection: ✅ SUCCESS

2. Checking health status...
   Status: ok
   Version: 1.0.0
   OS: win32
   Architecture: x64
   Uptime: 45.2s
   Memory: 219.07MB

3. Listing available printers...
   Found 2 printer(s):
   1. HP LaserJet Pro
      📍 Location: Office
      🖨️  Driver: HP LaserJet Pro
      🌐 IP: 192.168.1.100

   2. Canon Printer
      📍 Location: Home

4. Getting default printer...
   Default printer: HP LaserJet Pro
   Location: Office

5. Getting recent print jobs...
   Found 3 recent job(s):
   1. ✅ document.pdf
      🖨️  Printer: HP LaserJet Pro
      📅 Created: 2 minutes ago

   2. ✅ report.pdf
      🖨️  Printer: HP LaserJet Pro
      📅 Created: 1 hour ago

   3. ❌ test.pdf
      🖨️  Printer: HP LaserJet Pro
      📅 Created: 2 hours ago
      ⚠️  Error: Printer offline

🧹 Client disposed successfully
```

## Troubleshooting

### Connection Failed
- Ensure the WebPrint Agent is running
- Check the base URL and port
- Verify the agent is accessible at the specified URL

### Authentication Error
- Check your API key
- Ensure the key matches what's displayed in the agent console
- Verify the key is correctly copied (no extra spaces)

### No Printers Found
- Check if printers are installed on your system
- Ensure printer drivers are properly installed
- Try running the agent as administrator (Windows)

## Next Steps

After running the examples successfully:

1. **Integrate the package** into your Flutter application
2. **Customize error handling** for your use case
3. **Add printer selection UI** for user choice
4. **Implement print job monitoring** for status updates
5. **Add offline support** with job queuing
