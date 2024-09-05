import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_v3/presentation/receipt/receipt_pallet/cubit/add_pallet_cubit/add_pallet_state.dart';

import '../../../../../data/model/product.dart';

class AddPalletCubit extends Cubit<AddPalletState> {
  AddPalletCubit() : super(AddPalletState(products: listProducts));

  onSubmit({required Product product}) {
    emit(state.copyWith(
      products: [product, ...listProducts],
    ));

    log(listProducts.map((e) => e.toString()).toList().toString());
  }
}
