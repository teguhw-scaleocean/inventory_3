// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:inventory_v3/data/model/product.dart';

class ProductMenuProductDetailState {
  List<Product> products;
  Product? product;
  int? totalToDone;
  // Lots
  int? lotsTotalDone;

  ProductMenuProductDetailState({
    required this.products,
    this.product,
    this.totalToDone,
    this.lotsTotalDone,
  });

  copyWith(
      {List<Product>? products,
      Product? product,
      int? totalToDone,
      int? lotsTotalDone}) {
    return ProductMenuProductDetailState(
      products: products ?? this.products,
      product: product ?? this.product,
      totalToDone: totalToDone ?? this.totalToDone,
      lotsTotalDone: lotsTotalDone ?? this.lotsTotalDone,
    );
  }
}
