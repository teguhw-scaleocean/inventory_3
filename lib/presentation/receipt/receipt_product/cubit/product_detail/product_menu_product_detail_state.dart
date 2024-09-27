// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:inventory_v3/data/model/pallet.dart';

class ProductMenuProductDetailState {
  List<Pallet> pallets;
  List<SerialNumber> serialNumbers;
  Pallet? product;
  int? totalToDone;
  // Lots
  int? lotsTotalDone;
  int? updateTotal;
  int? snTotalDone;
  bool? isDoneQty;

  ProductMenuProductDetailState({
    required this.pallets,
    required this.serialNumbers,
    this.product,
    this.totalToDone,
    this.lotsTotalDone,
    this.updateTotal,
    this.snTotalDone,
    this.isDoneQty,
  });

  copyWith({
    List<Pallet>? pallets,
    List<SerialNumber>? serialNumbers,
    Pallet? product,
    int? totalToDone,
    int? lotsTotalDone,
    int? updateTotal,
    int? snTotalDone,
    bool? isDoneQty,
  }) {
    return ProductMenuProductDetailState(
      pallets: pallets ?? this.pallets,
      serialNumbers: serialNumbers ?? this.serialNumbers,
      product: product ?? this.product,
      totalToDone: totalToDone ?? this.totalToDone,
      lotsTotalDone: lotsTotalDone ?? this.lotsTotalDone,
      updateTotal: updateTotal ?? this.updateTotal,
      snTotalDone: snTotalDone ?? this.snTotalDone,
      isDoneQty: isDoneQty ?? this.isDoneQty,
    );
  }
}
