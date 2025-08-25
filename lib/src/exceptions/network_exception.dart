import 'webprint_exception.dart';

/// Exception thrown when network or HTTP operations fail
class NetworkException extends WebPrintException {
  /// HTTP status code
  final int statusCode;

  /// HTTP method that failed
  final String? method;

  /// URL that was being accessed
  final String? url;

  const NetworkException(
    super.message, {
    required this.statusCode,
    this.method,
    this.url,
    super.code,
    super.details,
  }) : super(statusCode: statusCode);

  /// Create a NetworkException from an HTTP response
  factory NetworkException.fromResponse(
    int statusCode,
    String message, {
    String? method,
    String? url,
  }) {
    return NetworkException(
      message,
      statusCode: statusCode,
      method: method,
      url: url,
    );
  }

  /// Create a NetworkException for connection errors
  factory NetworkException.connectionError(String message, {String? url}) {
    return NetworkException(
      message,
      statusCode: 0,
      url: url,
      code: 'CONNECTION_ERROR',
    );
  }

  @override
  String toString() {
    final buffer = StringBuffer('NetworkException: $message');
    buffer.write(' (Status: $statusCode)');
    if (method != null) buffer.write(' (Method: $method)');
    if (url != null) buffer.write(' (URL: $url)');
    return buffer.toString();
  }
}
