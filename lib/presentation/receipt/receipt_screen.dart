import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../common/components/custom_app_bar.dart';
import '../../common/constants/local_images.dart';
import '../../common/constants/text_constants.dart';
import '../../common/extensions/empty_space_extension.dart';
import '../../common/theme/color/color_name.dart';
import '../../common/theme/text/base_text.dart';
import 'receipt_both/screens/receipt_both_menu_list_screen.dart';
import 'receipt_pallet/screens/receipt_list_screen.dart';
import 'receipt_product/screens/receipt_product_menu_list_screen.dart';

class ReceiptScreen extends StatelessWidget {
  ReceiptScreen({super.key});

  final List<String> receiptList = ["PALLETE", "PRODUCT", "BOTH"];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const CustomAppBar(title: "Receipt"),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              24.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          TextConstants.readyToReceive,
                          style: BaseText.blackText16
                              .copyWith(fontWeight: BaseText.semiBold),
                        ),
                      ),
                      4.height,
                      Text(
                        TextConstants.chooseSubTitle,
                        style: BaseText.grey1Text14,
                      )
                    ],
                  ),
                ],
              ),
              40.height,
              SizedBox(
                child: Column(
                  children: List.generate(
                    receiptList.length,
                    (index) => _buildItemReceipt(context, index),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  InkWell _buildItemReceipt(BuildContext context, int index) {
    String imgPath = "";
    String title = "";
    title = receiptList[index];

    switch (index) {
      case 0:
        imgPath = LocalImages.receiptPalleteImage;
        break;
      case 1:
        imgPath = LocalImages.receiptProductImage;
        break;
      case 2:
        imgPath = LocalImages.receiptBothImage;
        break;
      default:
    }

    return InkWell(
      onTap: () {
        switch (index) {
          case 0:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const ReceiptListScreen(title: "Receipt: Pallete"),
              ),
            );
            break;
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ReceiptProductMenuListScreen(
                    title: "Receipt: Product"),
              ),
            );
            break;
          case 2:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ReceiptBothMenuListScreen(
                  title: "Receipt: Pallet and Product",
                ),
              ),
            );
          default:
        }
      },
      child: Container(
        height: 160,
        width: 160,
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: ColorName.grey6Color,
              width: 1.5,
            )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(imgPath),
            12.height,
            Text(
              title,
              style: BaseText.mainText14.copyWith(fontWeight: BaseText.bold),
            )
          ],
        ),
      ),
    );
  }
}
