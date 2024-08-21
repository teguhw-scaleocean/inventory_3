import 'package:flutter/material.dart';
import 'package:inventory_v3/common/components/custom_app_bar.dart';
import 'package:inventory_v3/common/extensions/empty_space_extension.dart';

import '../../../common/components/custom_divider.dart';
import '../../../common/theme/color/color_name.dart';
import '../../../common/theme/text/base_text.dart';

class ReceiptProductDetailScreen extends StatefulWidget {
  const ReceiptProductDetailScreen({super.key});

  @override
  State<ReceiptProductDetailScreen> createState() =>
      _ReceiptProductDetailScreenState();
}

class _ReceiptProductDetailScreenState
    extends State<ReceiptProductDetailScreen> {
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
                  "Surgical Instruments",
                  style: BaseText.blackText17
                      .copyWith(fontWeight: BaseText.medium),
                ),
                8.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("SUR_12942",
                        style: BaseText.grey1Text13
                            .copyWith(fontWeight: BaseText.light)),
                    Text("Pallet A493",
                        style: BaseText.grey1Text13
                            .copyWith(fontWeight: BaseText.light)),
                  ],
                ),
                16.height,
                Text(
                  "Sch. Date: 14/06/2024 - 15.30",
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
                    child:
                        Text("No Tracking (11)", style: BaseText.blackText15)),
                12.height,
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                            "SUR_12942",
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
                )
              ],
            ),
          )),
    );
  }
}
