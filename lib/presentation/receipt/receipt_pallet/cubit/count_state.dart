class CountState {
  double quantity;

  CountState({required this.quantity});

  copyWith({double? quantity}) {
    return CountState(quantity: quantity ?? this.quantity);
  }
}
