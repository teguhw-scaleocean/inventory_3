class QualityControlBothState {
  bool? isBothListScreen;

  QualityControlBothState({this.isBothListScreen});

  copyWith({
    bool? isBothListScreen,
  }) {
    return QualityControlBothState(
      isBothListScreen: isBothListScreen ?? this.isBothListScreen,
    );
  }
}
