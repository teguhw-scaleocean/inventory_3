import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inventory_v3/common/components/custom_app_bar.dart';
import 'package:inventory_v3/common/components/custom_divider.dart';
import 'package:inventory_v3/common/components/primary_button.dart';
import 'package:inventory_v3/common/components/reusable_confirm_dialog.dart';
import 'package:inventory_v3/data/model/pallet.dart';
import 'package:inventory_v3/presentation/receipt/receipt_pallet/screens/pallet/return_pallet_product/return_add_product_screen.dart';

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
  int idTracking = 0;
  bool isShowResult = false;

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
                if (isShowResult && index == 0) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      listTileTheme: ListTileTheme.of(context).copyWith(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                    child: ExpansionTile(
                      collapsedShape: const RoundedRectangleBorder(
                        side: BorderSide.none,
                      ),
                      shape: const RoundedRectangleBorder(
                        side: BorderSide.none,
                      ),
                      tilePadding: EdgeInsets.zero,
                      title: Text(
                        "Pallet A14$index",
                        style: BaseText.grey10Text14,
                      ),
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildProductItemCard(),
                            SizedBox(height: 8.h),
                            SizedBox(
                              height: 30.h,
                              child: Row(
                                children: [
                                  _buildAddProductButton(
                                    onTap: () {},
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 8.h),
                          ],
                        )
                      ],
                    ),
                  );
                }

                return SizedBox(
                  height: 30.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Pallet A14$index",
                        style: BaseText.grey10Text14,
                      ),
                      _buildAddProductButton(onTap: () {
                        if (idTracking == 0) {
                          final addProductBySerialNumber = Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReturnAddProductScreen(
                                idTracking: idTracking,
                              ),
                            ),
                          );

                          addProductBySerialNumber.then((value) {
                            setState(() {
                              isShowResult = true;
                            });
                          });
                        }
                      })
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

  InkWell _buildAddProductButton({required void Function()? onTap}) {
    return InkWell(
      onTap: onTap,
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

  Widget buildProductItemCard() {
    return Container(
        // width: 328,
        // height: 126,
        padding: EdgeInsets.all(12.w),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: Color(0xFFEFEFEF)),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Nebulizer Machine",
                  style: BaseText.grey10Text14,
                ),
                Text("Edit", style: BaseText.blue4Text11)
              ],
            ),
            SizedBox(height: 2.h),
            Text(
              "NM928321",
              style: BaseText.grey2Text12.copyWith(
                fontWeight: BaseText.light,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: CustomDivider(thickness: 0.5.h),
            ),
            _buildProductDescPerRow(
              label: "Items: ",
              value: "1",
            ),
            SizedBox(height: 2.h),
            _buildProductDescPerRow(
              label: "Reason: ",
              value: "Overstock",
            ),
            SizedBox(height: 2.h),
            _buildProductDescPerRow(
              label: "Location: ",
              value: "Warehouse A-342-3-4",
            ),
          ],
        ));
  }

  Row _buildProductDescPerRow({
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: BaseText.grey2Text12),
        Text(value,
            style:
                BaseText.grey2Text12.copyWith(color: const Color(0xFF797979))),
      ],
    );
  }
}
