// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../common/theme/color/color_name.dart';
import 'product.dart';

class CheckInModel {
  int id;
  String name;
  String status;
  String packageName;
  String packageStatus;
  String dateTime;
  String destination;
  Color statusColor;
  List<Product> products;

  CheckInModel({
    required this.id,
    required this.name,
    required this.status,
    required this.packageName,
    required this.packageStatus,
    required this.dateTime,
    required this.destination,
    required this.statusColor,
    required this.products,
  });

  CheckInModel copyWith({
    int? id,
    String? name,
    String? status,
    String? packageName,
    String? packageStatus,
    String? dateTime,
    String? destination,
    Color? statusColor,
    List<Product>? products,
  }) {
    return CheckInModel(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      packageName: packageName ?? this.packageName,
      packageStatus: packageStatus ?? this.packageStatus,
      dateTime: dateTime ?? this.dateTime,
      destination: destination ?? this.destination,
      statusColor: statusColor ?? this.statusColor,
      products: products ?? this.products,
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
      'products': products.map((x) => x.toMap()).toList(),
    };
  }

  factory CheckInModel.fromMap(Map<String, dynamic> map) {
    return CheckInModel(
      id: map['id'] as int,
      name: map['name'] as String,
      status: map['status'] as String,
      packageName: map['packageName'] as String,
      packageStatus: map['packageStatus'] as String,
      dateTime: map['dateTime'] as String,
      destination: map['destination'] as String,
      statusColor: Color(map['statusColor'] as int),
      products: List<Product>.from(
        (map['products'] as List<int>).map<Product>(
          (x) => Product.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory CheckInModel.fromJson(String source) =>
      CheckInModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CheckInModel(id: $id, name: $name, status: $status, packageName: $packageName, packageStatus: $packageStatus, dateTime: $dateTime, destination: $destination, statusColor: $statusColor, products: $products)';
  }

  @override
  bool operator ==(covariant CheckInModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.status == status &&
        other.packageName == packageName &&
        other.packageStatus == packageStatus &&
        other.dateTime == dateTime &&
        other.destination == destination &&
        other.statusColor == statusColor &&
        listEquals(other.products, products);
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
        statusColor.hashCode ^
        products.hashCode;
  }
}

List<CheckInModel> _checkInList = [
  CheckInModel(
      id: 1,
      name: "WH/INT/00139",
      status: "Ready",
      statusColor: ColorName.readyColor,
      packageName: "Package: Pallet",
      packageStatus: "Tracking: Lots",
      dateTime: "07/07/2024 - 15:37",
      destination: "To: Medical Storage",
      products: [
        Product(
          id: 1,
          name: "Surgical Masks",
          sku: "",
          reason: "",
          location: "",
        ),
        Product(
          id: 2,
          name: "Medical Gloves",
          sku: "",
          reason: "",
          location: "",
        ),
        Product(
          id: 3,
          name: "Latex",
          sku: "",
          reason: "",
          location: "",
        ),
        Product(
          id: 4,
          name: "Surgical Instruments",
          sku: "",
          reason: "",
          location: "",
        ),
        Product(
          id: 5,
          name: "N95 Mask",
          sku: "",
          reason: "",
          location: "",
        ),
      ]),
  // CheckInModel(
  //     id: 2,
  //     name: "WH/INT/00138",
  //     status: "Ready",
  //     statusColor: ColorName.readyColor,
  //     packageName: "Package: Pallet",
  //     packageStatus: "Tracking: No Tracking",
  //     dateTime: "16/06/2024 - 15:36",
  //     destination: "To: Medical Storage",
  //     products: [
  //       Product(
  //         id: 1,
  //         name: "Surgical Masks",
  //         sku: "",
  //         reason: "",
  //         location: "",
  //       ),
  //       Product(
  //         id: 2,
  //         name: "Surgical Instruments",
  //         sku: "",
  //         reason: "",
  //         location: "",
  //       ),
  //       Product(
  //         id: 3,
  //         name: "Latex",
  //         sku: "",
  //         reason: "",
  //         location: "",
  //       ),
  //     ]),
  CheckInModel(
      id: 6,
      name: "WH/INT/00138",
      status: "Waiting",
      statusColor: ColorName.waitingColor,
      packageName: "Package: Pallet",
      packageStatus: "Tracking: No Tracking",
      dateTime: "16/06/2024 - 15:36",
      destination: "To: Medical Storage",
      products: [
        Product(
          id: 1,
          name: "Surgical Masks",
          sku: "",
          reason: "",
          location: "",
        ),
        Product(
          id: 2,
          name: "Surgical Instruments",
          sku: "",
          reason: "",
          location: "",
        ),
        Product(
          id: 3,
          name: "Latex",
          sku: "",
          reason: "",
          location: "",
        ),
      ]),
  CheckInModel(
      id: 3,
      name: "WH/INT/00137",
      status: "Late",
      statusColor: ColorName.lateColor,
      packageName: "Package: Pallet",
      packageStatus: "Tracking: Lots",
      dateTime: "16/06/2024 - 15:36",
      destination: "To: Medical Storage",
      products: [
        Product(
          id: 1,
          name: "Surgical Masks",
          sku: "",
          reason: "",
          location: "",
        ),
        Product(
          id: 2,
          name: "Surgical Instruments",
          sku: "",
          reason: "",
          location: "",
        ),
        Product(
          id: 3,
          name: "Latex",
          sku: "",
          reason: "",
          location: "",
        ),
      ]),
  CheckInModel(
      id: 4,
      name: "WH/INT/00136",
      status: "Ready",
      statusColor: ColorName.readyColor,
      packageName: "Package: Pallet",
      packageStatus: "Tracking: Serial Number",
      dateTime: "16/06/2024 - 15:36",
      destination: "To: Medical Storage",
      products: [
        Product(
          id: 1,
          name: "Surgical Masks",
          sku: "",
          reason: "",
          location: "",
        ),
        Product(
          id: 2,
          name: "Surgical Instruments",
          sku: "",
          reason: "",
          location: "",
        ),
        Product(
          id: 3,
          name: "Latex",
          sku: "",
          reason: "",
          location: "",
        ),
      ]),
  CheckInModel(
      id: 5,
      name: "WH/INT/00135",
      status: "Waiting",
      statusColor: ColorName.waitingColor,
      packageName: "Package: Pallet",
      packageStatus: "Tracking: Serial Number",
      dateTime: "16/06/2024 - 15:36",
      destination: "To: Medical Storage",
      products: [
        Product(
          id: 1,
          name: "Surgical Masks",
          sku: "",
          reason: "",
          location: "",
        ),
        Product(
          id: 2,
          name: "Medical Gloves",
          sku: "",
          reason: "",
          location: "",
        ),
        Product(
          id: 3,
          name: "Latex",
          sku: "",
          reason: "",
          location: "",
        ),
      ]),
];

List<CheckInModel> get listOfCheckIn => _checkInList;
