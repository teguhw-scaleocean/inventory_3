// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:inventory_v3/data/model/product.dart';

class ProductMenuProductDetailState {
  List<Product> products;
  List<SerialNumber> serialNumbers;
  Product? product;
  int? totalToDone;
  // Lots
  int? lotsTotalDone;
  bool? isDoneQty;

  ProductMenuProductDetailState({
    required this.products,
    required this.serialNumbers,
    this.product,
    this.totalToDone,
    this.lotsTotalDone,
    this.isDoneQty,
  });

  copyWith({
    List<Product>? products,
    List<SerialNumber>? serialNumbers,
    Product? product,
    int? totalToDone,
    int? lotsTotalDone,
    bool? isDoneQty,
  }) {
    return ProductMenuProductDetailState(
      products: products ?? this.products,
      serialNumbers: serialNumbers ?? this.serialNumbers,
      product: product ?? this.product,
      totalToDone: totalToDone ?? this.totalToDone,
      lotsTotalDone: lotsTotalDone ?? this.lotsTotalDone,
      isDoneQty: isDoneQty ?? this.isDoneQty,
    );
  }
}
