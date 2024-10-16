import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/model/product.dart';
import '../../../../data/model/quality_control.dart';

import 'quality_control_product_state.dart';

class QualityControlProductCubit extends Cubit<QualityControlProductState> {
  QualityControlProductCubit() : super(QualityControlProductState());

  void setInitialQualityControl() {
    emit(state.copyWith(qualityControl: qualityControls));
  }

  void updateListQualityControl(
      {required int idQc, required List<Product> products}) {
    QualityControl qualityControl;

    qualityControl = qualityControls.firstWhere((e) => e.id == idQc);
    qualityControl.products = products;

    var qcIndex = qualityControls.indexOf(qualityControl);
    qualityControls[qcIndex] = qualityControl;

    emit(state.copyWith(qualityControl: qualityControls));

    state.qualityControl?.forEach((element) {
      log(element.products.map((e) => e.name).toList().toString());
    });
  }

  List<QualityControl> get listStateQualityControl =>
      state.qualityControl ?? [];
}
