import 'package:inventory_v3/data/model/product.dart';

class DamageState {
  bool? isDamagePalletIncSn;
  Product? damageProduct;

  DamageState({this.isDamagePalletIncSn, this.damageProduct});

  copyWith({bool? isDamagePalletIncSn, Product? damageProduct}) {
    return DamageState(
      isDamagePalletIncSn: isDamagePalletIncSn ?? this.isDamagePalletIncSn,
      damageProduct: damageProduct ?? this.damageProduct,
    );
  }
}
