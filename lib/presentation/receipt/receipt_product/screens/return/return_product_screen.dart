import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inventory_v3/common/components/reusable_add_serial_number_button.dart';
import 'package:inventory_v3/data/model/pallet.dart';

import '../../../../../common/components/custom_app_bar.dart';
import '../../../../../common/components/primary_button.dart';
import '../../../../../common/components/reusable_confirm_dialog.dart';
import '../../../../../common/components/reusable_dropdown_menu.dart';
import '../../../../../common/components/reusable_widget.dart';
import '../../../../../common/theme/color/color_name.dart';
import '../../../../../common/theme/text/base_text.dart';
import '../../../../../data/model/return_pallet.dart';

class ReturnProductScreen extends StatefulWidget {
  final int idTracking;

  const ReturnProductScreen({
    super.key,
    required this.idTracking,
  });

  @override
  State<ReturnProductScreen> createState() => _ReturnProductScreenState();
}

class _ReturnProductScreenState extends State<ReturnProductScreen> {
  List<Pallet> _listProduct = [];

  var selectedObjectProduct;
  var selectedProduct;
  var selectedReason;
  var selectedLocation;

  bool hasProductFocus = false;
  int idTracking = 0;

  @override
  void initState() {
    super.initState();
    idTracking = widget.idTracking;

    _listProduct = listPallets;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          onTap: () {},
          title: "Return: Product",
        ),
        body: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildRequiredLabel("Product"),
              SizedBox(height: 4.h),
              ReusableDropdownMenu(
                maxHeight: 500.h,
                offset: const Offset(0, -15),
                hasSearch: false,
                label: "",
                listOfItemsValue:
                    _listProduct.map((e) => e.productName).toList(),
                selectedValue: selectedProduct,
                isExpand: hasProductFocus,
                borderColor: (hasProductFocus)
                    ? ColorName.mainColor
                    : ColorName.borderColor,
                hintText: "   Select Product",
                hintTextStyle: BaseText.grey1Text14.copyWith(
                  fontWeight: BaseText.regular,
                  color: ColorName.grey12Color,
                ),
                onTap: (focus) {
                  setState(() {
                    hasProductFocus = !hasProductFocus;
                  });
                  debugPrint("hasProductFocus: $hasProductFocus");
                },
                onChange: (value) {
                  setState(() {
                    selectedProduct = value;
                    selectedObjectProduct = _listProduct.firstWhere(
                        (element) => element.productName == selectedProduct);
                  });
                  debugPrint(
                      "selectedObjectProduct: ${selectedObjectProduct.toString()}");
                },
              ),
              (selectedProduct != null)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 14.h),
                        buildDisableField(
                          label: "SKU",
                          value: (idTracking == 0)
                              ? selectedObjectProduct.sku!
                              : selectedObjectProduct.code,
                        )
                      ],
                    )
                  : const SizedBox(),
              (idTracking == 0)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 14.h),
                        reusableAddSerialNumberButton(
                          onTap: () {},
                          maxwidth: ScreenUtil().screenWidth - 32.w,
                          isCenterTitle: true,
                        ),
                      ],
                    )
                  : const SizedBox(),
            ],
          ),
        ),
        bottomNavigationBar: buildBottomNavbar(
          child: PrimaryButton(
            onPressed: () {
              if (selectedProduct == null ||
                  selectedReason == null ||
                  selectedLocation == null) {
                return;
              }

              ReturnPallet returnPallet = ReturnPallet(
                id: selectedObjectProduct.id,
                palletCode: selectedProduct,
                reason: selectedReason,
                location: selectedLocation,
              );

              Future.delayed(const Duration(milliseconds: 500), () {
                reusableConfirmDialog(
                  context,
                  title: "Confirm Return",
                  message: "Are you sure you want to return this pallet?",
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context, returnPallet);
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
}
