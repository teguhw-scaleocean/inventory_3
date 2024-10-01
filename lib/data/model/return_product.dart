// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ReturnProduct {
  int id;
  String code;
  String reason;
  String location;
  int? quantity;

  ReturnProduct({
    required this.id,
    required this.code,
    required this.reason,
    required this.location,
    this.quantity,
  });

  ReturnProduct copyWith({
    int? id,
    String? code,
    String? reason,
    String? location,
    int? quantity,
  }) {
    return ReturnProduct(
      id: id ?? this.id,
      code: code ?? this.code,
      reason: reason ?? this.reason,
      location: location ?? this.location,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'code': code,
      'reason': reason,
      'location': location,
      'quantity': quantity,
    };
  }

  factory ReturnProduct.fromMap(Map<String, dynamic> map) {
    return ReturnProduct(
      id: map['id'] as int,
      code: map['code'] as String,
      reason: map['reason'] as String,
      location: map['location'] as String,
      quantity: map['quantity'] != null ? map['quantity'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReturnProduct.fromJson(String source) =>
      ReturnProduct.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ReturnProduct(id: $id, code: $code, reason: $reason, location: $location, quantity: $quantity)';
  }

  @override
  bool operator ==(covariant ReturnProduct other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.code == code &&
        other.reason == reason &&
        other.location == location &&
        other.quantity == quantity;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        code.hashCode ^
        reason.hashCode ^
        location.hashCode ^
        quantity.hashCode;
  }
}
