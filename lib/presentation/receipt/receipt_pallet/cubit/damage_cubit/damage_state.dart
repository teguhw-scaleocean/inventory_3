import 'package:inventory_v3/data/model/product.dart';

class DamageState {
  bool? isDamagePalletIncSn;
  bool? isDamagePalletIncLots;
  bool? isDamagePalletIncNoTracking;
  bool? isDamageProductSn;
  bool? isDamageProductLots;
  Product? damageProduct;

  DamageState({
    this.isDamagePalletIncSn,
    this.isDamagePalletIncLots,
    this.isDamagePalletIncNoTracking,
    this.isDamageProductSn,
    this.isDamageProductLots,
    this.damageProduct,
  });

  copyWith(
      {bool? isDamagePalletIncSn,
      bool? isDamagePalletIncLots,
      bool? isDamagePalletIncNoTracking,
      bool? isDamageProductSn,
      bool? isDamageProductLots,
      Product? damageProduct}) {
    return DamageState(
      isDamagePalletIncSn: isDamagePalletIncSn ?? this.isDamagePalletIncSn,
      isDamagePalletIncLots:
          isDamagePalletIncLots ?? this.isDamagePalletIncLots,
      isDamagePalletIncNoTracking:
          isDamagePalletIncNoTracking ?? this.isDamagePalletIncNoTracking,
      isDamageProductSn: isDamageProductSn ?? this.isDamageProductSn,
      isDamageProductLots: isDamageProductLots ?? this.isDamageProductLots,
      damageProduct: damageProduct ?? this.damageProduct,
    );
  }
}
