# WebPrint Agent - Dart Package Structure

This document provides a comprehensive overview of the converted Dart package structure and organization.

## Directory Structure

```
webprint_agent/
├── 📁 lib/                          # Main package source code
│   ├── 📄 webprint_agent.dart       # Main export file
│   └── 📁 src/                      # Internal implementation
│       ├── 📄 api_client.dart       # Main API client
│       ├── 📁 constants/            # Constants and endpoints
│       │   ├── 📄 api_endpoints.dart # API endpoint URLs
│       │   └── 📄 print_status.dart # Print job status constants
│       ├── 📁 exceptions/            # Custom exception classes
│       │   ├── 📄 webprint_exception.dart # Base exception class
│       │   ├── 📄 print_exception.dart    # Print-specific exceptions
│       │   └── 📄 network_exception.dart  # Network/HTTP exceptions
│       └── 📁 models/               # Data models
│           ├── 📄 health_status.dart # System health information
│           ├── 📄 printer_info.dart  # Printer details
│           ├── 📄 print_job.dart     # Print job information
│           └── 📄 api_response.dart  # Generic API response wrapper
├── 📁 example/                      # Usage examples
│   ├── 📄 README.md                 # Examples documentation
│   ├── 📄 basic_usage.dart          # Comprehensive example
│   └── 📄 simple_usage.dart         # Simple usage example
├── 📁 test/                         # Unit tests
│   └── 📄 webprint_agent_test.dart  # Main test suite
├── 📄 pubspec.yaml                  # Package configuration
├── 📄 build.yaml                    # Build runner configuration
├── 📄 README.md                     # Package documentation
└── 📄 PROJECT_STRUCTURE_DART.md     # This file
```

## Key Components

### 🚀 Main Package Entry
- **`lib/webprint_agent.dart`**: Main export file exposing all public APIs

### 🔧 Core API Client
- **`lib/src/api_client.dart`**: Main client class for HTTP communication
- **Platform detection**: Automatically handles Windows vs POSIX differences
- **Error handling**: Comprehensive exception handling with custom types
- **Resource management**: Proper HTTP client disposal

### 🛣️ API Endpoints
- **`lib/src/constants/api_endpoints.dart`**: All API route constants
- **Base URL configuration**: Configurable server address
- **Endpoint definitions**: Health, printers, print, jobs, docs

### 🔐 Exception Handling
- **`WebPrintException`**: Base exception class for all errors
- **`NetworkException`**: HTTP and network-related errors
- **`PrintException`**: Print-specific operation errors
- **Status codes**: HTTP status code information
- **Error details**: Rich error information for debugging

### 📊 Data Models
- **`HealthStatus`**: System health and status information
- **`PrinterInfo`**: Printer details with network information
- **`PrintJob`**: Print job tracking and status
- **`ApiResponse`**: Generic response wrapper
- **JSON serialization**: Full JSON support with code generation

### 🧪 Testing
- **`test/webprint_agent_test.dart`**: Comprehensive unit tests
- **Model testing**: JSON serialization/deserialization tests
- **Exception testing**: Custom exception type tests
- **Constant testing**: API endpoint and status constant tests

### 📚 Examples
- **`example/basic_usage.dart`**: Complete feature demonstration
- **`example/simple_usage.dart`**: Basic usage patterns
- **Error handling**: Comprehensive error handling examples
- **Workflow examples**: Complete printing workflow demonstration

## Architecture Patterns

### 🔐 Security
- API key authentication for all protected endpoints
- Secure HTTP client configuration
- Proper resource disposal

### 📁 Configuration Management
- Configurable base URL and timeout
- Environment variable support
- Custom HTTP client injection

### 🖨️ Printing Abstraction
- Platform-agnostic API design
- Consistent interface across platforms
- Graceful error handling and fallbacks

### 📝 Error Handling
- Custom exception hierarchy
- Rich error information
- Proper exception propagation
- User-friendly error messages

## Type Conversion Summary

### TypeScript → Dart
- `string` → `String`
- `number` → `int` / `double`
- `boolean` → `bool`
- `any` → `dynamic` (minimal usage)
- `Array<T>` → `List<T>`
- `Promise<T>` → `Future<T>`
- `interface` → `abstract class`
- `class` → `class` (with proper constructors)

### Key Features Preserved
- **API functionality**: All endpoints maintained
- **Data structures**: Same response formats
- **Error handling**: Enhanced with custom exceptions
- **Authentication**: API key-based security
- **Platform support**: Cross-platform compatibility

### Dart-Specific Enhancements
- **Null safety**: Full null safety implementation
- **JSON serialization**: Code-generated serialization
- **Exception hierarchy**: Custom exception types
- **Resource management**: Proper disposal patterns
- **Type safety**: Strong typing throughout

## Development Workflow

### Setup
```bash
# Install dependencies
flutter pub get

# Generate code (if needed)
dart run build_runner build

# Run tests
flutter test
```

### Code Generation
- **JSON serialization**: Automatically generated
- **Build configuration**: `build.yaml` for customization
- **Dependencies**: `json_annotation` and `json_serializable`

### Testing
- **Unit tests**: Comprehensive model and exception testing
- **Test framework**: `flutter_test` for Flutter compatibility
- **Coverage**: All public APIs covered

## Package Configuration

### Dependencies
- **Core**: `http`, `json_annotation`, `path`, `uuid`
- **Development**: `json_serializable`, `build_runner`, `mockito`
- **Flutter**: Full Flutter SDK compatibility

### Environment Support
- **SDK**: Dart 3.0.0+
- **Flutter**: 3.0.0+
- **Platforms**: All Flutter-supported platforms

## Usage Patterns

### Basic Client
```dart
final client = WebPrintAgentClient(
  apiKey: 'your-api-key',
  baseUrl: 'http://127.0.0.1:5123',
);

try {
  final health = await client.checkHealth();
  final printers = await client.listPrinters();
} finally {
  client.dispose();
}
```

### Error Handling
```dart
try {
  await client.printPdf(pdfData: pdfBytes, filename: 'doc.pdf');
} on NetworkException catch (e) {
  // Handle network errors
} on PrintException catch (e) {
  // Handle print errors
}
```

### Resource Management
```dart
final client = WebPrintAgentClient(apiKey: 'key');
try {
  // Use client
} finally {
  client.dispose(); // Always dispose
}
```

## Publishing Considerations

### Package Name
- **Name**: `webprint_agent`
- **Description**: Cross-platform local print agent client
- **Version**: 1.0.0
- **License**: MIT

### Quality Standards
- **Null safety**: Full null safety compliance
- **Documentation**: Comprehensive API documentation
- **Testing**: High test coverage
- **Examples**: Working usage examples
- **Error handling**: Robust exception handling

This structure provides a clean, maintainable, and Flutter-ready Dart package that preserves all the functionality of the original TypeScript project while adding Dart-specific enhancements and best practices.
