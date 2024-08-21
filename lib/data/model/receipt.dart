// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

class Receipt {
  int id;
  String name;
  String status;
  String packageName;
  String packageStatus;
  String dateTime;
  String destination;
  Color statusColor;

  Receipt({
    required this.id,
    required this.name,
    required this.status,
    required this.packageName,
    required this.packageStatus,
    required this.dateTime,
    required this.destination,
    required this.statusColor,
  });

  Receipt copyWith({
    int? id,
    String? name,
    String? status,
    String? packageName,
    String? packageStatus,
    String? dateTime,
    String? destination,
    Color? statusColor,
  }) {
    return Receipt(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      packageName: packageName ?? this.packageName,
      packageStatus: packageStatus ?? this.packageStatus,
      dateTime: dateTime ?? this.dateTime,
      destination: destination ?? this.destination,
      statusColor: statusColor ?? this.statusColor,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'status': status,
      'packageName': packageName,
      'packageStatus': packageStatus,
      'dateTime': dateTime,
      'destination': destination,
      'statusColor': statusColor.value,
    };
  }

  factory Receipt.fromMap(Map<String, dynamic> map) {
    return Receipt(
      id: map['id'] as int,
      name: map['name'] as String,
      status: map['status'] as String,
      packageName: map['packageName'] as String,
      packageStatus: map['packageStatus'] as String,
      dateTime: map['dateTime'] as String,
      destination: map['destination'] as String,
      statusColor: Color(map['statusColor'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory Receipt.fromJson(String source) =>
      Receipt.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Receipt(id: $id, name: $name, status: $status, packageName: $packageName, packageStatus: $packageStatus, dateTime: $dateTime, destination: $destination, statusColor: $statusColor)';
  }

  @override
  bool operator ==(covariant Receipt other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.status == status &&
        other.packageName == packageName &&
        other.packageStatus == packageStatus &&
        other.dateTime == dateTime &&
        other.destination == destination &&
        other.statusColor == statusColor;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        status.hashCode ^
        packageName.hashCode ^
        packageStatus.hashCode ^
        dateTime.hashCode ^
        destination.hashCode ^
        statusColor.hashCode;
  }
}
