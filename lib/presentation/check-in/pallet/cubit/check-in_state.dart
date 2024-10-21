import 'package:inventory_v3/data/model/check-in_model.dart';
import 'package:inventory_v3/data/model/pallet.dart';

class CheckInState {
  List<CheckInModel>? listCheckIn;
  List<Pallet>? pallets;

  CheckInState({this.listCheckIn, this.pallets});

  copyWith({List<CheckInModel>? listCheckIn, List<Pallet>? pallets}) {
    return CheckInState(
      listCheckIn: listCheckIn ?? this.listCheckIn,
      pallets: pallets ?? this.pallets,
    );
  }
}
