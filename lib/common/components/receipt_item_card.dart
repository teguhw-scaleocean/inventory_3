import 'package:flutter/material.dart';

import '../extensions/empty_space_extension.dart';
import '../theme/color/color_name.dart';
import '../theme/text/base_text.dart';
import 'status_badge.dart';

class ReceiptItemCard extends StatelessWidget {
  const ReceiptItemCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 120,
      child: Card(
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
                    "WH/IN/00013",
                    style: BaseText.blackText14
                        .copyWith(fontWeight: BaseText.medium),
                  ),
                  const StatusBadge(
                    status: "Ready",
                    color: ColorName.readyColor,
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
                    "Tracking: Lots",
                    style: BaseText.grey1Text13
                        .copyWith(fontWeight: BaseText.light),
                  )
                ],
              ),
              // 4.height,
              Row(
                children: [
                  Text(
                    "14/06/2024 - 15:30",
                    style: BaseText.grey1Text13
                        .copyWith(fontWeight: BaseText.light),
                  )
                ],
              ),
              10.height,
              const Divider(
                color: ColorName.grey8Color,
                height: 1.0,
                thickness: 1.0,
              ),
              6.height,
              Row(
                children: [
                  Text(
                    "To: Main Storage Area",
                    style: BaseText.mainText13.copyWith(
                      fontWeight: BaseText.semiBold,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
