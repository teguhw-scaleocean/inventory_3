import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../data/model/product.dart';
import 'scan_state.dart';

class ScanCubit extends Cubit<ScanState> {
  ScanCubit() : super(ScanState(serialNumbers: [], isItemInputDate: false));

  setListOfSerialNumber(List<SerialNumber> serialNumbers) {
    emit(state.copyWith(serialNumbers: serialNumbers));
  }

  getListOfSerialNumber() => state.serialNumbers;

  setIsItemInputDate(bool isItemInputDate) {
    emit(state.copyWith(isItemInputDate: isItemInputDate));
    log("state.isItemInputDate: ${state.isItemInputDate.toString()}");
  }
}
