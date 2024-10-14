// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:inventory_v3/data/model/product.dart';

import 'return_product.dart';

class Pallet {
  int id;
  String palletCode;
  String productName;
  String code;
  String dateTime;
  bool? hasActualDateTime;
  String? actualDateTime;
  String? sku;
  String? lotsCode;
  double productQty;
  double? doneQty;
  double? notDoneQty;
  double? returnQty;
  double? damagedQty;
  bool? isDoneQty;
  bool? hasBeenScanned;
  bool? isReturn;
  bool? isDamage;
  bool? isDamagePalletAndProduct;
  bool? isDamageProduct;
  bool? isReturnPalletAndProduct;
  List<SerialNumber>? serialNumber;
  List<SerialNumber>? scannedSerialNumber;
  List<Product>? productReturn;
  List<ReturnProduct>? returnProductNoTracking;
  List<ReturnProduct>? damagedProducts;
  Product? damageProducts;

  Pallet({
    required this.id,
    required this.palletCode,
    required this.productName,
    required this.code,
    required this.dateTime,
    this.hasActualDateTime,
    this.actualDateTime,
    this.sku,
    this.lotsCode,
    required this.productQty,
    this.doneQty,
    this.notDoneQty,
    this.returnQty,
    this.damagedQty,
    this.isDoneQty,
    this.hasBeenScanned,
    this.isReturn,
    this.isDamage,
    this.isDamagePalletAndProduct,
    this.isDamageProduct,
    this.isReturnPalletAndProduct,
    this.serialNumber,
    this.scannedSerialNumber,
    this.productReturn,
    this.returnProductNoTracking,
    this.damagedProducts,
    this.damageProducts,
  });

  Pallet copyWith({
    int? id,
    String? palletCode,
    String? productName,
    String? code,
    String? dateTime,
    bool? hasActualDateTime,
    String? actualDateTime,
    String? sku,
    String? lotsCode,
    double? productQty,
    double? doneQty,
    double? notDoneQty,
    double? returnQty,
    double? damagedQty,
    bool? isDoneQty,
    bool? hasBeenScanned,
    bool? isReturn,
    bool? isDamage,
    bool? isDamagePalletAndProduct,
    bool? isDamageProduct,
    bool? isReturnPalletAndProduct,
    List<SerialNumber>? serialNumber,
    List<SerialNumber>? scannedSerialNumber,
    List<Product>? productReturn,
    List<ReturnProduct>? returnProductNoTracking,
    List<ReturnProduct>? damagedProducts,
    Product? damageProducts,
  }) {
    return Pallet(
      id: id ?? this.id,
      palletCode: palletCode ?? this.palletCode,
      productName: productName ?? this.productName,
      code: code ?? this.code,
      dateTime: dateTime ?? this.dateTime,
      hasActualDateTime: hasActualDateTime ?? this.hasActualDateTime,
      actualDateTime: actualDateTime ?? this.actualDateTime,
      sku: sku ?? this.sku,
      lotsCode: lotsCode ?? this.lotsCode,
      productQty: productQty ?? this.productQty,
      doneQty: doneQty ?? this.doneQty,
      notDoneQty: notDoneQty ?? this.notDoneQty,
      returnQty: returnQty ?? this.returnQty,
      damagedQty: damagedQty ?? this.damagedQty,
      isDoneQty: isDoneQty ?? this.isDoneQty,
      hasBeenScanned: hasBeenScanned ?? this.hasBeenScanned,
      isReturn: isReturn ?? this.isReturn,
      isDamage: isDamage ?? this.isDamage,
      isDamagePalletAndProduct:
          isDamagePalletAndProduct ?? this.isDamagePalletAndProduct,
      isDamageProduct: isDamageProduct ?? this.isDamageProduct,
      isReturnPalletAndProduct:
          isReturnPalletAndProduct ?? this.isReturnPalletAndProduct,
      serialNumber: serialNumber ?? this.serialNumber,
      scannedSerialNumber: scannedSerialNumber ?? this.scannedSerialNumber,
      productReturn: productReturn ?? this.productReturn,
      returnProductNoTracking:
          returnProductNoTracking ?? this.returnProductNoTracking,
      damagedProducts: damagedProducts ?? this.damagedProducts,
      damageProducts: damageProducts ?? this.damageProducts,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'palletCode': palletCode,
      'productName': productName,
      'code': code,
      'dateTime': dateTime,
      'hasActualDateTime': hasActualDateTime,
      'actualDateTime': actualDateTime,
      'sku': sku,
      'lotsCode': lotsCode,
      'productQty': productQty,
      'doneQty': doneQty,
      'notDoneQty': notDoneQty,
      'returnQty': returnQty,
      'damagedQty': damagedQty,
      'isDoneQty': isDoneQty,
      'hasBeenScanned': hasBeenScanned,
      'isReturn': isReturn,
      'isDamage': isDamage,
      'isDamagePalletAndProduct': isDamagePalletAndProduct,
      'isDamageProduct': isDamageProduct,
      'isReturnPalletAndProduct': isReturnPalletAndProduct,
      'serialNumber': serialNumber?.map((x) => x.toMap()).toList(),
      'scannedSerialNumber':
          scannedSerialNumber?.map((x) => x.toMap()).toList(),
      'productReturn': productReturn?.map((x) => x.toMap()).toList(),
      'returnProductNoTracking':
          returnProductNoTracking?.map((x) => x.toMap()).toList(),
      'damagedProducts': damagedProducts?.map((x) => x.toMap()).toList(),
      'damageProducts': damageProducts?.toMap(),
    };
  }

