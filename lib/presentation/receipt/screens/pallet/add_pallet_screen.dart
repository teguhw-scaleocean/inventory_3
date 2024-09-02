import 'package:flutter/cupertino.dart';
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

  final formKey = GlobalKey<FormState>();

  var selectedProduct;
  var selectedObjectProduct;
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
        body: Column(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomFormField(
                        title: "Pallet ID",
                        isShowTitle: true,
                        isRequired: true,
                        controller: palletIdController,
                        hintText: "Input Pallet ID",
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return "This field is required. Please fill it in.";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 14.h),
                      buildRequiredLabel("Product"),
                      SizedBox(height: 4.h),
                      ReusableDropdownMenu(
                        maxHeight: 160.h,
                        offset: const Offset(0, -15),
                        label: "",
                        listOfItemsValue:
                            products3.map((e) => e.productName).toList(),
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
                        onChange: (value) {
                          setState(() {
                            selectedProduct = value;
                            selectedObjectProduct = products3.firstWhere(
                                (element) => element.productName == value);
                          });
                          debugPrint(
                              "selectedObjectProduct: ${selectedObjectProduct.toString()}");
                        },
                      ),
                      SizedBox(height: 14.h),
                      (selectedProduct != null)
                          ? buildDisableField(
                              label: "SKU",
                              value: selectedObjectProduct.sku,
                            )
                          : const SizedBox(),
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
                                validator: (v) {
                                  if (v == null || v.isEmpty) {
                                    var icon = CupertinoIcons
                                        .info_circle_fill.codePoint
                                        .toRadixString(16);

                                    debugPrint(icon);
                                    return "This field is required. Please fill it in.";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          buildScanButton()
                        ],
                      ),
                      SizedBox(height: 6.h),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: listSnController.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    LimitedBox(
                                      maxWidth: 280.w,
                                      child: CustomFormField(
                                        title: "",
                                        hintText: "",
                                        controller: listSnController[index],
                                        isShowTitle: false,
                                        onChanged: (v) {
                                          setState(() {
                                            debugPrint("onChanged: $v");
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    buildDeleteButton(() {
                                      setState(() {
                                        listSnController[index].clear();
                                        listSnController[index].dispose();
                                        listSnController.removeAt(index);
                                      });

                                      debugPrint(
                                          "listSnController: ${listSnController.length}");
                                    })
                                  ],
                                ),
                                SizedBox(height: 6.h),
                              ],
                            );
                          }),
                      SizedBox(height: 6.h),
                      buildAddSerialNumberButton(onTap: () {
                        setState(() {
                          listSnController.add(TextEditingController());

                          debugPrint(
                              "listSnController.length: ${listSnController.length}");
                        });
                      }),
                      SizedBox(height: 6.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
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
            onPressed: () {
              if (formKey.currentState!.validate()) {
                debugPrint("valid");
              }
            },
            height: 40,
            title: "Submit",
          ),
        ),
      ),
    );
  }

  GestureDetector buildAddSerialNumberButton({void Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
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
      ),
    );
  }

  Column buildDisableField({
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: BaseText.grey1Text14.copyWith(fontWeight: BaseText.regular),
        ),
        SizedBox(height: 4.h),
        Container(
          height: 40.h,
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: ColorName.grey16Color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.w),
              side: const BorderSide(
                color: ColorName.grey9Color,
              ),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                value,
                style: BaseText.grey1Text14.copyWith(
                  color: ColorName.grey17Color,
                  fontWeight: BaseText.regular,
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 14.h),
      ],
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

  GestureDetector buildDeleteButton(void Function()? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40.w,
        width: 40.w,
        padding: EdgeInsets.all(8.w),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(
            color: ColorName.badgeRedColor,
          ),
        ),
        child: const Icon(
          Icons.delete_outlined,
          color: ColorName.badgeRedColor,
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
