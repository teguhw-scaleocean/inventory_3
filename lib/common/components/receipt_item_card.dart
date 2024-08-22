import 'package:flutter/material.dart';
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
                      style: BaseText.blackText14
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
                // 4.height,
                Row(
                  children: [
                    Text(
                      receipt.dateTime,
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
                      receipt.destination,
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
      ),
    );
  }
}
