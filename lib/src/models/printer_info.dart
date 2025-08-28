import 'package:json_annotation/json_annotation.dart';

part 'printer_info.g.dart';

/// Information about a printer
@JsonSerializable()
class PrinterInfo {
  /// Printer name
  final String name;

  /// Printer port name
  final String? portName;

  /// Printer IP address (for network printers)
  final String? ipAddress;

  /// Printer MAC address
  final String? macAddress;

  /// Printer driver name
  final String? driverName;

  /// Printer location
  final String? location;

  /// Printer comment/description
  final String? comment;

  const PrinterInfo({
    required this.name,
    this.portName,
    this.ipAddress,
    this.macAddress,
    this.driverName,
    this.location,
    this.comment,
  });

  /// Create PrinterInfo from JSON
  factory PrinterInfo.fromJson(Map<String, dynamic> json) =>
      _$PrinterInfoFromJson(json);

  /// Convert PrinterInfo to JSON
  Map<String, dynamic> toJson() => _$PrinterInfoToJson(this);

  /// Create a copy of PrinterInfo with updated fields
  PrinterInfo copyWith({
    String? name,
    String? portName,
    String? ipAddress,
    String? macAddress,
    String? driverName,
    String? location,
    String? comment,
  }) {
    return PrinterInfo(
      name: name ?? this.name,
      portName: portName ?? this.portName,
      ipAddress: ipAddress ?? this.ipAddress,
      macAddress: macAddress ?? this.macAddress,
      driverName: driverName ?? this.driverName,
      location: location ?? this.location,
      comment: comment ?? this.comment,
    );
  }

  /// Check if this is a network printer
  bool get isNetworkPrinter => ipAddress != null && ipAddress!.isNotEmpty;

  /// Get display name with location if available
  String get displayName {
    if (location != null && location!.isNotEmpty) {
      return '$name ($location)';
    }
    return name;
  }

  @override
  String toString() {
    return 'PrinterInfo(name: $name, portName: $portName, ipAddress: $ipAddress, location: $location)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PrinterInfo &&
        other.name == name &&
        other.portName == portName &&
        other.ipAddress == ipAddress &&
        other.macAddress == macAddress &&
        other.driverName == driverName &&
        other.location == location &&
        other.comment == comment;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        portName.hashCode ^
        ipAddress.hashCode ^
        macAddress.hashCode ^
        driverName.hashCode ^
        location.hashCode ^
        comment.hashCode;
  }
}
