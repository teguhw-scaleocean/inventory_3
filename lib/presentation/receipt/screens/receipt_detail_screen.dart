import 'package:flutter/material.dart';
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
          ],
        ),
      ),
    );
  }
}
