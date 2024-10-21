import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_v3/data/model/check-in_model.dart';

import '../../../../data/model/product.dart';
import 'check-in_state.dart';

class CheckInCubit extends Cubit<CheckInState> {
  CheckInCubit() : super(CheckInState());

  void setInitialCheckIn() => emit(state.copyWith(listCheckIn: listOfCheckIn));

  void updateListQualityControl(
      {required int idQc, required List<Product> products}) {
    CheckInModel checkIn;

    checkIn = listOfCheckIn.firstWhere((e) => e.id == idQc);
    checkIn.products = products;

    var qcIndex = listOfCheckIn.indexOf(checkIn);
    listOfCheckIn[qcIndex] = checkIn;

    emit(state.copyWith(listCheckIn: listOfCheckIn));

    state.listCheckIn?.forEach((element) {
      log(element.products.map((e) => e.name).toList().toString());
    });
  }

  List<CheckInModel> get listOfUpdateCheckIn => state.listCheckIn ?? [];
}
