import '../../../../../data/model/product.dart';

class ReceiptBothDetailState {
  final List<Product> products;

  ReceiptBothDetailState({required this.products});

  copyWith({
    List<Product>? products,
  }) {
    return ReceiptBothDetailState(
      products: products ?? this.products,
    );
  }
}
