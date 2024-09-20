import '../../../../../data/model/product.dart';

class ReceiptBothDetailState {
  final List<Product> products;
  int lotsTotalDone;

  ReceiptBothDetailState({
    required this.products,
    this.lotsTotalDone = 0,
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
