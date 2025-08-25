// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HealthStatus _$HealthStatusFromJson(Map<String, dynamic> json) => HealthStatus(
      status: json['status'] as String,
      version: json['version'] as String,
      os: json['os'] as String,
      arch: json['arch'] as String,
      uptime: (json['uptime'] as num).toDouble(),
      memory: MemoryUsage.fromJson(json['memory'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$HealthStatusToJson(HealthStatus instance) =>
    <String, dynamic>{
      'status': instance.status,
      'version': instance.version,
      'os': instance.os,
      'arch': instance.arch,
      'uptime': instance.uptime,
      'memory': instance.memory.toJson(),
    };

MemoryUsage _$MemoryUsageFromJson(Map<String, dynamic> json) => MemoryUsage(
      rss: (json['rss'] as num).toInt(),
      heapTotal: (json['heapTotal'] as num).toInt(),
      heapUsed: (json['heapUsed'] as num).toInt(),
      external: (json['external'] as num).toInt(),
      arrayBuffers: (json['arrayBuffers'] as num).toInt(),
    );

Map<String, dynamic> _$MemoryUsageToJson(MemoryUsage instance) =>
    <String, dynamic>{
      'rss': instance.rss,
      'heapTotal': instance.heapTotal,
      'heapUsed': instance.heapUsed,
      'external': instance.external,
      'arrayBuffers': instance.arrayBuffers,
    };
