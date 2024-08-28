import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inventory_v3/common/components/custom_app_bar.dart';
import 'package:inventory_v3/common/components/reusable_floating_action_button.dart';
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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.h),
                  Text(
                    product.productName,
                    style: BaseText.blackText17
                        .copyWith(fontWeight: BaseText.medium),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(product.code,
                          style: BaseText.grey1Text13
                              .copyWith(fontWeight: BaseText.light)),
                      Text("Pallet ${product.palletCode}",
                          style: BaseText.grey1Text13
                              .copyWith(fontWeight: BaseText.light)),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    product.dateTime,
                    style: BaseText.baseTextStyle.copyWith(
                      fontWeight: BaseText.light,
                      fontSize: 14.sp,
                      color: ColorName.dateTimeColor,
                    ),
                  ),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
            const CustomDivider(),
            Flexible(
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    height: 43.h,
                    // padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "$tracking (11)",
                        style: BaseText.blackText15.copyWith(
                          fontWeight: BaseText.medium,
                        ),
                      ),
                    ))),
            (tracking.toLowerCase().contains("serial number"))
                ? Flexible(
                    child: SizedBox(
                      height: 36.h,
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
                : const SizedBox(),
            SizedBox(height: 12.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  (tracking.toLowerCase().contains("serial number"))
                      ? SizedBox(
                          height: 600.h,
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: const AlwaysScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemCount: 11,
                              itemBuilder: (context, index) {
                                String code = "SM-2024-${product.code}";

                                return Padding(
                                    padding: EdgeInsets.only(bottom: 8.h),
                                    child: buildItemQuantity(code));
                              }),
                        )
                      : buildItemQuantity(product.lotsCode ?? product.code)
                ],
              ),
            )
          ],
        ),
        floatingActionButton:
            reusableFloatingActionButton(onTap: () {}, icon: Icons.add),
      ),
    );
  }

  Container buildItemQuantity(String code) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.r),
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
                style:
                    BaseText.black2Text14.copyWith(fontWeight: BaseText.medium),
              ),
              Text(
                "Exp. Date: 12/07/2024 - 15:00",
                style: BaseText.baseTextStyle.copyWith(
                  color: ColorName.dateTimeColor,
                  fontSize: 12.sp,
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
                  height: 36.h,
                  width: 60.w,
                  child: Center(
                    child: Text("11",
                        textAlign: TextAlign.center,
                        style: BaseText.black2Text14),
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
