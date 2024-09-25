import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_v3/presentation/receipt/receipt_pallet/cubit/add_pallet_cubit/add_pallet_state.dart';

import '../../../../../data/model/pallet.dart';

class AddPalletCubit extends Cubit<AddPalletState> {
  AddPalletCubit() : super(AddPalletState(products: listPallets));

  onSubmit({required Pallet product}) {
    emit(state.copyWith(
      products: [product, ...listPallets],
    ));

    log(listPallets.map((e) => e.toString()).toList().toString());
  }
}
