import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inventory_v3/common/components/custom_form.dart';
import 'package:inventory_v3/common/components/primary_button.dart';
import 'package:inventory_v3/common/components/reusable_dropdown_menu.dart';
import 'package:inventory_v3/data/model/product.dart';

import '../../../../common/constants/local_images.dart';
import '../../../../common/theme/color/color_name.dart';
import '../../../../common/theme/text/base_text.dart';

class AddPalletScreen extends StatefulWidget {
  final int index;
  const AddPalletScreen({super.key, required this.index});

  @override
  State<AddPalletScreen> createState() => _AddPalletScreenState();
}

class _AddPalletScreenState extends State<AddPalletScreen> {
  final TextEditingController palletIdController = TextEditingController();
  List<TextEditingController> listSnController = [];
  TextEditingController snController = TextEditingController();

  var selectedProduct;
  bool hasProductFocus = false;

  @override
  void initState() {
    super.initState();

    // listSnController.add(snController);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomFormField(
                title: "Pallet ID",
                isShowTitle: true,
                isRequired: true,
                controller: palletIdController,
                hintText: "Input Pallet ID",
              ),
              SizedBox(height: 14.h),
              buildRequiredLabel("Product"),
              SizedBox(height: 4.h),
              ReusableDropdownMenu(
                maxHeight: 120.h,
                label: "",
                listOfItemsValue: products3.map((e) => e.productName).toList(),
                selectedValue: selectedProduct,
                isExpand: hasProductFocus,
                hintText: "  Select Product",
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
                onChange: (value) {},
              ),
              SizedBox(height: 14.h),
              buildRequiredLabel("Serial Number"),
              SizedBox(height: 4.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: LimitedBox(
                      maxWidth: 280.w,
                      child: CustomFormField(
                        title: "",
                        hintText: "Input Serial Number",
                        isShowTitle: false,
                        isRequired: true,
                        controller: snController,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  buildScanButton()
                ],
              ),
              SizedBox(height: 6.h),
              SizedBox(
                width: double.infinity,
                child: Row(
                  children: [
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: 155.w,
                      ),
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(6.w),
                        color: ColorName.blue2Color,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 16.w,
                            width: 16.w,
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.add,
                              color: ColorName.blue1Color,
                              size: 13.h,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            "Add Serial Number",
                            textAlign: TextAlign.center,
                            style: BaseText.mainText12.copyWith(
                              fontWeight: BaseText.medium,
                              color: ColorName.blue1Color,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: Container(
          width: double.infinity,
          height: 72.h,
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 16.h),
          decoration: const BoxDecoration(
            color: ColorName.whiteColor,
            boxShadow: [
              BoxShadow(
                color: Color(0x33333A51),
                blurRadius: 16,
                offset: Offset(0, 4),
                spreadRadius: 0,
              )
            ],
          ),
          child: PrimaryButton(
            onPressed: () {},
            height: 40,
            title: "Submit",
          ),
        ),
      ),
    );
  }

  GestureDetector buildScanButton({void Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40.w,
        width: 40.w,
        padding: EdgeInsets.all(12.w),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(
            color: ColorName.mainColor,
          ),
        ),
        child: SvgPicture.asset(
          LocalImages.scanIcons,
          color: ColorName.mainColor,
        ),
      ),
    );
  }

  RichText buildRequiredLabel(String label) {
    return RichText(
      text: TextSpan(
          text: label,
          style: BaseText.grey1Text14.copyWith(fontWeight: BaseText.regular),
          children: [
            TextSpan(
              text: " *",
              style: BaseText.redText14.copyWith(
                fontWeight: BaseText.medium,
                color: ColorName.badgeRedColor,
              ),
            ),
          ]),
    );
  }
}
