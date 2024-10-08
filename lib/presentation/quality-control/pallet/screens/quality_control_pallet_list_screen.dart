import 'package:flutter/material.dart';
import 'package:inventory_v3/common/components/custom_app_bar.dart';

class QualityControlPalletListScreen extends StatefulWidget {
  final String appBarTitle;

  const QualityControlPalletListScreen({super.key, required this.appBarTitle});

  @override
  State<QualityControlPalletListScreen> createState() =>
      _QualityControlPalletListScreenState();
}

class _QualityControlPalletListScreenState
    extends State<QualityControlPalletListScreen> {
  String appBarTitle = "";

  @override
  void initState() {
    super.initState();

    appBarTitle = widget.appBarTitle;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          onTap: () => Navigator.pop(context),
          title: appBarTitle,
        ),
      ),
    );
  }
}
