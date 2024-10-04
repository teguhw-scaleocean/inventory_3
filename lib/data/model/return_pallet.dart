// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'product.dart';
import 'return_product.dart';

class ReturnPallet {
  int id;
  String palletCode;
  String reason;
  String location;
  // Sementara
  List<ReturnProduct>? returnProducts = [];
  Product? damageProducts;
  double? damageQty = 0.0;

  ReturnPallet({
    required this.id,
    required this.palletCode,
    required this.reason,
    required this.location,
    this.returnProducts,
    this.damageProducts,
    this.damageQty,
  });

  ReturnPallet copyWith({
    int? id,
    String? palletCode,
    String? reason,
    String? location,
    List<ReturnProduct>? returnProducts,
    Product? damageProducts,
    double? damageQty,
  }) {
    return ReturnPallet(
      id: id ?? this.id,
      palletCode: palletCode ?? this.palletCode,
      reason: reason ?? this.reason,
      location: location ?? this.location,
      returnProducts: returnProducts ?? this.returnProducts,
      damageProducts: damageProducts ?? this.damageProducts,
      damageQty: damageQty ?? this.damageQty,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'palletCode': palletCode,
      'reason': reason,
      'location': location,
      'returnProducts': returnProducts?.map((x) => x.toMap()).toList(),
      'damageProducts': damageProducts?.toMap(),
      'damageQty': damageQty,
    };
  }

  factory ReturnPallet.fromMap(Map<String, dynamic> map) {
    return ReturnPallet(
      id: map['id'] as int,
      palletCode: map['palletCode'] as String,
      reason: map['reason'] as String,
      location: map['location'] as String,
      returnProducts: map['returnProducts'] != null
          ? List<ReturnProduct>.from(
              (map['returnProducts'] as List<int>).map<ReturnProduct?>(
                (x) => ReturnProduct.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      damageProducts: map['damageProducts'] != null
          ? Product.fromMap(map['damageProducts'] as Map<String, dynamic>)
          : null,
      damageQty: map['damageQty'] != null ? map['damageQty'] as double : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReturnPallet.fromJson(String source) =>
      ReturnPallet.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ReturnPallet(id: $id, palletCode: $palletCode, reason: $reason, location: $location, returnProducts: $returnProducts, damageProducts: $damageProducts, damageQty: $damageQty)';
  }

  @override
  bool operator ==(covariant ReturnPallet other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.palletCode == palletCode &&
        other.reason == reason &&
        other.location == location &&
        listEquals(other.returnProducts, returnProducts) &&
        other.damageProducts == damageProducts &&
        other.damageQty == damageQty;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        palletCode.hashCode ^
        reason.hashCode ^
        location.hashCode ^
        returnProducts.hashCode ^
        damageProducts.hashCode ^
        damageQty.hashCode;
  }
}
