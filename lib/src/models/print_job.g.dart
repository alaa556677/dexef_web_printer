// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'print_job.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrintJob _$PrintJobFromJson(Map<String, dynamic> json) => PrintJob(
      id: json['id'] as String,
      timestamp: (json['timestamp'] as num).toInt(),
      printer: json['printer'] as String,
      filename: json['filename'] as String,
      status: json['status'] as String,
      error: json['error'] as String?,
    );

Map<String, dynamic> _$PrintJobToJson(PrintJob instance) => <String, dynamic>{
      'id': instance.id,
      'timestamp': instance.timestamp,
      'printer': instance.printer,
      'filename': instance.filename,
      'status': instance.status,
      if (instance.error case final value?) 'error': value,
    };
