/// API endpoint constants for the WebPrint Agent
class ApiEndpoints {
  const ApiEndpoints._();

  /// Base URL for the WebPrint Agent API
  static const String baseUrl = 'http://127.0.0.1:5123';

  /// Health check endpoint (no authentication required)
  static const String health = '/health';

  /// List all available printers
  static const String printers = '/printers';

  /// Get default printer
  static const String defaultPrinter = '/printers/default';

  /// Print PDF endpoint
  static const String print = '/print';

  /// Get print jobs history
  static const String jobs = '/jobs';

  /// Swagger UI documentation
  static const String apiDocs = '/api-docs';
}
