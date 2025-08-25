import 'package:json_annotation/json_annotation.dart';

part 'print_job.g.dart';

/// Information about a print job
@JsonSerializable()
class PrintJob {
  /// Unique job identifier
  final String id;

  /// Timestamp when the job was created (milliseconds since epoch)
  final int timestamp;

  /// Name of the printer used
  final String printer;

  /// Name of the file that was printed
  final String filename;

  /// Job status (success, error, processing, etc.)
  final String status;

  /// Error message if the job failed
  final String? error;

  const PrintJob({
    required this.id,
    required this.timestamp,
    required this.printer,
    required this.filename,
    required this.status,
    this.error,
  });

  /// Create PrintJob from JSON
  factory PrintJob.fromJson(Map<String, dynamic> json) =>
      _$PrintJobFromJson(json);

  /// Convert PrintJob to JSON
  Map<String, dynamic> toJson() => _$PrintJobToJson(this);

  /// Create a copy of PrintJob with updated fields
  PrintJob copyWith({
    String? id,
    int? timestamp,
    String? printer,
    String? filename,
    String? status,
    String? error,
  }) {
    return PrintJob(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      printer: printer ?? this.printer,
      filename: filename ?? this.filename,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  /// Check if the job was successful
  bool get isSuccessful => status == 'success';

  /// Check if the job failed
  bool get hasError => status == 'error';

  /// Get the job creation date
  DateTime get createdAt => DateTime.fromMillisecondsSinceEpoch(timestamp);

  /// Get a human-readable timestamp
  String get formattedTimestamp {
    final now = DateTime.now();
    final created = createdAt;
    final difference = now.difference(created);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }

  @override
  String toString() {
    return 'PrintJob(id: $id, printer: $printer, filename: $filename, status: $status, timestamp: $formattedTimestamp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PrintJob &&
        other.id == id &&
        other.timestamp == timestamp &&
        other.printer == printer &&
        other.filename == filename &&
        other.status == status &&
        other.error == error;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        timestamp.hashCode ^
        printer.hashCode ^
        filename.hashCode ^
        status.hashCode ^
        error.hashCode;
  }
}
