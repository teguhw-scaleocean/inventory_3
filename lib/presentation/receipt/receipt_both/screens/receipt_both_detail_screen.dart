import 'package:flutter/material.dart';

import '../../../../data/model/receipt.dart';

class ReceiptBothDetailScreen extends StatefulWidget {
  final Receipt? receipt;
  final String? scanBarcode;

  const ReceiptBothDetailScreen({super.key, this.receipt, this.scanBarcode});

  @override
  State<ReceiptBothDetailScreen> createState() =>
      _ReceiptBothDetailScreenState();
}

class _ReceiptBothDetailScreenState extends State<ReceiptBothDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
