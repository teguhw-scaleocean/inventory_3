import 'package:inventory_v3/data/model/check-in_model.dart';

class CheckInState {
  List<CheckInModel>? listCheckIn;

  CheckInState({this.listCheckIn});

  copyWith({List<CheckInModel>? listCheckIn}) {
    return CheckInState(
      listCheckIn: listCheckIn ?? this.listCheckIn,
    );
  }
}
