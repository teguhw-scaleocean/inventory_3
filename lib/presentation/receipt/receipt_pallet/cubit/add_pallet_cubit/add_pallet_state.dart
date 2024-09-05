import 'package:inventory_v3/data/model/product.dart';

class AddPalletState {
  List<Product> products;

  AddPalletState({required this.products});

  AddPalletState copyWith({List<Product>? products}) =>
      AddPalletState(products: products ?? this.products);
}
