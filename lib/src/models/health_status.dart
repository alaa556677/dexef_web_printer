import 'package:json_annotation/json_annotation.dart';

part 'health_status.g.dart';

/// System health status information
@JsonSerializable()
class HealthStatus {
  /// System status (usually "ok")
  final String status;

  /// Application version
  final String version;

  /// Operating system platform
  final String os;

  /// System architecture
  final String arch;

  /// System uptime in seconds
  final double uptime;

  /// Memory usage information
  final MemoryUsage memory;

  const HealthStatus({
    required this.status,
    required this.version,
    required this.os,
    required this.arch,
    required this.uptime,
    required this.memory,
  });

  /// Create HealthStatus from JSON
  factory HealthStatus.fromJson(Map<String, dynamic> json) =>
      _$HealthStatusFromJson(json);

  /// Convert HealthStatus to JSON
  Map<String, dynamic> toJson() => _$HealthStatusToJson(this);

  /// Create a copy of HealthStatus with updated fields
  HealthStatus copyWith({
    String? status,
    String? version,
    String? os,
    String? arch,
    double? uptime,
    MemoryUsage? memory,
  }) {
    return HealthStatus(
      status: status ?? this.status,
      version: version ?? this.version,
      os: os ?? this.os,
      arch: arch ?? this.arch,
      uptime: uptime ?? this.uptime,
      memory: memory ?? this.memory,
    );
  }

  @override
  String toString() {
    return 'HealthStatus(status: $status, version: $version, os: $os, arch: $arch, uptime: $uptime, memory: $memory)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HealthStatus &&
        other.status == status &&
        other.version == version &&
        other.os == os &&
        other.arch == arch &&
        other.uptime == uptime &&
        other.memory == memory;
  }

  @override
  int get hashCode {
    return status.hashCode ^
        version.hashCode ^
        os.hashCode ^
        arch.hashCode ^
        uptime.hashCode ^
        memory.hashCode;
  }
}

/// Memory usage information
@JsonSerializable()
class MemoryUsage {
  /// Resident Set Size in bytes
  final int rss;

  /// Total heap size in bytes
  final int heapTotal;

  /// Used heap size in bytes
  final int heapUsed;

  /// External memory in bytes
  final int external;

  /// Array buffers size in bytes
  final int arrayBuffers;

  const MemoryUsage({
    required this.rss,
    required this.heapTotal,
    required this.heapUsed,
    required this.external,
    required this.arrayBuffers,
  });

  /// Create MemoryUsage from JSON
  factory MemoryUsage.fromJson(Map<String, dynamic> json) =>
      _$MemoryUsageFromJson(json);

  /// Convert MemoryUsage to JSON
  Map<String, dynamic> toJson() => _$MemoryUsageToJson(this);

  /// Get memory usage in MB
  double get rssMB => rss / (1024 * 1024);
  double get heapTotalMB => heapTotal / (1024 * 1024);
  double get heapUsedMB => heapUsed / (1024 * 1024);
  double get externalMB => external / (1024 * 1024);

  @override
  String toString() {
    return 'MemoryUsage(rss: ${rssMB.toStringAsFixed(2)}MB, heapTotal: ${heapTotalMB.toStringAsFixed(2)}MB, heapUsed: ${heapUsedMB.toStringAsFixed(2)}MB)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MemoryUsage &&
        other.rss == rss &&
        other.heapTotal == heapTotal &&
        other.heapUsed == heapUsed &&
        other.external == external &&
        other.arrayBuffers == arrayBuffers;
  }

  @override
  int get hashCode {
    return rss.hashCode ^
        heapTotal.hashCode ^
        heapUsed.hashCode ^
        external.hashCode ^
        arrayBuffers.hashCode;
  }
}
