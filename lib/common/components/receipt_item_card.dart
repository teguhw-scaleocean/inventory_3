import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inventory_v3/presentation/receipt/screens/receipt_detail_screen.dart';

import '../../data/model/receipt.dart';
import '../extensions/empty_space_extension.dart';
import '../theme/color/color_name.dart';
import '../theme/text/base_text.dart';
import 'status_badge.dart';

class ReceiptItemCard extends StatelessWidget {
  final Receipt receipt;

  const ReceiptItemCard({super.key, required this.receipt});

  @override
  Widget build(BuildContext context) {
    String date = receipt.dateTime.substring(0, 10);
    String time = receipt.dateTime.substring(13, 18);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReceiptDetailScreen(receipt: receipt),
          ),
        );
      },
      child: SizedBox(
        // height: 120,
        child: Card(
          margin: EdgeInsets.only(
            top: (receipt.id == 1) ? 8 : 0,
            bottom: 10,
          ),
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      receipt.name,
                      style: BaseText.blackText14.copyWith(
                        fontWeight: BaseText.medium,
                        color: ColorName.black2Color,
                      ),
                    ),
                    StatusBadge(
                      status: receipt.status,
                      color: receipt.statusColor,
                    ),
                  ],
                ),
                8.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      receipt.packageName,
                      style: BaseText.grey1Text13
                          .copyWith(fontWeight: BaseText.light),
                    ),
                    Text(
                      receipt.packageStatus,
                      style: BaseText.grey1Text13
                          .copyWith(fontWeight: BaseText.light),
                    )
                  ],
                ),
                // 4.height,
                Row(
                  children: [
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: date,
                          style: BaseText.grey1Text13
                              .copyWith(fontWeight: BaseText.light),
                        ),
                        // TextSpan(
                        //   text: " - ",
                        //   style: BaseText.grey2Text13
                        //       .copyWith(fontWeight: BaseText.light),
                        // ),
                        WidgetSpan(
                            child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 5.5.h, horizontal: 2.5.w),
                          child: Container(
                            width: 7.w,
                            height: 1.h,
                            color: ColorName.grey2Color,
                            alignment: Alignment.center,
                          ),
                        )),
                        TextSpan(
                          text: time,
                          style: BaseText.grey1Text13
                              .copyWith(fontWeight: BaseText.light),
                        ),
                      ]),
                    )
                  ],
                ),
                10.height,
                Divider(
                  color: ColorName.grey9Color,
                  height: 1.0.h,
                  thickness: 1.0.h,
                ),
                6.height,
                Row(
                  children: [
                    Text(
                      receipt.destination,
                      style: BaseText.mainText13.copyWith(
                        fontWeight: BaseText.semiBold,
                        color: ColorName.main2Color,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
