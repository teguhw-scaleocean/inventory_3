import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inventory_v3/common/components/custom_app_bar.dart';
import 'package:inventory_v3/data/model/pallet.dart';

import '../../../../../../common/components/custom_form.dart';
import '../../../../../../common/components/primary_button.dart';
import '../../../../../../common/components/reusable_add_serial_number_button.dart';
import '../../../../../../common/components/reusable_confirm_dialog.dart';
import '../../../../../../common/components/reusable_dropdown_menu.dart';
import '../../../../../../common/components/reusable_scan_button.dart';
import '../../../../../../common/components/reusable_widget.dart';
import '../../../../../../common/theme/color/color_name.dart';
import '../../../../../../common/theme/text/base_text.dart';

class ReturnAddProductScreen extends StatefulWidget {
  final int idTracking;

  const ReturnAddProductScreen({
    super.key,
    required this.idTracking,
  });

  @override
  State<ReturnAddProductScreen> createState() => _ReturnAddProductScreenState();
}

class _ReturnAddProductScreenState extends State<ReturnAddProductScreen> {
  final TextEditingController palletIdController = TextEditingController();
  List<TextEditingController> listSnController = [];
  TextEditingController snController = TextEditingController();
  TextEditingController qtyController = TextEditingController();
  TextEditingController lotsController = TextEditingController();
  Color qtyIconColor = ColorName.grey18Color;
  Color qtyTextColor = ColorName.grey12Color;
  Color borderColor = ColorName.borderColor;
  Color palletIdBorderColor = ColorName.borderColor;

  int idTracking = 0;

  List<Pallet> listProduct = [];

  var selectedProduct;
  var selectedObjectProduct;
  bool hasProductFocus = false;

  var selectedReason;
  bool hasReasonFocus = false;

  var selectedLocation;
  bool hasLocationFocus = false;

  var selectedSerialNumber;
  bool hasSerialNumberFocus = false;

  List<String> listSerialNumber = [
    "SN-NM1234567845",
    "SN-NM1234567846",
    "SN-NM1234567847",
    // "SN-NM1234567848",
    // "SN-NM1234567849",
    // "SN-NM1234567850",
    // "SN-NM1234567851",
    // "SN-NM1234567852",
    // "SN-NM1234567853",
    // "SN-NM1234567854",
    // "SN-NM1234567855",
    // "SN-NM1234567856",
    // "SN-NM1234567857",
    // "SN-NM1234567858",
    // "SN-NM1234567859",
    // "SN-NM1234567860",
  ];
  List<String> listReason = [
    "Does not meet standards",
    "Wrong product",
    "Other"
  ];
  List<String> listLocation = ["Warehouse A-342-3-4", "Warehouse B-342-3-4"];

