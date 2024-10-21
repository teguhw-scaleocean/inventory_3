import 'package:inventory_v3/data/model/check-in_model.dart';
import 'package:inventory_v3/data/model/pallet.dart';

class CheckInState {
  List<CheckInModel>? listCheckIn;
  List<Pallet>? pallets;
  int? scanFromListAttempt;

  CheckInState({
    this.listCheckIn,
    this.pallets,
    this.scanFromListAttempt = 0,
  });

  copyWith(
      {List<CheckInModel>? listCheckIn,
      List<Pallet>? pallets,
      int? scanFromListAttempt}) {
    return CheckInState(
      listCheckIn: listCheckIn ?? this.listCheckIn,
      pallets: pallets ?? this.pallets,
      scanFromListAttempt: scanFromListAttempt ?? this.scanFromListAttempt,
    );
  }
}
