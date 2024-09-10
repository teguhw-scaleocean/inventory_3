// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:inventory_v3/data/model/product.dart';

class ProductMenuProductDetailState {
  List<Product> products;
  Product? product;

  ProductMenuProductDetailState({
    required this.products,
    this.product,
  });

  copyWith({List<Product>? products, Product? product}) {
    return ProductMenuProductDetailState(
      products: products ?? this.products,
      product: product ?? this.product,
    );
  }
}
