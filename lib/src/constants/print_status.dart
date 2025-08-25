/// Print job status constants
class PrintStatus {
  const PrintStatus._();

  /// Print job completed successfully
  static const String success = 'success';

  /// Print job failed with an error
  static const String error = 'error';

  /// Print job is currently processing
  static const String processing = 'processing';

  /// Print job is queued
  static const String queued = 'queued';

  /// Print job was cancelled
  static const String cancelled = 'cancelled';
}
