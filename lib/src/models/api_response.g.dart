// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiResponse<T> _$ApiResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    ApiResponse<T>(
      data: _$nullableGenericFromJson(json['data'], fromJsonT),
      success: json['success'] as bool,
      message: json['message'] as String?,
      error: json['error'] as String?,
      statusCode: (json['statusCode'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ApiResponseToJson<T>(
  ApiResponse<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      if (_$nullableGenericToJson(instance.data, toJsonT) case final value?)
        'data': value,
      'success': instance.success,
      if (instance.message case final value?) 'message': value,
      if (instance.error case final value?) 'error': value,
      if (instance.statusCode case final value?) 'statusCode': value,
    };

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) =>
    input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) =>
    input == null ? null : toJson(input);
