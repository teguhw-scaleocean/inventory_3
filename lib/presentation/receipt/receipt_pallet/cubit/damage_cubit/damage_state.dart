class DamageState {
  bool? isDamagePalletIncSn;

  DamageState({this.isDamagePalletIncSn});

  copyWith({bool? isDamagePalletIncSn}) {
    return DamageState(
      isDamagePalletIncSn: isDamagePalletIncSn ?? this.isDamagePalletIncSn,
    );
  }
}
