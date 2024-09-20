import '../../../../../data/model/product.dart';

class ReceiptBothDetailState {
  final List<Product> products;
  int? lotsTotalDone = 0;

  ReceiptBothDetailState({
    required this.products,
    this.lotsTotalDone,
  });

  copyWith({
    List<Product>? products,
    int? lotsTotalDone,
  }) {
    return ReceiptBothDetailState(
      products: products ?? this.products,
      lotsTotalDone: lotsTotalDone ?? this.lotsTotalDone,
    );
  }
}
