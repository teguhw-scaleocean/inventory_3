// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class Product {
  int id;
  String palletCode;
  String productName;
  String code;
  String dateTime;
  String? sku;
  String? lotsCode;
  int productQty;
  List<SerialNumber>? serialNumber;

  Product({
    required this.id,
    required this.palletCode,
    required this.productName,
    required this.code,
    required this.dateTime,
    this.sku,
    this.lotsCode,
    required this.productQty,
    this.serialNumber,
  });

  Product copyWith({
    int? id,
    String? palletCode,
    String? productName,
    String? code,
    String? dateTime,
    String? sku,
    String? lotsCode,
    int? productQty,
    List<SerialNumber>? serialNumber,
  }) {
    return Product(
      id: id ?? this.id,
      palletCode: palletCode ?? this.palletCode,
      productName: productName ?? this.productName,
      code: code ?? this.code,
      dateTime: dateTime ?? this.dateTime,
      sku: sku ?? this.sku,
      lotsCode: lotsCode ?? this.lotsCode,
      productQty: productQty ?? this.productQty,
      serialNumber: serialNumber ?? this.serialNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'palletCode': palletCode,
      'productName': productName,
      'code': code,
      'dateTime': dateTime,
      'sku': sku,
      'lotsCode': lotsCode,
      'productQty': productQty,
      'serialNumber': serialNumber?.map((x) => x.toMap()).toList(),
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as int,
      palletCode: map['palletCode'] as String,
      productName: map['productName'] as String,
      code: map['code'] as String,
      dateTime: map['dateTime'] as String,
      sku: map['sku'] != null ? map['sku'] as String : null,
      lotsCode: map['lotsCode'] != null ? map['lotsCode'] as String : null,
      productQty: map['productQty'] as int,
      serialNumber: map['serialNumber'] != null
          ? List<SerialNumber>.from(
              (map['serialNumber'] as List<int>).map<SerialNumber?>(
                (x) => SerialNumber.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Product(id: $id, palletCode: $palletCode, productName: $productName, code: $code, dateTime: $dateTime, sku: $sku, lotsCode: $lotsCode, productQty: $productQty, serialNumber: $serialNumber)';
  }

  @override
  bool operator ==(covariant Product other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.palletCode == palletCode &&
        other.productName == productName &&
        other.code == code &&
        other.dateTime == dateTime &&
        other.sku == sku &&
        other.lotsCode == lotsCode &&
        other.productQty == productQty &&
        listEquals(other.serialNumber, serialNumber);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        palletCode.hashCode ^
        productName.hashCode ^
        code.hashCode ^
        dateTime.hashCode ^
        sku.hashCode ^
        lotsCode.hashCode ^
        productQty.hashCode ^
        serialNumber.hashCode;
  }
}

class SerialNumber {
  int id;
  String label;
  String expiredDateTime;
  int quantity;

  SerialNumber({
    required this.id,
    required this.label,
    required this.expiredDateTime,
    required this.quantity,
  });

  SerialNumber copyWith({
    int? id,
    String? label,
    String? expiredDateTime,
    int? quantity,
  }) {
    return SerialNumber(
      id: id ?? this.id,
      label: label ?? this.label,
      expiredDateTime: expiredDateTime ?? this.expiredDateTime,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'label': label,
      'expiredDateTime': expiredDateTime,
      'quantity': quantity,
    };
  }

  factory SerialNumber.fromMap(Map<String, dynamic> map) {
    return SerialNumber(
      id: map['id'] as int,
      label: map['label'] as String,
      expiredDateTime: map['expiredDateTime'] as String,
      quantity: map['quantity'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory SerialNumber.fromJson(String source) =>
      SerialNumber.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SerialNumber(id: $id, label: $label, expiredDateTime: $expiredDateTime, quantity: $quantity)';
  }

  @override
  bool operator ==(covariant SerialNumber other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.label == label &&
        other.expiredDateTime == expiredDateTime &&
        other.quantity == quantity;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        label.hashCode ^
        expiredDateTime.hashCode ^
        quantity.hashCode;
  }
}

List<Product> products = [
  Product(
    id: 1,
    palletCode: "A490",
    productName: "Surgical Instruments",
    code: "SUR_12942",
    dateTime: "Sch. Date: 12/07/2024 - 15:30",
    productQty: 11,
  ),
  Product(
    id: 2,
    palletCode: "A491",
    productName: "Surgical Masks",
    code: "MASK_12942 ",
    dateTime: "Sch. Date: 28/07/2024 - 14:00",
    productQty: 12,
  ),
  Product(
    id: 3,
    palletCode: "A492",
    productName: "Essence Mascara",
    code: "EM_12942",
    dateTime: "Sch. Date: 02/07/2024 - 14:00",
    productQty: 14,
  ),
];

List<Product> products2 = [
  Product(
    id: 1,
    palletCode: "A494",
    productName: "Nebulizer Machine",
    code: "NEB_14578",
    lotsCode: "LOTS-2024-001B",
    dateTime: "Sch. Date: 12/07/2024 - 15:30",
    productQty: 11,
  ),
  Product(
    id: 2,
    palletCode: "A495",
    productName: "Surgical Masks",
    code: "MASK_12942 ",
    lotsCode: "LOTS-2024-002B",
    dateTime: "Sch. Date: 28/07/2024 - 14:00",
    productQty: 12,
  ),
  Product(
    id: 3,
    palletCode: "A496",
    productName: "Essence Mascara",
    code: "EM_12942",
    lotsCode: "LOTS-2024-003B",
    dateTime: "Sch. Date: 02/07/2024 - 14:00",
    productQty: 14,
  ),
];

// SN
List<Product> products3 = [
  Product(
    id: 1,
    palletCode: "A4910",
    productName: "Nebulizer Machine",
    sku: "BPM201-345",
    code: "NEB_14578",
    // lotsCode: "LOTS-2024-001A",
    dateTime: "Sch. Date: 12/07/2024 - 15:30",
    productQty: 11,
  ),
  Product(
    id: 2,
    palletCode: "A4910",
    productName: "Surgical Masks",
    sku: "BPM201-346",
    code: "MASK_12942 ",
    // lotsCode: "LOTS-2024-002A",
    dateTime: "Sch. Date: 28/07/2024 - 14:00",
    productQty: 12,
  ),
  Product(
    id: 3,
    palletCode: "A4910",
    productName: "Essence Mascara",
    sku: "BPM201-347",
    code: "EM_12942",
    // lotsCode: "LOTS-2024-003A",
    dateTime: "Sch. Date: 02/07/2024 - 14:00",
    productQty: 14,
  ),
];

List<Product> listProducts = <Product>[];
