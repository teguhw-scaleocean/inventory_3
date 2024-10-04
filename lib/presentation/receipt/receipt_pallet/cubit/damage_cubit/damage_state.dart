import 'package:inventory_v3/data/model/product.dart';

class DamageState {
  bool? isDamagePalletIncSn;
  bool? isDamagePalletIncLots;
  Product? damageProduct;

  DamageState(
      {this.isDamagePalletIncSn,
      this.isDamagePalletIncLots,
      this.damageProduct});

  copyWith(
      {bool? isDamagePalletIncSn,
      bool? isDamagePalletIncLots,
      Product? damageProduct}) {
    return DamageState(
      isDamagePalletIncSn: isDamagePalletIncSn ?? this.isDamagePalletIncSn,
      isDamagePalletIncLots:
          isDamagePalletIncLots ?? this.isDamagePalletIncLots,
      damageProduct: damageProduct ?? this.damageProduct,
    );
  }
}
