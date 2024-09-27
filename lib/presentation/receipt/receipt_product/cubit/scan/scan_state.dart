import '../../../../../data/model/pallet.dart';

class ScanState {
  List<SerialNumber> serialNumbers;
  bool isItemInputDate;

  ScanState({required this.serialNumbers, required this.isItemInputDate});

  copyWith({List<SerialNumber>? serialNumbers, bool? isItemInputDate}) {
    return ScanState(
      serialNumbers: serialNumbers ?? this.serialNumbers,
      isItemInputDate: isItemInputDate ?? this.isItemInputDate,
    );
  }
}
