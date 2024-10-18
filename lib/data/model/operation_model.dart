// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

import '../../common/constants/local_images.dart';
import '../../common/theme/color/color_name.dart';

class OperationModel {
  int id;
  String name;
  int total;
  String imgPath;
  Color color;

  OperationModel({
    required this.id,
    required this.name,
    required this.total,
    required this.imgPath,
    required this.color,
  });

  OperationModel copyWith({
    int? id,
    String? name,
    int? total,
    String? imgPath,
    Color? color,
  }) {
    return OperationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      total: total ?? this.total,
      imgPath: imgPath ?? this.imgPath,
      color: color ?? this.color,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'total': total,
      'imgPath': imgPath,
      'color': color.value,
    };
  }

  factory OperationModel.fromMap(Map<String, dynamic> map) {
    return OperationModel(
      id: map['id'] as int,
      name: map['name'] as String,
      total: map['total'] as int,
      imgPath: map['imgPath'] as String,
      color: Color(map['color'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory OperationModel.fromJson(String source) =>
      OperationModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'OperationModel(id: $id, name: $name, total: $total, imgPath: $imgPath, color: $color)';
  }

  @override
  bool operator ==(covariant OperationModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.total == total &&
        other.imgPath == imgPath &&
        other.color == color;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        total.hashCode ^
        imgPath.hashCode ^
        color.hashCode;
  }
}

List<OperationModel> _operations = [
  OperationModel(
    id: 1,
    name: "Receipt",
    total: 16,
    imgPath: LocalImages.receiptIcon,
    color: ColorName.receiptColor,
  ),
  OperationModel(
    id: 2,
    name: "Quality Control",
    total: 24,
    imgPath: LocalImages.qualityControlIcon,
    color: ColorName.qualitControlColor,
  ),
  OperationModel(
    id: 3,
    name: "Check-in",
    total: 16,
    imgPath: LocalImages.checkInIcon,
    color: ColorName.checkInColor,
  ),
  OperationModel(
    id: 4,
    name: "Pick",
    total: 30,
    imgPath: LocalImages.pickIcon,
    color: ColorName.pickColor,
  ),
  OperationModel(
    id: 5,
    name: "Pack",
    total: 23,
    imgPath: LocalImages.packIcon,
    color: ColorName.packColor,
  ),
  OperationModel(
    id: 6,
    name: "Delivery Order",
    total: 10,
    imgPath: LocalImages.deliveryOrderIcon,
    color: ColorName.deliveryOrderColor,
  ),
];

List<OperationModel> get listOfOperation => _operations;
