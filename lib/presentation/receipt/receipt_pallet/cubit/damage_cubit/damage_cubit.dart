import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../data/model/product.dart';
import 'damage_state.dart';

class DamageCubit extends Cubit<DamageState> {
  DamageCubit() : super(DamageState());

  void setDamage({
    bool isDamagePalletIncSn = false,
    bool isDamagePalletIncLots = false,
  }) {
    if (isDamagePalletIncSn) {
      emit(state.copyWith(isDamagePalletIncSn: isDamagePalletIncSn));
      log("setDamage: ${state.isDamagePalletIncSn}");
    } else if (isDamagePalletIncLots) {
      emit(state.copyWith(isDamagePalletIncLots: isDamagePalletIncLots));
      log("setDamage: ${state.isDamagePalletIncLots}");
    }
  }

  void addDamage(Product damageProduct) {
    emit(state.copyWith(damageProduct: damageProduct));
    log("damageProduct: ${state.damageProduct?.toJson()}");
  }
}
