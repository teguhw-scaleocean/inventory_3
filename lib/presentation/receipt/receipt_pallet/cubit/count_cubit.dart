import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'count_state.dart';

class CountCubit extends Cubit<CountState> {
  CountCubit() : super(CountState(quantity: 0.0));
  void increment() {
    emit(state.copyWith(quantity: state.quantity + 1));
    log(state.quantity.toString());
  }

  void decrement() {
    emit(state.copyWith(quantity: state.quantity - 1));
    log(state.quantity.toString());
  }

  void update(data) => emit(data);
}
