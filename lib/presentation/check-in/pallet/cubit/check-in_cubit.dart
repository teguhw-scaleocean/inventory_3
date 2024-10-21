import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_v3/data/model/check-in_model.dart';

import '../../../../data/model/pallet.dart';
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

  // Detail Screen
  getInitPalletListSn() {
    listPallets = products3;

    listPallets.map((e) {
      if (e.id == 2) {
        var serialNumberList = List.generate(
          e.productQty.toInt(),
          (index) => SerialNumber(
            id: index,
            label: "BP1234567845$index",
            expiredDateTime: "Exp. Date: 12/07/2024 - 16:00",
            quantity: 1,
          ),
        );
        e.serialNumber = serialNumberList;
      } else if (e.id == 1) {
        var serialNumberList = List.generate(
          e.productQty.toInt(),
          (index) => SerialNumber(
            id: index,
            label: "BP1234567845$index",
            expiredDateTime: "Exp. Date: 12/07/2024 - 16:00",
            isInputDate: (index == 1) ? true : false,
            isEditDate: (index == 2) ? true : false,
            quantity: 1,
          ),
        );
        e.serialNumber = serialNumberList;
      }
    }).toList();

    emit(state.copyWith(pallets: listPallets));
    log("getInitListProduct: ${state.pallets!.length}");
  }

  scanFromList(String resultQty) {
    double resultQtyDouble = double.tryParse(resultQty) ?? 0.0;
    List<Pallet> lastPallets = state.pallets ?? [];
    lastPallets.first.doneQty = resultQtyDouble;

    emit(state.copyWith(pallets: lastPallets));

    log("scanFromList: ${lastPallets.map((e) => e.doneQty.toString()).toList()}");
  }

  scanAttempt(int attempt) {
    emit(state.copyWith(scanFromListAttempt: attempt));

    log("scanAttempt: ${state.scanFromListAttempt}");
  }
}
