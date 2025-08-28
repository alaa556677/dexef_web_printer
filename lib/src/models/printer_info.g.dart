// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'printer_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrinterInfo _$PrinterInfoFromJson(Map<String, dynamic> json) => PrinterInfo(
      name: json['name'] as String,
      portName: json['portName'] as String?,
      ipAddress: json['ipAddress'] as String?,
      macAddress: json['macAddress'] as String?,
      driverName: json['driverName'] as String?,
      location: json['location'] as String?,
      comment: json['comment'] as String?,
    );

Map<String, dynamic> _$PrinterInfoToJson(PrinterInfo instance) =>
    <String, dynamic>{
      'name': instance.name,
      if (instance.portName case final value?) 'portName': value,
      if (instance.ipAddress case final value?) 'ipAddress': value,
      if (instance.macAddress case final value?) 'macAddress': value,
      if (instance.driverName case final value?) 'driverName': value,
      if (instance.location case final value?) 'location': value,
      if (instance.comment case final value?) 'comment': value,
    };
