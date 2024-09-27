import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../data/model/pallet.dart';
import 'receipt_both_detail_state.dart';

class ReceiptBothDetailCubit extends Cubit<ReceiptBothDetailState> {
  ReceiptBothDetailCubit() : super(ReceiptBothDetailState(products: []));

  getInitNoTrackingListProduct() {
    listPallets = products;
    emit(state.copyWith(products: listPallets));
    log("getInitNoTrackingListProduct: ${state.products.length}");
  }

  getInitLotsListProduct() {
    listPallets = products2;
    emit(state.copyWith(products: listPallets));
    log("getInitLotsListProduct: ${state.products.length}");
  }

  getLotsScannedTotalDone(int total) {
    int totalDone = total + state.lotsTotalDone;

    emit(state.copyWith(lotsTotalDone: totalDone));
    log("getLotsScannedTotalDone : ${state.lotsTotalDone}");
  }
}
