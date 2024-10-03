// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:inventory_v3/data/model/pallet.dart';

class Product {
  int id;
  String name;
  String sku;
  List<SerialNumber>? serialNumbers;
  String reason;
  String location;

  Product({
    required this.id,
    required this.name,
    required this.sku,
    this.serialNumbers,
    required this.reason,
    required this.location,
  });

  Product copyWith({
    int? id,
    String? name,
    String? sku,
    List<SerialNumber>? serialNumbers,
    String? reason,
    String? location,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      sku: sku ?? this.sku,
      serialNumbers: serialNumbers ?? this.serialNumbers,
      reason: reason ?? this.reason,
      location: location ?? this.location,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'sku': sku,
      'serialNumbers': serialNumbers?.map((x) => x.toMap()).toList(),
      'reason': reason,
      'location': location,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as int,
      name: map['name'] as String,
      sku: map['sku'] as String,
      serialNumbers: map['serialNumbers'] != null
          ? List<SerialNumber>.from(
              (map['serialNumbers'] as List<int>).map<SerialNumber?>(
                (x) => SerialNumber.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      reason: map['reason'] as String,
      location: map['location'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Product(id: $id, name: $name, sku: $sku, serialNumbers: $serialNumbers, reason: $reason, location: $location)';
  }

  @override
  bool operator ==(covariant Product other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.sku == sku &&
        listEquals(other.serialNumbers, serialNumbers) &&
        other.reason == reason &&
        other.location == location;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        sku.hashCode ^
        serialNumbers.hashCode ^
        reason.hashCode ^
        location.hashCode;
  }
}
