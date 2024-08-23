import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const CustomAppBar(title: "Receipt Detail"),
        body: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
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
                ],
              ),
            ),
            16.height,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: buildScanAndUpdateSection(status: receipt.status),
            ),
            16.height,
            const CustomDivider(height: 1.0, color: ColorName.grey9Color),
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: "Sch. Date: ",
                        style: BaseText.baseTextStyle.copyWith(
                          fontSize: 14,
                          color: ColorName.dateTimeColor,
                        ),
                      ),
                      TextSpan(
                        text: "14/06/2024 - 15.30",
                        style: BaseText.baseTextStyle.copyWith(
                          fontSize: 14,
                          fontWeight: BaseText.light,
                          color: ColorName.dateTimeColor,
                        ),
                      )
                    ]),
                  ),
                  8.height,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(LocalImages.receiveIcon),
                          const Dash(
                            direction: Axis.vertical,
                            dashLength: 3,
                            length: 46,
                          ),
                          SvgPicture.asset(LocalImages.destinationIcon),
                        ],
                      ),
                      16.width,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildPlaceStepper(
                            label: "Receive From",
                            location: "Main Storage Area",
                          ),
                          20.height,
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
            Container(
              color: ColorName.backgroundColor,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
                        style: BaseText.black2TextStyle.copyWith(
                          fontSize: 14,
                          fontWeight: BaseText.regular,
                        ),
                      )
                    ],
                  ),
                  12.height,
                  buildPalletButtonSection(
                    status: receipt.status,
                  ),
                  14.height,
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
      default:
        scanButtonColor = null;
        updateButtonColor = null;
    }

    return Row(
      children: [
        Flexible(
          child: DisableButton(
            height: 40,
            width: double.infinity,
            iconWidget: SvgPicture.asset(
              LocalImages.scanIcons,
              color: ColorName.whiteColor,
            ),
            title: "Scan",
            color: scanButtonColor,
          ),
        ),
        16.width,
        Flexible(
          child: DisableButton(
            height: 40,
            width: double.infinity,
            // width: 156,
            iconWidget: SvgPicture.asset(LocalImages.updatePalleteIcons),
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
            borderRadius: BorderRadius.circular(5),
            side: BorderSide(
              color: borderColor ?? ColorName.grey6Color,
              width: 1,
            )),
        elevation: 0,
        child: Container(
          height: 36,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Center(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: labelTextStyle ??
                  BaseText.baseTextStyle.copyWith(
                    fontSize: 12,
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
        margin: const EdgeInsets.only(bottom: 12),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(6))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 12, 0, 10),
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
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    product0.productName,
                    style: BaseText.grey1Text15,
                  ),
                  Text(
                    product0.code,
                    style: BaseText.baseTextStyle.copyWith(
                      color: ColorName.grey11Color,
                      fontSize: 13,
                      fontWeight: BaseText.light,
                    ),
                  ),
                  10.height,
                  Text(
                    product0.dateTime,
                    style: BaseText.baseTextStyle.copyWith(
                      fontSize: 14,
                      color: ColorName.dateTimeColor,
                    ),
                  ),
                  10.height,
                ],
              ),
            ),
            Row(
              children: [
                _buildBottomCardSection(
                  label: "Receive",
                  value: "11.0 Unit",
                ),
                _buildBottomCardSection(
                  label: "Done",
                  value: "1.0 Unit",
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
        height: 60,
        width: MediaQuery.sizeOf(context).width / 2,
        padding: const EdgeInsets.symmetric(vertical: 12),
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
                    fontSize: 13,
                    color: (isReceive)
                        ? ColorName.receiveLabelColor
                        : ColorName.doneLabelColor),
              ),
              TextSpan(
                text: value,
                style: BaseText.baseTextStyle.copyWith(
                  fontSize: 14,
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
      default:
    }

    return Row(
      children: [
        Flexible(
            child: buildOutlineButton(context,
                label: "Damage", labelTextStyle: labelTextStyle)),
        12.width,
        Flexible(
            child: buildOutlineButton(context,
                label: "Return", labelTextStyle: labelTextStyle)),
      ],
    );
  }
}