  @override
  void initState() {
    super.initState();

    listProduct = listPallets;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          onTap: () => Navigator.pop(context),
          title: "Add Product",
        ),
        body: Container(
          width: double.infinity,
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
                    listProduct.map((e) => e.productName).toList(),
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
                    selectedObjectProduct = listProduct
                        .firstWhere((element) => element.productName == value);
                  });
                  debugPrint(
                      "selectedObjectProduct: ${selectedObjectProduct.toString()}");
                },
              ),
              SizedBox(height: 14.h),
              (selectedProduct != null)
                  ? buildDisableField(
                      label: "SKU",
                      value: selectedObjectProduct.sku!,
                    )
                  : const SizedBox(),
              if (idTracking == 0) buildRequiredLabel("Serial Number"),
              if (idTracking == 0) SizedBox(height: 4.h),
              if (idTracking == 0)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: LimitedBox(
                        maxWidth: 280.w,
                        child: ReusableDropdownMenu(
                          maxHeight: 500.h,
                          offset: const Offset(0, -15),
                          hasSearch: false,
                          label: "",
                          listOfItemsValue:
                              listSerialNumber.map((e) => e).toList(),
                          selectedValue: selectedSerialNumber,
                          isExpand: hasSerialNumberFocus,
                          borderColor: (hasSerialNumberFocus)
                              ? ColorName.mainColor
                              : ColorName.borderColor,
                          hintText: "   Select Product",
                          hintTextStyle: BaseText.grey1Text14.copyWith(
                            fontWeight: BaseText.regular,
                            color: ColorName.grey12Color,
                          ),
                          onTap: (focus) {
                            setState(() {
                              hasSerialNumberFocus = !hasSerialNumberFocus;
                            });
                            debugPrint(
                                "hasProductFocus: $hasSerialNumberFocus");
                          },
                          onChange: (value) {
                            setState(() {
                              selectedSerialNumber = value;
                            });
                            debugPrint(
                                "selectedSerialNumber: ${selectedSerialNumber.toString()}");
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    reusableScanButton()
                  ],
                ),
              if (idTracking == 0) SizedBox(height: 6.h),
              if (idTracking == 0)
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: listSnController.length,
                    itemBuilder: (context, idTracking) {
                      return Column(
                        children: [
                          Row(
                            children: [
                              LimitedBox(
                                maxWidth: 280.w,
                                child: CustomFormField(
                                  title: "",
                                  hintText: "",
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 16.w),
                                  controller: listSnController[idTracking],
                                  isShowTitle: false,
                                  onChanged: (v) {
                                    setState(() {
                                      debugPrint("onChanged: $v");
                                    });
                                  },
                                ),
                              ),
                              SizedBox(width: 8.w),
                              reusableDeleteButton(() {
                                setState(() {
                                  listSnController[idTracking].clear();
                                  listSnController[idTracking].dispose();
                                  listSnController.removeAt(idTracking);
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
              if (idTracking == 0) SizedBox(height: 6.h),
              if (idTracking == 0)
                reusableAddSerialNumberButton(
                  onTap: () {
                    // setState(() {
                    //   listSnController.add(TextEditingController());

                    //   debugPrint(
                    //       "listSnController.length: ${listSnController.length}");
                    // });
                  },
                  maxwidth: ScreenUtil().screenWidth - 32.w,
                  isCenterTitle: true,
                ),
              SizedBox(height: 14.h),
              buildRequiredLabel("Reason"),
              SizedBox(height: 4.h),
              ReusableDropdownMenu(
                maxHeight: 500.h,
                offset: const Offset(0, -15),
                hasSearch: false,
                label: "",
                listOfItemsValue: listReason.map((e) => e).toList(),
                selectedValue: selectedReason,
                isExpand: hasReasonFocus,
                hintText: "   Select Reason",
                borderColor: (hasReasonFocus)
                    ? ColorName.mainColor
                    : ColorName.borderColor,
                hintTextStyle: BaseText.grey1Text14.copyWith(
                  fontWeight: BaseText.regular,
                  color: ColorName.grey12Color,
                ),
                onTap: (focus) {
                  setState(() {
                    hasReasonFocus = !hasReasonFocus;
                  });
                },
                onChange: (value) {
                  setState(() {
                    selectedReason = value;
                  });
                },
              ),
              SizedBox(height: 14.h),
              buildRequiredLabel("Location"),
              SizedBox(height: 4.h),
              ReusableDropdownMenu(
                maxHeight: 500.h,
                offset: const Offset(0, -15),
                hasSearch: false,
                label: "",
                listOfItemsValue: listLocation.map((e) => e).toList(),
                selectedValue: selectedLocation,
                isExpand: hasLocationFocus,
                hintText: "   Select Location",
                borderColor: (hasLocationFocus)
                    ? ColorName.mainColor
                    : ColorName.borderColor,
                hintTextStyle: BaseText.grey1Text14.copyWith(
                  fontWeight: BaseText.regular,
                  color: ColorName.grey12Color,
                ),
                onTap: (focus) {
                  setState(() {
                    hasLocationFocus = !hasLocationFocus;
                  });
                },
                onChange: (value) {
                  setState(() {
                    selectedLocation = value;
                  });
                },
              ),
              SizedBox(height: 14.h),
            ],
          ),
        ),
        bottomNavigationBar: buildBottomNavbar(
          child: PrimaryButton(
            onPressed: () {
              if (selectedProduct != null &&
                  selectedReason != null &&
                  selectedLocation != null) {
                Navigator.pop(context, true);
              }
            },
            height: 40.h,
            title: "Submit",
          ),
        ),
      ),
    );
  }
}
