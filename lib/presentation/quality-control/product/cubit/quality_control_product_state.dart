import 'package:inventory_v3/data/model/quality_control.dart';

class QualityControlProductState {
  List<QualityControl>? qualityControl;

  QualityControlProductState({this.qualityControl});

  copyWith({List<QualityControl>? qualityControl}) {
    return QualityControlProductState(
      qualityControl: qualityControl ?? this.qualityControl,
    );
  }
}
