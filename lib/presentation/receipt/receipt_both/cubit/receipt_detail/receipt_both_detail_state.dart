import '../../../../../data/model/pallet.dart';

class ReceiptBothDetailState {
  final List<Pallet> products;
  int lotsTotalDone;

  ReceiptBothDetailState({
    required this.products,
    this.lotsTotalDone = 0,
  });

  copyWith({
    List<Pallet>? products,
    int? lotsTotalDone,
  }) {
    return ReceiptBothDetailState(
      products: products ?? this.products,
      lotsTotalDone: lotsTotalDone ?? this.lotsTotalDone,
    );
  }
}