  factory Pallet.fromMap(Map<String, dynamic> map) {
    return Pallet(
      id: map['id'] as int,
      palletCode: map['palletCode'] as String,
      productName: map['productName'] as String,
      code: map['code'] as String,
      dateTime: map['dateTime'] as String,
      hasActualDateTime: map['hasActualDateTime'] != null
          ? map['hasActualDateTime'] as bool
          : null,
      actualDateTime: map['actualDateTime'] != null
          ? map['actualDateTime'] as String
          : null,
      sku: map['sku'] != null ? map['sku'] as String : null,
      lotsCode: map['lotsCode'] != null ? map['lotsCode'] as String : null,
      productQty: map['productQty'] as double,
      doneQty: map['doneQty'] != null ? map['doneQty'] as double : null,
      notDoneQty:
          map['notDoneQty'] != null ? map['notDoneQty'] as double : null,
      returnQty: map['returnQty'] != null ? map['returnQty'] as double : null,
      damagedQty:
          map['damagedQty'] != null ? map['damagedQty'] as double : null,
      isDoneQty: map['isDoneQty'] != null ? map['isDoneQty'] as bool : null,
      hasBeenScanned:
          map['hasBeenScanned'] != null ? map['hasBeenScanned'] as bool : null,
      isReturn: map['isReturn'] != null ? map['isReturn'] as bool : null,
      isDamage: map['isDamage'] != null ? map['isDamage'] as bool : null,
      isDamagePalletAndProduct: map['isDamagePalletAndProduct'] != null
          ? map['isDamagePalletAndProduct'] as bool
          : null,
      isDamageProduct: map['isDamageProduct'] != null
          ? map['isDamageProduct'] as bool
          : null,
      isReturnPalletAndProduct: map['isReturnPalletAndProduct'] != null
          ? map['isReturnPalletAndProduct'] as bool
          : null,
      serialNumber: map['serialNumber'] != null
          ? List<SerialNumber>.from(
              (map['serialNumber'] as List<int>).map<SerialNumber?>(
                (x) => SerialNumber.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      scannedSerialNumber: map['scannedSerialNumber'] != null
          ? List<SerialNumber>.from(
              (map['scannedSerialNumber'] as List<int>).map<SerialNumber?>(
                (x) => SerialNumber.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      productReturn: map['productReturn'] != null
          ? List<Product>.from(
              (map['productReturn'] as List<int>).map<Product?>(
                (x) => Product.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      returnProductNoTracking: map['returnProductNoTracking'] != null
          ? List<ReturnProduct>.from(
              (map['returnProductNoTracking'] as List<int>).map<ReturnProduct?>(
                (x) => ReturnProduct.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      damagedProducts: map['damagedProducts'] != null
          ? List<ReturnProduct>.from(
              (map['damagedProducts'] as List<int>).map<ReturnProduct?>(
                (x) => ReturnProduct.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      damageProducts: map['damageProducts'] != null
          ? Product.fromMap(map['damageProducts'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Pallet.fromJson(String source) =>
      Pallet.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Pallet(id: $id, palletCode: $palletCode, productName: $productName, code: $code, dateTime: $dateTime, hasActualDateTime: $hasActualDateTime, actualDateTime: $actualDateTime, sku: $sku, lotsCode: $lotsCode, productQty: $productQty, doneQty: $doneQty, notDoneQty: $notDoneQty, returnQty: $returnQty, damagedQty: $damagedQty, isDoneQty: $isDoneQty, hasBeenScanned: $hasBeenScanned, isReturn: $isReturn, isDamage: $isDamage, isDamagePalletAndProduct: $isDamagePalletAndProduct, isDamageProduct: $isDamageProduct, isReturnPalletAndProduct: $isReturnPalletAndProduct, serialNumber: $serialNumber, scannedSerialNumber: $scannedSerialNumber, productReturn: $productReturn, returnProductNoTracking: $returnProductNoTracking, damagedProducts: $damagedProducts, damageProducts: $damageProducts)';
  }

  @override
  bool operator ==(covariant Pallet other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.palletCode == palletCode &&
        other.productName == productName &&
        other.code == code &&
        other.dateTime == dateTime &&
        other.hasActualDateTime == hasActualDateTime &&
        other.actualDateTime == actualDateTime &&
        other.sku == sku &&
        other.lotsCode == lotsCode &&
        other.productQty == productQty &&
        other.doneQty == doneQty &&
        other.notDoneQty == notDoneQty &&
        other.returnQty == returnQty &&
        other.damagedQty == damagedQty &&
        other.isDoneQty == isDoneQty &&
        other.hasBeenScanned == hasBeenScanned &&
        other.isReturn == isReturn &&
        other.isDamage == isDamage &&
        other.isDamagePalletAndProduct == isDamagePalletAndProduct &&
        other.isDamageProduct == isDamageProduct &&
        other.isReturnPalletAndProduct == isReturnPalletAndProduct &&
        listEquals(other.serialNumber, serialNumber) &&
        listEquals(other.scannedSerialNumber, scannedSerialNumber) &&
        listEquals(other.productReturn, productReturn) &&
        listEquals(other.returnProductNoTracking, returnProductNoTracking) &&
        listEquals(other.damagedProducts, damagedProducts) &&
        other.damageProducts == damageProducts;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        palletCode.hashCode ^
        productName.hashCode ^
        code.hashCode ^
        dateTime.hashCode ^
        hasActualDateTime.hashCode ^
        actualDateTime.hashCode ^
        sku.hashCode ^
        lotsCode.hashCode ^
        productQty.hashCode ^
        doneQty.hashCode ^
        notDoneQty.hashCode ^
        returnQty.hashCode ^
        damagedQty.hashCode ^
        isDoneQty.hashCode ^
        hasBeenScanned.hashCode ^
        isReturn.hashCode ^
        isDamage.hashCode ^
        isDamagePalletAndProduct.hashCode ^
        isDamageProduct.hashCode ^
        isReturnPalletAndProduct.hashCode ^
        serialNumber.hashCode ^
        scannedSerialNumber.hashCode ^
        productReturn.hashCode ^
        returnProductNoTracking.hashCode ^
        damagedProducts.hashCode ^
        damageProducts.hashCode;
  }
}

class SerialNumber {
  int id;
  String label;
  String expiredDateTime;
  int quantity;
  bool? isInputDate;
  bool? isEditDate;

  SerialNumber({
    required this.id,
    required this.label,
    required this.expiredDateTime,
    required this.quantity,
    this.isInputDate,
    this.isEditDate,
  });

  SerialNumber copyWith({
    int? id,
    String? label,
    String? expiredDateTime,
    int? quantity,
    bool? isInputDate,
    bool? isEditDate,
  }) {
    return SerialNumber(
      id: id ?? this.id,
      label: label ?? this.label,
      expiredDateTime: expiredDateTime ?? this.expiredDateTime,
      quantity: quantity ?? this.quantity,
      isInputDate: isInputDate ?? this.isInputDate,
      isEditDate: isEditDate ?? this.isEditDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'label': label,
      'expiredDateTime': expiredDateTime,
      'quantity': quantity,
      'isInputDate': isInputDate,
      'isEditDate': isEditDate,
    };
  }

  factory SerialNumber.fromMap(Map<String, dynamic> map) {
    return SerialNumber(
      id: map['id'] as int,
      label: map['label'] as String,
      expiredDateTime: map['expiredDateTime'] as String,
      quantity: map['quantity'] as int,
      isInputDate:
          map['isInputDate'] != null ? map['isInputDate'] as bool : null,
      isEditDate: map['isEditDate'] != null ? map['isEditDate'] as bool : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SerialNumber.fromJson(String source) =>
      SerialNumber.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SerialNumber(id: $id, label: $label, expiredDateTime: $expiredDateTime, quantity: $quantity, isInputDate: $isInputDate, isEditDate: $isEditDate)';
  }

  @override
  bool operator ==(covariant SerialNumber other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.label == label &&
        other.expiredDateTime == expiredDateTime &&
        other.quantity == quantity &&
        other.isInputDate == isInputDate &&
        other.isEditDate == isEditDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        label.hashCode ^
        expiredDateTime.hashCode ^
        quantity.hashCode ^
        isInputDate.hashCode ^
        isEditDate.hashCode;
  }
}

List<Pallet> products = [
  Pallet(
    id: 1,
    palletCode: "A490",
    productName: "Surgical Instruments",
    code: "SUR_12942",
    dateTime: "Sch. Date: 12/07/2024 - 15:30",
    productQty: 11,
  ),
  Pallet(
    id: 2,
    palletCode: "A491",
    productName: "Surgical Masks",
    code: "MASK_12942 ",
    dateTime: "Sch. Date: 28/07/2024 - 14:00",
    productQty: 12,
  ),
  Pallet(
    id: 3,
    palletCode: "A492",
    productName: "Essence Mascara",
    code: "EM_12942",
    dateTime: "Sch. Date: 02/07/2024 - 14:00",
    productQty: 14,
  ),
];

List<Pallet> products2 = [
  Pallet(
    id: 1,
    palletCode: "A494",
    productName: "Syringes",
    code: "SY_12937",
    lotsCode: "SYR-LOTS-2842",
    dateTime: "Sch. Date: 12/07/2024 - 15:30",
    productQty: 11,
    notDoneQty: 11,
    doneQty: 0,
  ),
  Pallet(
    id: 2,
    palletCode: "A495",
    productName: "Surgical Masks",
    code: "MASK_12942 ",
    lotsCode: "LOTS-2024-002B",
    dateTime: "Sch. Date: 28/07/2024 - 14:00",
    productQty: 12,
    notDoneQty: 12,
    doneQty: 0,
  ),
  Pallet(
    id: 3,
    palletCode: "A496",
    productName: "Essence Mascara",
    code: "EM_12942",
    lotsCode: "LOTS-2024-003B",
    dateTime: "Sch. Date: 02/07/2024 - 14:00",
    productQty: 14,
    notDoneQty: 14,
    doneQty: 0,
  ),
];

// SN
List<Pallet> products3 = [
  Pallet(
    id: 1,
    palletCode: "A4910",
    productName: "Nebulizer Machine",
    sku: "BPM201-345",
    code: "NEB_14578",
    // lotsCode: "LOTS-2024-001A",
    dateTime: "Sch. Date: 12/07/2024 - 15:30",
    productQty: 12,
  ),
  Pallet(
    id: 2,
    palletCode: "A4912",
    productName: "Surgical Masks",
    sku: "BPM201-342",
    code: "MASK_12942 ",
    // lotsCode: "LOTS-2024-002A",
    dateTime: "Sch. Date: 28/07/2024 - 14:00",
    productQty: 11,
  ),
  Pallet(
    id: 3,
    palletCode: "A4920",
    productName: "Essence Mascara",
    sku: "BPM201-350",
    code: "EM_12944",
    // lotsCode: "LOTS-2024-003A",
    dateTime: "Sch. Date: 02/07/2024 - 14:00",
    productQty: 14,
  ),
];

List<Pallet> listPallets = <Pallet>[];
