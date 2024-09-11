import '../../../../../data/model/product.dart';

class ScanState {
  List<SerialNumber> serialNumbers;

  ScanState({required this.serialNumbers});

  copyWith({List<SerialNumber>? serialNumbers}) {
    return ScanState(serialNumbers: serialNumbers ?? this.serialNumbers);
  }
}
