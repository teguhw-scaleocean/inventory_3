import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'damage_state.dart';

class DamageCubit extends Cubit<DamageState> {
  DamageCubit() : super(DamageState());

  setDamage({bool isDamagePalletIncSn = false}) {
    emit(state.copyWith(isDamagePalletIncSn: isDamagePalletIncSn));

    log("setDamage: ${state.isDamagePalletIncSn}");
  }
}
