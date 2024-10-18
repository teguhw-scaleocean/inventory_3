import 'package:flutter_bloc/flutter_bloc.dart';

import 'quality_control_both_state.dart';

class QualityControlBothCubit extends Cubit<QualityControlBothState> {
  QualityControlBothCubit() : super(QualityControlBothState());

  void setBothListScreen(bool isBothListScreen) =>
      emit(state.copyWith(isBothListScreen: isBothListScreen));

  getBothListScreen() => state.isBothListScreen;
}
