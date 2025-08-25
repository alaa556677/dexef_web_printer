/// Base exception class for WebPrint Agent errors
abstract class WebPrintException implements Exception {
  /// Error message
  final String message;

  /// Error code (optional)
  final String? code;

  /// HTTP status code (optional)
  final int? statusCode;

  /// Additional error details
  final Map<String, dynamic>? details;

  const WebPrintException(
    this.message, {
    this.code,
    this.statusCode,
    this.details,
  });

  @override
  String toString() {
    final buffer = StringBuffer('WebPrintException: $message');
    if (code != null) buffer.write(' (Code: $code)');
    if (statusCode != null) buffer.write(' (Status: $statusCode)');
    if (details != null) buffer.write(' (Details: $details)');
    return buffer.toString();
  }
}
