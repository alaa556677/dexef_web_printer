# WebPrint Agent - Dart Package

A Dart package that provides a client for the WebPrint Agent API, allowing Flutter applications to interact with local printers through a REST API.

## Features

- **Cross-platform support**: Works with Windows, macOS, and Linux
- **Silent PDF printing**: No user interaction required
- **Secure API**: API key authentication for all endpoints
- **Printer enumeration**: List available printers and get default printer
- **Job logging**: Track print job history and status
- **Type-safe models**: Full Dart type safety with JSON serialization
- **Error handling**: Comprehensive exception handling with custom exception types

## Installation

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  webprint_agent: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Prerequisites

Before using this package, you need to have the WebPrint Agent running on your machine:

1. **Install the WebPrint Agent**: Follow the instructions at [WebPrint Agent](https://github.com/yourusername/webprint-agent)
2. **Start the agent**: Run `npm run dev` in the WebPrint Agent directory
3. **Get your API key**: The agent will display an API key in the console when it starts

## Quick Start

```dart
import 'package:webprint_agent/webprint_agent.dart';

void main() async {
  // Initialize the client
  final client = WebPrintAgentClient(
    apiKey: 'your-api-key-here',
    baseUrl: 'http://127.0.0.1:5123', // Default URL
  );

  try {
    // Check if the agent is running
    final isConnected = await client.testConnection();
    if (!isConnected) {
      print('WebPrint Agent is not running');
      return;
    }

    // List available printers
    final printers = await client.listPrinters();
    print('Available printers: ${printers.map((p) => p.name).join(', ')}');

    // Get default printer
    final defaultPrinter = await client.getDefaultPrinter();
    if (defaultPrinter != null) {
      print('Default printer: ${defaultPrinter.name}');
    }

  } catch (e) {
    print('Error: $e');
  } finally {
    client.dispose();
  }
}
```

## API Reference

### WebPrintAgentClient

The main client class for interacting with the WebPrint Agent.

#### Constructor

```dart
WebPrintAgentClient({
  String? baseUrl,
  required String apiKey,
  http.Client? httpClient,
  Duration? timeout,
})
```

- `baseUrl`: The base URL of the WebPrint Agent (defaults to `http://127.0.0.1:5123`)
- `apiKey`: Your API key for authentication
- `httpClient`: Optional custom HTTP client
- `timeout`: Request timeout (defaults to 30 seconds)

#### Methods

##### checkHealth()
Check the health status of the WebPrint Agent.

```dart
Future<HealthStatus> checkHealth()
```

Returns system information including status, version, OS, architecture, uptime, and memory usage.

##### listPrinters()
Get a list of all available printers.

```dart
Future<List<PrinterInfo>> listPrinters()
```

Returns a list of `PrinterInfo` objects with printer details.

##### getDefaultPrinter()
Get the system's default printer.

```dart
Future<PrinterInfo?> getDefaultPrinter()
```

Returns the default printer or `null` if none is set.

##### printPdf()
Print a PDF file to a specified or default printer.

```dart
Future<Map<String, dynamic>> printPdf({
  required Uint8List pdfData,
  required String filename,
  String? printer,
})
```

- `pdfData`: The PDF file as bytes
- `filename`: Name of the file
- `printer`: Optional printer name (uses default if not specified)

Returns a map with job details including `jobId`, `printer`, and `filename`.

##### getPrintJobs()
Get print job history.

```dart
Future<List<PrintJob>> getPrintJobs({int? limit})
```

- `limit`: Maximum number of jobs to return

Returns a list of recent print jobs.

##### testConnection()
Test if the WebPrint Agent is accessible.

```dart
Future<bool> testConnection()
```

Returns `true` if the agent is running and accessible.

### Models

#### HealthStatus

Represents the system health status.

```dart
class HealthStatus {
  final String status;        // System status (usually "ok")
  final String version;       // Application version
  final String os;           // Operating system platform
  final String arch;         // System architecture
  final double uptime;       // System uptime in seconds
  final MemoryUsage memory;  // Memory usage information
}
```

#### PrinterInfo

Represents information about a printer.

```dart
class PrinterInfo {
  final String name;         // Printer name
  final String? portName;    // Printer port name
  final String? ipAddress;   // Printer IP address
  final String? macAddress;  // Printer MAC address
  final String? driverName;  // Printer driver name
  final String? location;    // Printer location
  final String? comment;     // Printer comment/description
  
  // Computed properties
  bool get isNetworkPrinter; // Whether this is a network printer
  String get displayName;    // Display name with location
}
```

#### PrintJob

Represents a print job.

```dart
class PrintJob {
  final String id;           // Unique job identifier
  final int timestamp;       // Creation timestamp
  final String printer;      // Printer name
  final String filename;     // File name
  final String status;       // Job status
  final String? error;       // Error message if failed
  
  // Computed properties
  bool get isSuccessful;     // Whether the job succeeded
  bool get hasError;         // Whether the job failed
  DateTime get createdAt;    // Creation date
  String get formattedTimestamp; // Human-readable timestamp
}
```

### Exception Handling

The package provides custom exception types for different error scenarios:

#### WebPrintException
Base exception class for all WebPrint Agent errors.

#### NetworkException
Thrown when network or HTTP operations fail.

```dart
try {
  await client.listPrinters();
} on NetworkException catch (e) {
  if (e.statusCode == 401) {
    print('Authentication failed: Invalid API key');
  } else {
    print('Network error: ${e.message}');
  }
}
```

#### PrintException
Thrown when printing operations fail.

```dart
try {
  await client.printPdf(pdfData: pdfBytes, filename: 'document.pdf');
} on PrintException catch (e) {
  print('Print failed: ${e.message}');
  if (e.printerName != null) {
    print('Printer: ${e.printerName}');
  }
}
```

## Examples

### Flutter Example

See the `example/main.dart` file for a complete Flutter application demonstrating all features.

### Simple Usage Example

```dart
import 'dart:typed_data';
import 'package:webprint_agent/webprint_agent.dart';

Future<void> printDocument(Uint8List pdfData, String filename) async {
  final client = WebPrintAgentClient(
    apiKey: 'your-api-key',
  );

  try {
    // Check connection
    if (!await client.testConnection()) {
      throw Exception('WebPrint Agent is not available');
    }

    // Get available printers
    final printers = await client.listPrinters();
    if (printers.isEmpty) {
      throw Exception('No printers available');
    }

    // Use first available printer
    final printer = printers.first.name;

    // Print the document
    final result = await client.printPdf(
      pdfData: pdfData,
      filename: filename,
      printer: printer,
    );

    print('Print job submitted: ${result['jobId']}');

  } catch (e) {
    print('Error: $e');
  } finally {
    client.dispose();
  }
}
```

### Error Handling Example

```dart
Future<void> robustPrinting(Uint8List pdfData, String filename) async {
  final client = WebPrintAgentClient(apiKey: 'your-api-key');

  try {
    // Check health first
    final health = await client.checkHealth();
    print('Agent status: ${health.status}');

    // List printers
    final printers = await client.listPrinters();
    print('Found ${printers.length} printers');

    // Get default printer
    final defaultPrinter = await client.getDefaultPrinter();
    final targetPrinter = defaultPrinter?.name ?? printers.first.name;

    // Print document
    final result = await client.printPdf(
      pdfData: pdfData,
      filename: filename,
      printer: targetPrinter,
    );

    print('Successfully printed to $targetPrinter');

  } on NetworkException catch (e) {
    switch (e.statusCode) {
      case 401:
        print('Authentication failed. Please check your API key.');
        break;
      case 404:
        print('WebPrint Agent endpoint not found.');
        break;
      case 500:
        print('Server error: ${e.message}');
        break;
      default:
        print('Network error: ${e.message}');
    }
  } on PrintException catch (e) {
    print('Print error: ${e.message}');
    if (e.printerName != null) {
      print('Printer: ${e.printerName}');
    }
  } catch (e) {
    print('Unexpected error: $e');
  } finally {
    client.dispose();
  }
}
```

## Configuration

### Environment Variables

You can configure the package using environment variables:

- `WEBPRINT_BASE_URL`: Base URL for the WebPrint Agent
- `WEBPRINT_API_KEY`: Your API key

### Custom HTTP Client

You can provide a custom HTTP client for advanced configurations:

```dart
import 'package:http/http.dart' as http;

final client = http.Client();
final webPrintClient = WebPrintAgentClient(
  apiKey: 'your-api-key',
  httpClient: client,
);

// Don't forget to dispose the custom client
client.close();
```

## Testing

Run the tests with:

```bash
flutter test
```

The package includes comprehensive unit tests for all models and exception types.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Ensure all tests pass
6. Submit a pull request

## License

This package is licensed under the MIT License - see the LICENSE file for details.

## Related

- [WebPrint Agent](https://github.com/yourusername/webprint-agent) - The server component
- [Flutter](https://flutter.dev) - UI framework
- [Dart](https://dart.dev) - Programming language
