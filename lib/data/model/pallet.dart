// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

// import 'package:inventory_v3/data/model/product.dart';

// class Pallet {
//   int id;
//   int palletId;
//   Product
// }

class Pallet {
  int id;
  String code;
  Pallet({
    required this.id,
    required this.code,
  });

  Pallet copyWith({
    int? id,
    String? code,
  }) {
    return Pallet(
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

  factory Pallet.fromMap(Map<String, dynamic> map) {
    return Pallet(
      id: map['id'] as int,
      code: map['code'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Pallet.fromJson(String source) =>
      Pallet.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Pallet(id: $id, code: $code)';

  @override
  bool operator ==(covariant Pallet other) {
    if (identical(this, other)) return true;

    return other.id == id && other.code == code;
  }

  @override
  int get hashCode => id.hashCode ^ code.hashCode;
}

List<Pallet> pallets = [
  Pallet(id: 1, code: "A490"),
  Pallet(id: 2, code: "A491"),
  Pallet(id: 3, code: "A492"),
  Pallet(id: 4, code: "A493"),
  Pallet(id: 5, code: "A494"),
  Pallet(id: 6, code: "A495"),
  Pallet(id: 7, code: "A496"),
  Pallet(id: 8, code: "A497"),
  Pallet(id: 9, code: "A498"),
  Pallet(id: 10, code: "A499"),
  Pallet(id: 11, code: "A4900"),
  Pallet(id: 12, code: "A4901"),
  Pallet(id: 13, code: "A4902"),
  Pallet(id: 14, code: "A4903"),
  Pallet(id: 15, code: "A4904"),
  Pallet(id: 16, code: "A4905"),
  Pallet(id: 17, code: "A4906"),
  Pallet(id: 18, code: "A4907"),
  Pallet(id: 19, code: "A4908"),
  Pallet(id: 20, code: "A4909"),
  Pallet(id: 21, code: "A4910"),
];
