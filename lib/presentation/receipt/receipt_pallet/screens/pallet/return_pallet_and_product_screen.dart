import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inventory_v3/common/components/custom_app_bar.dart';
import 'package:inventory_v3/common/components/custom_divider.dart';
import 'package:inventory_v3/common/components/primary_button.dart';
import 'package:inventory_v3/common/components/reusable_confirm_dialog.dart';
import 'package:inventory_v3/data/model/pallet.dart';

import '../../../../../common/components/reusable_dropdown_menu.dart';
import '../../../../../common/components/reusable_widget.dart';
import '../../../../../common/theme/color/color_name.dart';
import '../../../../../common/theme/text/base_text.dart';
import '../../../../../data/model/return_pallet.dart';

class ReturnPalletAndProductScreen extends StatefulWidget {
  const ReturnPalletAndProductScreen({super.key});

  @override
  State<ReturnPalletAndProductScreen> createState() =>
      _ReturnPalletAndProductScreenState();
}

class _ReturnPalletAndProductScreenState
    extends State<ReturnPalletAndProductScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          onTap: () => Navigator.pop(context),
          title: "Return: Pallet and Product",
        ),
        body: Padding(
          padding: EdgeInsets.all(16.w),
          child: ListView.separated(
              itemCount: 2,
              separatorBuilder: (context, index) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: const CustomDivider(
                      color: ColorName.grey9Color,
                    ),
                  ),
              itemBuilder: (context, index) {
                return SizedBox(
                  height: 30.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Pallet A141",
                        style: BaseText.grey10Text14,
                      ),
                      _buildAddProductButton()
                    ],
                  ),
                );
              }),
        ),
        bottomNavigationBar: buildBottomNavbar(
          child: PrimaryButton(
            onPressed: () {
              Future.delayed(const Duration(milliseconds: 500), () {
                reusableConfirmDialog(
                  context,
                  title: "Confirm Return",
                  message: "Are you sure you want to return this pallet?",
                  onPressed: () {
                    Navigator.pop(context);
                    // Navigator.pop(context);
                  },
                );
              });
            },
            height: 40.h,
            title: "Submit",
          ),
        ),
      ),
    );
  }

  InkWell _buildAddProductButton() {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 13.w,
        ),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              color: ColorName.blue4Color,
            ),
            borderRadius: BorderRadius.circular(5.r),
          ),
        ),
        alignment: Alignment.center,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Text(
          "Add Product",
          textAlign: TextAlign.center,
          style: BaseText.blue4Text11.copyWith(
            fontWeight: BaseText.medium,
          ),
        ),
      ),
    );
  }
}
