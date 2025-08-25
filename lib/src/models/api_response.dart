import 'package:json_annotation/json_annotation.dart';

part 'api_response.g.dart';

/// Generic API response wrapper
@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> {
  /// Response data
  final T? data;

  /// Success status
  final bool success;

  /// Response message
  final String? message;

  /// Error details if any
  final String? error;

  /// HTTP status code
  final int? statusCode;

  const ApiResponse({
    this.data,
    required this.success,
    this.message,
    this.error,
    this.statusCode,
  });

  /// Create a successful response
  factory ApiResponse.success({
    T? data,
    String? message,
    int? statusCode,
  }) {
    return ApiResponse<T>(
      data: data,
      success: true,
      message: message,
      statusCode: statusCode,
    );
  }

  /// Create an error response
  factory ApiResponse.error({
    String? error,
    String? message,
    int? statusCode,
  }) {
    return ApiResponse<T>(
      success: false,
      error: error,
      message: message,
      statusCode: statusCode,
    );
  }

  /// Create ApiResponse from JSON
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$ApiResponseFromJson(json, fromJsonT);

  /// Convert ApiResponse to JSON
  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$ApiResponseToJson(this, toJsonT);

  /// Check if the response has data
  bool get hasData => data != null;

  /// Check if the response has an error
  bool get hasError => error != null;

  @override
  String toString() {
    return 'ApiResponse(success: $success, data: $data, message: $message, error: $error, statusCode: $statusCode)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ApiResponse<T> &&
        other.data == data &&
        other.success == success &&
        other.message == message &&
        other.error == error &&
        other.statusCode == statusCode;
  }

  @override
  int get hashCode {
    return data.hashCode ^
        success.hashCode ^
        message.hashCode ^
        error.hashCode ^
        statusCode.hashCode;
  }
}
