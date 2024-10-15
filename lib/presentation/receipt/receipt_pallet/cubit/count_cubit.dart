import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'count_state.dart';

class CountCubit extends Cubit<CountState> {
  CountCubit() : super(CountState(quantity: 0.0));
  void increment(double qty) {
    // if (qty > 0) {
    emit(state.copyWith(quantity: qty + 1));
    // } else {
    //   emit(state.copyWith(quantity: state.quantity + 1));
    log(state.quantity.toString());
    // }
  }

  void decrement(double qty) {
    emit(state.copyWith(quantity: state.quantity - 1));
    log(state.quantity.toString());
  }

  void update(data) => emit(data);

  void submit(double qty) {
    emit(state.copyWith(quantity: qty));
    log("state.quantity: ${state.quantity}");
  }
}
