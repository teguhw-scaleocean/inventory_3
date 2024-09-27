// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

// import 'package:inventory_v3/data/model/product.dart';

// class PalletValue {
//   int id;
//   int palletId;
//   Product
// }

class PalletValue {
  int id;
  String code;
  PalletValue({
    required this.id,
    required this.code,
  });

  PalletValue copyWith({
    int? id,
    String? code,
  }) {
    return PalletValue(
      id: id ?? this.id,
      code: code ?? this.code,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'code': code,
    };
  }

  factory PalletValue.fromMap(Map<String, dynamic> map) {
    return PalletValue(
      id: map['id'] as int,
      code: map['code'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PalletValue.fromJson(String source) =>
      PalletValue.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'PalletValue(id: $id, code: $code)';

  @override
  bool operator ==(covariant PalletValue other) {
    if (identical(this, other)) return true;

    return other.id == id && other.code == code;
  }

  @override
  int get hashCode => id.hashCode ^ code.hashCode;
}

List<PalletValue> pallets = [
  PalletValue(id: 1, code: "A490"),
  PalletValue(id: 2, code: "A491"),
  PalletValue(id: 3, code: "A492"),
  PalletValue(id: 4, code: "A493"),
  PalletValue(id: 5, code: "A494"),
  PalletValue(id: 6, code: "A495"),
  PalletValue(id: 7, code: "A496"),
  PalletValue(id: 8, code: "A497"),
  PalletValue(id: 9, code: "A498"),
  PalletValue(id: 10, code: "A499"),
  PalletValue(id: 11, code: "A4900"),
  PalletValue(id: 12, code: "A4901"),
  PalletValue(id: 13, code: "A4902"),
  PalletValue(id: 14, code: "A4903"),
  PalletValue(id: 15, code: "A4904"),
  PalletValue(id: 16, code: "A4905"),
  PalletValue(id: 17, code: "A4906"),
  PalletValue(id: 18, code: "A4907"),
  PalletValue(id: 19, code: "A4908"),
  PalletValue(id: 20, code: "A4909"),
  PalletValue(id: 21, code: "A4910"),
];
