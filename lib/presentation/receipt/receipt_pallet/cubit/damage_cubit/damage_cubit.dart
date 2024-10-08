import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../data/model/product.dart';
import 'damage_state.dart';

class DamageCubit extends Cubit<DamageState> {
  DamageCubit() : super(DamageState());

  void setDamage({
    bool isDamagePalletIncSn = false,
    bool isDamagePalletIncLots = false,
    bool isDamagePalletIncNoTracking = false,
  }) {
    if (isDamagePalletIncSn) {
      emit(state.copyWith(isDamagePalletIncSn: isDamagePalletIncSn));
      log("setDamage: ${state.isDamagePalletIncSn}");
    } else if (isDamagePalletIncLots) {
      emit(state.copyWith(isDamagePalletIncLots: isDamagePalletIncLots));
      log("setDamage: ${state.isDamagePalletIncLots}");
    } else if (isDamagePalletIncNoTracking) {
      emit(state.copyWith(
          isDamagePalletIncNoTracking: isDamagePalletIncNoTracking));
      log("setDamage: ${state.isDamagePalletIncNoTracking}");
    }
  }

  void setDamageByProduct({
    bool isDamageProductSn = false,
    bool isDamageProductLots = false,
    bool isDamageProductNoTracking = false,
  }) {
    emit(state.copyWith(
      isDamageProductSn: isDamageProductSn,
      isDamageProductLots: isDamageProductLots,
      isDamageProductNoTracking: isDamageProductNoTracking,
    ));
    log("isDamageProductSn: ${state.isDamageProductSn}, isDamageProductLots: ${state.isDamageProductLots}, isDamageProductNoTracking: ${state.isDamageProductNoTracking}");
  }

  void addDamage(Product damageProduct) {
    emit(state.copyWith(damageProduct: damageProduct));
    log("damageProduct: ${state.damageProduct?.toJson()}");
  }
}
