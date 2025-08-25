import 'webprint_exception.dart';

/// Exception thrown when printing operations fail
class PrintException extends WebPrintException {
  /// Name of the printer that caused the error
  final String? printerName;

  /// Name of the file that failed to print
  final String? fileName;

  const PrintException(
    super.message, {
    super.code,
    super.statusCode,
    super.details,
    this.printerName,
    this.fileName,
  });

  /// Create a PrintException from a JSON error response
  factory PrintException.fromJson(Map<String, dynamic> json) {
    return PrintException(
      json['error'] as String? ?? 'Unknown print error',
      statusCode: json['statusCode'] as int?,
      details: json,
    );
  }

  @override
  String toString() {
    final buffer = StringBuffer('PrintException: $message');
    if (printerName != null) buffer.write(' (Printer: $printerName)');
    if (fileName != null) buffer.write(' (File: $fileName)');
    if (statusCode != null) buffer.write(' (Status: $statusCode)');
    return buffer.toString();
  }
}
