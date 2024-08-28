import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inventory_v3/common/components/custom_app_bar.dart';
import 'package:inventory_v3/common/components/custom_divider.dart';
import 'package:inventory_v3/common/components/primary_button.dart';
import 'package:inventory_v3/common/components/reusable_floating_action_button.dart';
import 'package:inventory_v3/common/constants/local_images.dart';
import 'package:inventory_v3/data/model/product.dart';
import 'package:inventory_v3/data/model/receipt.dart';
import 'package:inventory_v3/presentation/receipt/screens/receipt_product_detail.dart';

import '../../../common/components/status_badge.dart';
import '../../../common/extensions/empty_space_extension.dart';
import '../../../common/theme/color/color_name.dart';
import '../../../common/theme/text/base_text.dart';

class ReceiptDetailScreen extends StatefulWidget {
  final Receipt receipt;

  const ReceiptDetailScreen({super.key, required this.receipt});

  @override
  State<ReceiptDetailScreen> createState() => _ReceiptDetailScreenState();
}

class _ReceiptDetailScreenState extends State<ReceiptDetailScreen> {
  late Receipt receipt;
  List<Product> listProducts = <Product>[];

  String date = "";
  String time = "";

  @override
  void initState() {
    super.initState();

    receipt = widget.receipt;
    debugPrint(receipt.toJson());

    if (receipt.packageStatus
        .toString()
        .toLowerCase()
        .contains("no tracking")) {
      listProducts = products;
    } else if (receipt.packageStatus
        .toString()
        .toLowerCase()
        .contains("lots")) {
      listProducts = products2;
    } else if (receipt.packageStatus
        .toString()
        .toLowerCase()
        .contains("serial number")) {
      listProducts = products3;
    }

    date = receipt.dateTime.substring(0, 10);
    time = receipt.dateTime.substring(13, 18);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const CustomAppBar(title: "Receipt Detail"),
        body: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        receipt.name,
                        style: BaseText.blackText17
                            .copyWith(fontWeight: BaseText.medium),
                      ),
                      StatusBadge(
                        status: receipt.status,
                        color: receipt.statusColor,
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
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
                ],
              ),
            ),
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: buildScanAndUpdateSection(status: receipt.status),
            ),
            SizedBox(height: 16.h),
            const CustomDivider(height: 1.0, color: ColorName.grey9Color),
            Container(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: "Sch. Date: ",
                        style: BaseText.baseTextStyle.copyWith(
                          fontSize: 14.sp,
                          fontWeight: BaseText.regular,
                          color: ColorName.dateTimeColor,
                        ),
                      ),
                      TextSpan(
                        text: date,
                        style: BaseText.baseTextStyle.copyWith(
                          fontSize: 14.sp,
                          fontWeight: BaseText.medium,
                          color: ColorName.dateTimeColor,
                        ),
                      ),
                      WidgetSpan(
                          child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 6.h, horizontal: 2.5.w),
                        child: Container(
                          width: 7.w,
                          height: 1.h,
                          color: ColorName.grey2Color,
                          alignment: Alignment.center,
                        ),
                      )),
                      TextSpan(
                        text: time,
                        style: BaseText.baseTextStyle.copyWith(
                          fontSize: 14.sp,
                          fontWeight: BaseText.medium,
                          color: ColorName.dateTimeColor,
                        ),
                      ),
                    ]),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(LocalImages.receiveIcon),
                          const Dash(
                            dashColor: ColorName.grey2Color,
                            direction: Axis.vertical,
                            dashLength: 5,
                            length: 50,
                          ),
                          SvgPicture.asset(LocalImages.destinationIcon),
                        ],
                      ),
                      SizedBox(width: 16.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildPlaceStepper(
                            label: "Receive From",
                            location: "Main Storage Area",
                          ),
                          SizedBox(height: 20.h),
                          buildPlaceStepper(
                            label: "Destination Location",
                            location: "Medical Storage",
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const CustomDivider(height: 1.0, color: ColorName.grey9Color),
            Container(
              color: ColorName.backgroundColor,
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Pallet ",
                        style: BaseText.black2Text15
                            .copyWith(fontWeight: BaseText.medium),
                      ),
                      Text(
                        "(7)",
                        style: BaseText.black2Text15
                            .copyWith(fontWeight: BaseText.regular),
                      )
                    ],
                  ),
                  SizedBox(height: 12.h),
                  buildPalletButtonSection(
                    status: receipt.status,
                  ),
                  SizedBox(height: 14.h),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: listProducts.length,
                      physics: const NeverScrollableScrollPhysics(),
                      primary: false,
                      itemBuilder: (context, index) {
                        Product item = listProducts[index];
                        String tracking = "";
                        tracking = receipt.packageStatus.substring(10);
                        debugPrint("tracking: $tracking");

                        return buildPalleteItemCard(item, tracking);
                      })
                ],
              ),
            )
          ],
        ),
        floatingActionButton: reusableFloatingActionButton(
          onTap: () {},
          icon: Icons.add,
        ),
      ),
    );
  }

  Row buildScanAndUpdateSection({required String status}) {
    Color? scanButtonColor;
    Color? updateButtonColor;

    switch (status) {
      case "Late":
        scanButtonColor = ColorName.mainColor;
        updateButtonColor = ColorName.updateButtonColor;
        break;
      case "Ready":
        scanButtonColor = ColorName.mainColor;
        updateButtonColor = ColorName.updateButtonColor;
        break;
      default:
        scanButtonColor = null;
        updateButtonColor = null;
    }

    return Row(
      children: [
        Flexible(
          child: DisableButton(
            height: 40.h,
            width: double.infinity,
            iconWidget: SvgPicture.asset(
              LocalImages.scanIcons,
              color: ColorName.whiteColor,
              height: 16.w,
              width: 16.w,
            ),
            title: "Scan",
            color: scanButtonColor,
          ),
        ),
        SizedBox(width: 16.w),
        Flexible(
          child: DisableButton(
            height: 40.h,
            width: double.infinity,
            // width: 156,
            iconWidget: SvgPicture.asset(
              LocalImages.updatePalleteIcons,
              height: 16.w,
              width: 16.w,
            ),
            title: "Update Pallet",
            color: updateButtonColor,
          ),
        ),
      ],
    );
  }

  Widget buildOutlineButton(BuildContext context,
      {required String label,
      Color? borderColor,
      Color? backgroundColor,
      TextStyle? labelTextStyle}) {
    return Material(
        // onPressed: () {},
        color: backgroundColor ?? ColorName.whiteColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.r),
            side: BorderSide(
              color: borderColor ?? ColorName.grey6Color,
              width: 1,
            )),
        elevation: 0,
        child: Container(
          height: 36.h,
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Center(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: labelTextStyle ??
                  BaseText.baseTextStyle.copyWith(
                    fontSize: 12.sp,
                    fontWeight: BaseText.medium,
                    color: ColorName.grey12Color,
                  ),
            ),
          ),
        ));
  }

  InkWell buildPalleteItemCard(Product product, String tracking) {
    Product product0;
    product0 = product;

    return InkWell(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ReceiptProductDetailScreen(
                  product: product0, tracking: tracking))),
      child: Card(
        // semanticContainer: true,
        // clipBehavior: Clip.antiAliasWithSaveLayer,
        margin: EdgeInsets.only(bottom: 12.h),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(6))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 0, 10.h),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: ColorName.borderColor,
                    width: 0.5,
                  ),
                ),
              ),
              child: Text(
                "Pallet ${product0.palletCode}",
                style:
                    BaseText.black2Text15.copyWith(fontWeight: BaseText.medium),
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    product0.productName,
                    style: BaseText.grey1Text15,
                  ),
                  Text(
                    product0.lotsCode ?? product0.code,
                    style: BaseText.baseTextStyle.copyWith(
                      color: ColorName.grey11Color,
                      fontSize: 13.sp,
                      fontWeight: BaseText.light,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    product0.dateTime,
                    style: BaseText.baseTextStyle.copyWith(
                      fontSize: 14.sp,
                      color: ColorName.dateTimeColor,
                    ),
                  ),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
            Row(
              children: [
                _buildBottomCardSection(
                  label: "Receive",
                  value: "11.00 Unit",
                ),
                _buildBottomCardSection(
                  label: "Done",
                  value: "1.00 Unit",
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomCardSection(
      {required String label, required String value}) {
    bool isReceive = false;
    Color bgColor;

    if (label.contains("Receive")) {
      isReceive = true;
      bgColor = ColorName.receiveBgColor;
    } else {
      bgColor = ColorName.doneBgColor;
    }

    return Flexible(
      child: Container(
        height: 60.h,
        width: MediaQuery.sizeOf(context).width / 2,
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.only(
            bottomLeft: (isReceive)
                ? const Radius.circular(6)
                : const Radius.circular(0),
            bottomRight: (!isReceive)
                ? const Radius.circular(6)
                : const Radius.circular(0),
          ),
        ),
        child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(children: [
              TextSpan(
                text: "$label\n",
                style: BaseText.baseTextStyle.copyWith(
                    fontSize: 13.sp,
                    color: (isReceive)
                        ? ColorName.receiveLabelColor
                        : ColorName.doneLabelColor),
              ),
              TextSpan(
                text: value,
                style: BaseText.baseTextStyle.copyWith(
                  fontSize: 14.sp,
                  color: (isReceive)
                      ? ColorName.receiveValueColor
                      : ColorName.doneValueColor,
                  fontWeight: BaseText.medium,
                ),
              )
            ])),
      ),
    );
  }

  Widget buildPlaceStepper({required String label, required String location}) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: BaseText.grey2Text13,
          ),
          Text(
            location,
            style: BaseText.grey10Text14.copyWith(fontWeight: BaseText.medium),
          )
        ],
      ),
    );
  }

  Widget buildPalletButtonSection({required String status}) {
    TextStyle? labelTextStyle;
    switch (status) {
      case "Late":
        labelTextStyle = BaseText.mainText12
            .copyWith(color: ColorName.main2Color, fontWeight: BaseText.medium);
        break;
      case "Ready":
        labelTextStyle = BaseText.mainText12
            .copyWith(color: ColorName.main2Color, fontWeight: BaseText.medium);
        break;
      default:
    }

    return Row(
      children: [
        Flexible(
            child: buildOutlineButton(context,
                label: "Damage", labelTextStyle: labelTextStyle)),
        SizedBox(width: 12.w),
        Flexible(
            child: buildOutlineButton(context,
                label: "Return", labelTextStyle: labelTextStyle)),
      ],
    );
  }
}
