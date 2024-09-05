import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/model/receipt.dart';
import '../../presentation/receipt/receipt_product/screens/receipt_product_menu_detail_screen.dart';
import '../theme/color/color_name.dart';
import '../theme/text/base_text.dart';
import 'status_badge.dart';

class ReceiptProductItemCard extends StatelessWidget {
  final Receipt receipt;

  const ReceiptProductItemCard({super.key, required this.receipt});

  @override
  Widget build(BuildContext context) {
    String date = receipt.dateTime.substring(0, 10);
    String time = receipt.dateTime.substring(13, 18);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ReceiptProductMenuDetailScreen(receipt: receipt),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(
          top: (receipt.id == 1) ? 8.h : 0,
          bottom: 10.h,
        ),
        padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 10.h),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.r)),
          shadows: const [
            BoxShadow(
              color: Color(0x19000000),
              blurRadius: 2,
              offset: Offset(0, 0.44),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Color(0x0C000000),
              blurRadius: 3.52,
              offset: Offset(0, 1.76),
              spreadRadius: 1.32,
            )
          ],
        ),
        // height: 120,
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
            SizedBox(height: 8.h),
            Row(
              children: [
                Text(
                  receipt.packageStatus,
                  style:
                      BaseText.grey1Text13.copyWith(fontWeight: BaseText.light),
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
            SizedBox(height: 10.h),
            Divider(
              color: ColorName.grey9Color,
              height: 1.0.h,
              thickness: 1.0.h,
            ),
            SizedBox(
              height: 6.h,
            ),
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
    );
  }
}
