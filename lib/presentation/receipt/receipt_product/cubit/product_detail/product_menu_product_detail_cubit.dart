import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_v3/data/model/return_product.dart';
import 'package:inventory_v3/presentation/receipt/receipt_product/cubit/product_detail/product_menu_product_detail_state.dart';

import '../../../../../data/model/pallet.dart';
import '../../../../../data/model/product.dart';
import '../../../../../data/model/return_pallet.dart';

class ProductMenuProductDetailCubit
    extends Cubit<ProductMenuProductDetailState> {
  ProductMenuProductDetailCubit()
      : super(ProductMenuProductDetailState(
          pallets: [],
          serialNumbers: [],
        ));

  getInitListProduct() {
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
    log("getInitListProduct: ${state.pallets.length}");
  }

  getInitLotsListProduct() {
    listPallets = products2;
    emit(state.copyWith(pallets: listPallets));
    log("getInitLotsListProduct: ${state.pallets.length}");
  }

  getInitNoTrackingListProduct() {
    listPallets = products;
    emit(state.copyWith(pallets: listPallets));
    log("getInitNoTrackingListProduct: ${state.pallets.length}");
  }

  scannedSerialNumberToProduct(Pallet newProduct) {
    // emit(state.copyWith(product: newProduct));
    getCurrentProduct(newProduct);
    List<Pallet> lastProducts = state.pallets;

    int index =
        lastProducts.indexWhere((element) => element.id == newProduct.id);
    lastProducts[index] = newProduct;
    emit(state.copyWith(pallets: lastProducts));
    log("scannedSerialNumberToProduct: ${lastProducts.map((e) => e.scannedSerialNumber?.length.toString()).toList()}");
  }

  getCurrentProduct(Pallet currentProduct) {
    log("currentProduct: ${currentProduct.productName}");
    emit(state.copyWith(product: currentProduct));
  }

  setTotalToDone(int total) {
    emit(state.copyWith(totalToDone: total));
    log("setTotalToDone: ${state.totalToDone.toString()}");
  }

  getBothLotsTotalDone(int total, int doneTotal) {
    int statePrevTotal = state.lotsTotalDone ?? 0;
    int resTotal = statePrevTotal + doneTotal;

    emit(state.copyWith(
      lotsTotalDone: resTotal,
      product: state.product?.copyWith(doneQty: resTotal.toDouble()),
    ));
    log("product done: ${state.product.toString()}");

    bool isDone = false;
    isDone = (doneTotal == total) ? true : false;
    getIsDoneQty(isDone);
  }

  getLotsScannedTotalDone(int total) {
    int resTotal = total += 1;

    emit(state.copyWith(lotsTotalDone: resTotal));
    log("getLotsScannedTotalDone: ${state.lotsTotalDone.toString()}");
  }

  // getLotsUpdateTotalDone(int total, int doneTotal) {
  //   int statePrevTotal = state.lotsTotalDone ?? 0;
  //   int resTotal = statePrevTotal + doneTotal;
  //   emit(state.copyWith(
  //     lotsTotalDone: resTotal,
  //     product: state.product?.copyWith(doneQty: resTotal.toDouble()),
  //   ));
  //   log("getLotsUpdateTotalDone: ${state.lotsTotalDone.toString()}");

  //   bool isDone = false;
  //   isDone = (doneTotal == total) ? true : false;
  //   getIsDoneQty(isDone);
  // }

  getResultUpdateTotalDone(int updateQty) {
    emit(state.copyWith(updateTotal: updateQty));
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

  scanPallet(Pallet product) {
    List<Pallet> lastProducts = state.pallets;

    int index = lastProducts.indexWhere((element) => element.id == product.id);
    var scannedPallet = product.copyWith(hasBeenScanned: true);
    lastProducts[index] = scannedPallet;
    emit(state.copyWith(pallets: lastProducts));
    log("scannedPallet: ${lastProducts.map((e) => e.hasBeenScanned.toString()).toList()}");
  }

  getReturnProduct(ReturnPallet returnPallet, double returnQty) {
    List<Pallet> lastPallets = state.pallets;
    var currentPallet = getCurrentPallet(returnPallet);
    var indexPallet = getCurrentPalletIndex(returnPallet);

    var itemReturn = currentPallet.copyWith(
      isReturn: true,
      returnQty: returnQty,
      returnProductNoTracking: returnPallet.returnProducts,
    );
    lastPallets[indexPallet] = itemReturn;
    emit(state.copyWith(pallets: lastPallets));

    log("getReturnProduct: ${lastPallets.map((e) => e.returnQty.toString()).toList()}");
  }

  getReturnPallet(ReturnPallet returnPallet, {bool? isPalletDamage}) {
    Pallet itemReturn;
    List<Pallet> lastPallets = state.pallets;
    var currentPallet = getCurrentPallet(returnPallet);
    var indexPallet = getCurrentPalletIndex(returnPallet);

    if (isPalletDamage == true) {
      itemReturn = currentPallet.copyWith(isDamage: true);
    } else {
      itemReturn = currentPallet.copyWith(isReturn: true);
    }

    lastPallets[indexPallet] = itemReturn;
    emit(state.copyWith(pallets: lastPallets));

    log("getReturnPallet: ${lastPallets.map((e) => e.isReturn.toString()).toList()}");
    log("getReturnPallet->Damage: ${lastPallets.map((e) => e.isDamage.toString()).toList()}");
  }

  getReturnPalletAndProduct(ReturnPallet returnPallet,
      {bool? isPalletAndProductDamage}) {
    Pallet itemReturn;
    List<Pallet> lastPallets = state.pallets;
    var currentPallet = getCurrentPallet(returnPallet);
    var indexPallet = getCurrentPalletIndex(returnPallet);

    if (isPalletAndProductDamage == true) {
      itemReturn = currentPallet.copyWith(
        isDamagePalletAndProduct: true,
        damagedQty: returnPallet.damageQty,
        damageProducts: returnPallet.damageProducts,
      );
    } else {
      itemReturn = currentPallet.copyWith(isReturnPalletAndProduct: true);
    }
    lastPallets[indexPallet] = itemReturn;
    emit(state.copyWith(pallets: lastPallets));

    log("getReturnPalletAndProduct: ${lastPallets.map((e) => e.isReturnPalletAndProduct.toString()).toList()}");
    log("getReturnPalletAndProduct->isDamagePalletAndProduct: ${lastPallets.map((e) => e.damagedQty.toString()).toList()}");
  }

  Pallet getCurrentPallet(ReturnPallet returnPallet) {
    List<Pallet> lastPallets = state.pallets;
    var currentPallet =
        lastPallets.firstWhere((element) => element.id == returnPallet.id);
    return currentPallet;
  }

  int getCurrentPalletIndex(ReturnPallet returnPallet) {
    List<Pallet> lastPallets = state.pallets;
    int index =
        lastPallets.indexWhere((element) => element.id == returnPallet.id);
    return index;
  }
}
