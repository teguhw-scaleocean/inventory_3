import 'package:inventory_v3/data/model/product.dart';

class DamageState {
  bool? isDamagePalletIncSn;
  bool? isDamagePalletIncLots;
  bool? isDamagePalletIncNoTracking;
  Product? damageProduct;

  DamageState({
    this.isDamagePalletIncSn,
    this.isDamagePalletIncLots,
    this.isDamagePalletIncNoTracking,
    this.damageProduct,
  });

  copyWith(
      {bool? isDamagePalletIncSn,
      bool? isDamagePalletIncLots,
      bool? isDamagePalletIncNoTracking,
      Product? damageProduct}) {
    return DamageState(
      isDamagePalletIncSn: isDamagePalletIncSn ?? this.isDamagePalletIncSn,
      isDamagePalletIncLots:
          isDamagePalletIncLots ?? this.isDamagePalletIncLots,
      isDamagePalletIncNoTracking:
          isDamagePalletIncNoTracking ?? this.isDamagePalletIncNoTracking,
      damageProduct: damageProduct ?? this.damageProduct,
    );
  }
}
