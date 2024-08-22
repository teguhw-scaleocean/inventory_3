import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inventory_v3/common/components/custom_app_bar.dart';
import 'package:inventory_v3/common/components/custom_divider.dart';
import 'package:inventory_v3/common/components/primary_button.dart';
import 'package:inventory_v3/common/constants/local_images.dart';

import '../../../common/components/status_badge.dart';
import '../../../common/extensions/empty_space_extension.dart';
import '../../../common/theme/color/color_name.dart';
import '../../../common/theme/text/base_text.dart';

class ReceiptDetailScreen extends StatefulWidget {
  const ReceiptDetailScreen({super.key});

  @override
  State<ReceiptDetailScreen> createState() => _ReceiptDetailScreenState();
}

class _ReceiptDetailScreenState extends State<ReceiptDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const CustomAppBar(title: "Receipt Detail"),
        // body: Container(
        //   padding: const EdgeInsets.symmetric(horizontal: 16),
        //   child: const Column(
        //     children: [],
        //   ),
        // ),
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
                        "WH/IN/00012",
                        style: BaseText.blackText17
                            .copyWith(fontWeight: BaseText.medium),
                      ),
                      const StatusBadge(
                        status: "Waiting",
                        color: ColorName.waitingColor,
                      ),
                    ],
                  ),
                  8.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Package: Pallet",
                        style: BaseText.grey1Text13
                            .copyWith(fontWeight: BaseText.light),
                      ),
                      Text(
                        "Tracking: No Tracking",
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
              child: Row(
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
                    ),
                  ),
                  16.width,
                  Flexible(
                    child: DisableButton(
                      height: 40,
                      width: double.infinity,
                      // width: 156,
                      iconWidget:
                          SvgPicture.asset(LocalImages.updatePalleteIcons),
                      title: "Update Pallete",
                    ),
                  ),
                ],
              ),
            ),
            16.height,
            const CustomDivider(height: 1.0, color: ColorName.grey9Color),
            16.height,
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
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
            Expanded(
              child: Container(
                color: ColorName.backgroundColor,
                child: Row(
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
              ),
            )
          ],
        ),
      ),
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

  Card buildPalleteItemCard() {
    return Card(
      // semanticContainer: true,
      // clipBehavior: Clip.antiAliasWithSaveLayer,
      margin: EdgeInsets.zero,
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
              "A499",
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
                  "Surgical Instruments",
                  style: BaseText.grey1Text15,
                ),
                Text(
                  "SUR_13041",
                  style: BaseText.baseTextStyle.copyWith(
                    color: ColorName.grey11Color,
                    fontSize: 13,
                    fontWeight: BaseText.light,
                  ),
                ),
                10.height,
                Text(
                  "Sch. Date: 14/06/2024 - 15.33",
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
                value: "100.0 Unit",
              ),
              _buildBottomCardSection(
                label: "Done",
                value: "1.0 Unit",
              )
            ],
          ),
        ],
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

  Widget buildPalletButtonSection() {
    return Row(
      children: [
        Flexible(child: buildOutlineButton(context, label: "Damage")),
        12.width,
        Flexible(child: buildOutlineButton(context, label: "Return")),
      ],
    );
  }
}
