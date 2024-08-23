import 'package:flutter/material.dart';
import 'package:inventory_v3/common/components/custom_app_bar.dart';
import 'package:inventory_v3/common/extensions/empty_space_extension.dart';
import 'package:inventory_v3/data/model/product.dart';

import '../../../common/components/custom_divider.dart';
import '../../../common/components/reusable_search_bar_border.dart';
import '../../../common/theme/color/color_name.dart';
import '../../../common/theme/text/base_text.dart';

class ReceiptProductDetailScreen extends StatefulWidget {
  final Product product;
  final String tracking;

  const ReceiptProductDetailScreen(
      {super.key, required this.product, required this.tracking});

  @override
  State<ReceiptProductDetailScreen> createState() =>
      _ReceiptProductDetailScreenState();
}

class _ReceiptProductDetailScreenState
    extends State<ReceiptProductDetailScreen> {
  late Product product;
  String tracking = "";

  final searchSerialNumberController = TextEditingController();
  final searchKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    debugPrint(widget.product.toJson());

    product = widget.product;
    tracking = widget.tracking;
  }

  _onSearch() {}
  _onClearData() {}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: const CustomAppBar(title: "Product Detail"),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.productName,
                  style: BaseText.blackText17
                      .copyWith(fontWeight: BaseText.medium),
                ),
                8.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(product.code,
                        style: BaseText.grey1Text13
                            .copyWith(fontWeight: BaseText.light)),
                    Text(product.palletCode,
                        style: BaseText.grey1Text13
                            .copyWith(fontWeight: BaseText.light)),
                  ],
                ),
                16.height,
                Text(
                  product.dateTime,
                  style: BaseText.baseTextStyle.copyWith(
                    fontWeight: BaseText.light,
                    fontSize: 14,
                    color: ColorName.dateTimeColor,
                  ),
                ),
                16.height,
                const CustomDivider(),
                16.height,
                Flexible(
                    child: Text("$tracking (11)", style: BaseText.blackText15)),
                12.height,
                (tracking.toLowerCase().contains("serial number"))
                    // ? Container(
                    //   child: ListView.builder(
                    //     itemCount: ,
                    //     itemBuilder: (context, index) {},),
                    // )
                    ? Expanded(
                        child: Column(
                          children: [
                            Flexible(
                              child: SizedBox(
                                height: 36,
                                width: double.infinity,
                                child: SearchBarBorder(
                                  context,
                                  onSearch: _onSearch(),
                                  clearData: _onClearData(),
                                  keySearch: searchKey,
                                  controller: searchSerialNumberController,
                                  queryKey: searchSerialNumberController.text,
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    : buildItemQuantity(product.code)
              ],
            ),
          )),
    );
  }

  Container buildItemQuantity(String code) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: ColorName.grey9Color,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                code,
                style: BaseText.blackText14,
              ),
              Text(
                "Exp. Date: 12/07/2024 - 15:00",
                style: BaseText.baseTextStyle.copyWith(
                  color: ColorName.dateTimeColor,
                  fontSize: 12,
                  fontWeight: BaseText.light,
                ),
              )
            ],
          ),
          IntrinsicHeight(
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 0),
                  child: VerticalDivider(
                    color: ColorName.grey9Color,
                    thickness: 1.0,
                  ),
                ),
                SizedBox(
                  height: 36,
                  width: 60,
                  child: Center(
                    child: Text("11",
                        textAlign: TextAlign.center,
                        style: BaseText.blackText11),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
