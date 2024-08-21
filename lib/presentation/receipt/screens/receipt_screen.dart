import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inventory_v3/common/constants/local_images.dart';
import 'package:inventory_v3/common/constants/text_constants.dart';
import 'package:inventory_v3/common/extensions/empty_space_extension.dart';

import '../../../common/theme/color/color_name.dart';
import '../../../common/theme/text/base_text.dart';

class ReceiptScreen extends StatelessWidget {
  ReceiptScreen({super.key});
  List<String> receiptList = ["PALLETE", "PRODUCT", "BOTH"];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: AppBar(
            leadingWidth: 40,
            leading: Container(
              padding: const EdgeInsets.only(left: 16),
              child: const Icon(
                CupertinoIcons.arrow_left,
                color: ColorName.black2Color,
              ),
            ),
            title: Text(
              "Receipt",
              style:
                  BaseText.blackText16.copyWith(fontWeight: BaseText.semiBold),
            ),
            titleSpacing: 8,
            shape: const Border(
                bottom: BorderSide(
              color: ColorName.grey5Color,
            )),
          ),
        ),
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
                    (index) => _buildItemReceipt(index),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Container _buildItemReceipt(int index) {
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

    return Container(
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
    );
  }
}
