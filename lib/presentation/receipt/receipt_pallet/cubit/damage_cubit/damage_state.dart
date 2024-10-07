import 'package:inventory_v3/data/model/product.dart';

class DamageState {
  bool? isDamagePalletIncSn;
  bool? isDamagePalletIncLots;
  bool? isDamagePalletIncNoTracking;
  bool? isDamageProductSn;
  bool? isDamageProductLots;
  bool? isDamageProductNoTracking;
  Product? damageProduct;

  DamageState({
    this.isDamagePalletIncSn,
    this.isDamagePalletIncLots,
    this.isDamagePalletIncNoTracking,
    this.isDamageProductSn,
    this.isDamageProductLots,
    this.isDamageProductNoTracking,
    this.damageProduct,
  });

  copyWith(
      {bool? isDamagePalletIncSn,
      bool? isDamagePalletIncLots,
      bool? isDamagePalletIncNoTracking,
      bool? isDamageProductSn,
      bool? isDamageProductLots,
      bool? isDamageProductNoTracking,
      Product? damageProduct}) {
    return DamageState(
      isDamagePalletIncSn: isDamagePalletIncSn ?? this.isDamagePalletIncSn,
      isDamagePalletIncLots:
          isDamagePalletIncLots ?? this.isDamagePalletIncLots,
      isDamagePalletIncNoTracking:
          isDamagePalletIncNoTracking ?? this.isDamagePalletIncNoTracking,
      isDamageProductSn: isDamageProductSn ?? this.isDamageProductSn,
      isDamageProductLots: isDamageProductLots ?? this.isDamageProductLots,
      isDamageProductNoTracking:
          isDamageProductNoTracking ?? this.isDamageProductNoTracking,
      damageProduct: damageProduct ?? this.damageProduct,
    );
  }
}
