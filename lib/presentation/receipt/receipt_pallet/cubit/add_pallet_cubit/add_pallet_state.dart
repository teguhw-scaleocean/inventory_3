import 'package:inventory_v3/data/model/pallet.dart';

class AddPalletState {
  List<Pallet> products;

  AddPalletState({required this.products});

  AddPalletState copyWith({List<Pallet>? products}) =>
      AddPalletState(products: products ?? this.products);
}
