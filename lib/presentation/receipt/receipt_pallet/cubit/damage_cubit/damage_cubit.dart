import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../data/model/product.dart';
import 'damage_state.dart';

class DamageCubit extends Cubit<DamageState> {
  DamageCubit() : super(DamageState());

  void setDamage({bool isDamagePalletIncSn = false}) {
    emit(state.copyWith(isDamagePalletIncSn: isDamagePalletIncSn));
    log("setDamage: ${state.isDamagePalletIncSn}");
  }

  void addDamage(Product damageProduct) {
    emit(state.copyWith(damageProduct: damageProduct));
    log("damageProduct: ${state.damageProduct?.toJson()}");
  }
}
