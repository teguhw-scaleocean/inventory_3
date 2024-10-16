import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inventory_v3/presentation/quality-control/pallet/screens/quality_control_detail_screen.dart';

import '../../data/model/product.dart';
import '../../data/model/quality_control.dart';
import '../../presentation/quality-control/product/screens/quality_control_product_menu_detail_screen.dart';
import '../theme/color/color_name.dart';
import '../theme/text/base_text.dart';
import 'status_badge.dart';

class QcItemCard extends StatelessWidget {
  final QualityControl qualityControl;
  final bool? isProductMenu;

  const QcItemCard(
      {super.key, required this.qualityControl, this.isProductMenu});

  @override
  Widget build(BuildContext context) {
    String date = qualityControl.dateTime.substring(0, 10);
    String time = qualityControl.dateTime.substring(13, 18);

    return GestureDetector(
      onTap: () {
        StatefulWidget page;
        if (isProductMenu == true) {
          page = QualityControlProductMenuDetailScreen(
            qualityControl: qualityControl,
            scanBarcode: null,
          );
          // page = const QualityControlProductMenuListScreen();
        } else {
          page = QualityControlDetailScreen(
            qualityControl: qualityControl,
            scanBarcode: null,
          );
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => page,
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(
          top: (qualityControl.id == 1) ? 8.h : 0,
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
                  qualityControl.name,
                  style: BaseText.blackText14.copyWith(
                    fontWeight: BaseText.medium,
                    color: ColorName.black2Color,
                  ),
                ),
                StatusBadge(
                  status: qualityControl.status,
                  color: qualityControl.statusColor,
                ),
              ],
            ),
            SizedBox(height: 8.h),
            (isProductMenu == true)
                ? Row(
                    children: [
                      Text(
                        qualityControl.packageStatus,
                        style: BaseText.grey1Text13
                            .copyWith(fontWeight: BaseText.light),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        qualityControl.packageName,
                        style: BaseText.grey1Text13
                            .copyWith(fontWeight: BaseText.light),
                      ),
                      Text(
                        qualityControl.packageStatus,
                        style: BaseText.grey1Text13
                            .copyWith(fontWeight: BaseText.light),
                      )
                    ],
                  ),
            SizedBox(height: 4.h),
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
            SizedBox(
              height: 16.h,
              width: double.infinity,
              child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: qualityControl.products.length,
                  itemBuilder: (context, index) {
                    var item = qualityControl.products[index];
                    var others = qualityControl.products.length - 3;

                    // return _buildItemProduct(item);
                    if (index < 3) {
                      return _buildItemProduct(item);
                    } else if (index == 3) {
                      return _buildOthersLength(others);
                    } else {
                      return const SizedBox();
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }

  Container _buildOthersLength(int others) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 6.w,
      ),
      child: Text(
        "+$others",
        style: BaseText.blue4Text11.copyWith(
          fontWeight: BaseText.light,
          color: ColorName.dateTimeColor,
        ),
      ),
    );
  }

  Widget _buildItemProduct(Product item) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 6.w,
      ),
      decoration: const BoxDecoration(
          border: Border(
              right: BorderSide(
        color: ColorName.borderColor,
      ))),
      child: Text(
        item.name,
        style: BaseText.blue4Text11.copyWith(
          fontWeight: BaseText.light,
          color: ColorName.dateTimeColor,
        ),
      ),
    );
  }
}
