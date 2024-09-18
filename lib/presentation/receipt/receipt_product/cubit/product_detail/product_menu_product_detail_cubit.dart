import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_v3/presentation/receipt/receipt_product/cubit/product_detail/product_menu_product_detail_state.dart';

import '../../../../../data/model/product.dart';

class ProductMenuProductDetailCubit
    extends Cubit<ProductMenuProductDetailState> {
  ProductMenuProductDetailCubit()
      : super(ProductMenuProductDetailState(
          products: [],
          serialNumbers: [],
        ));

  getInitListProduct() {
    listProducts = products3;

    listProducts.map((e) {
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

    emit(state.copyWith(products: listProducts));
    log("getInitListProduct: ${state.products.length}");
  }

  getInitLotsListProduct() {
    listProducts = products2;
    emit(state.copyWith(products: listProducts));
    log("getInitLotsListProduct: ${state.products.length}");
  }

  scannedSerialNumberToProduct(Product newProduct) {
    // emit(state.copyWith(product: newProduct));
    getCurrentProduct(newProduct);
    List<Product> lastProducts = state.products;

    int index =
        lastProducts.indexWhere((element) => element.id == newProduct.id);
    lastProducts[index] = newProduct;
    emit(state.copyWith(products: lastProducts));
    log("scannedSerialNumberToProduct: ${lastProducts.map((e) => e.scannedSerialNumber?.length.toString()).toList()}");
  }

  getCurrentProduct(Product currentProduct) {
    log("currentProduct: ${currentProduct.productName}");
    emit(state.copyWith(product: currentProduct));
  }

  setTotalToDone(int total) {
    emit(state.copyWith(totalToDone: total));
    log("setTotalToDone: ${state.totalToDone.toString()}");
  }

  getLotsScannedTotalDone(int total) {
    int resTotal = total += 1;

    emit(state.copyWith(lotsTotalDone: resTotal));
    log("getLotsScannedTotalDone: ${state.lotsTotalDone.toString()}");
  }

  getLotsUpdateTotalDone(int total, int doneTotal) {
    emit(state.copyWith(lotsTotalDone: doneTotal));
    log("getLotsUpdateTotalDone: ${state.lotsTotalDone.toString()}");

    bool isDone = false;
    isDone = (doneTotal == total) ? true : false;
    getIsDoneQty(isDone);
  }

  getSnUpdateTotalDone(int total, int doneTotal) {
    emit(state.copyWith(snTotalDone: doneTotal));
    log("getSnUpdateTotalDone: ${state.snTotalDone.toString()}");

    bool isDone = false;
    isDone = (doneTotal == total) ? true : false;
    getIsDoneQty(isDone);
  }

  getIsDoneQty(bool isDone) {
    emit(state.copyWith(isDoneQty: isDone));
    log("getIsDoneQty: ${state.isDoneQty.toString()}");
  }

  setListOfSerialNumber(List<SerialNumber> serialNumbers) {
    emit(state.copyWith(serialNumbers: serialNumbers));
  }

  getListOfSerialNumber() => state.serialNumbers;
}
