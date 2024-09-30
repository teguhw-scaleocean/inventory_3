import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inventory_v3/common/components/reusable_add_serial_number_button.dart';
import 'package:inventory_v3/common/components/reusable_bottom_sheet.dart';
import 'package:inventory_v3/data/model/pallet.dart';

import '../../../../../common/components/custom_app_bar.dart';
import '../../../../../common/components/primary_button.dart';
import '../../../../../common/components/reusable_confirm_dialog.dart';
import '../../../../../common/components/reusable_dropdown_menu.dart';
import '../../../../../common/components/reusable_scan_button.dart';
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
  final List<dynamic> _listSnSelected = [];
  final List<String> _listSerialNumber = [
    "SN-8286313032",
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
    "Excess inventory",
    "Does not meet standards",
    "Wrong product",
    "Other"
  ];
  List<String> listLocation = [
    "Warehouse A-342-3-4",
    "Warehouse B-342-3-4",
    "Warehouse C-342-3-4",
  ];

  var selectedObjectProduct;
  var selectedProduct;
  var selectedSerialNumber;
  var selectedReason;
  var selectedLocation;

  bool hasProductFocus = false;
  bool hasReasonFocus = false;
  bool hasLocationFocus = false;
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
                          onTap: () {
                            final addSerialNumberBottomSheet =
                                reusableBottomSheet(
                                    context,
                                    isShowDragHandle: false,
                                    SingleChildScrollView(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16.w),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Center(child: reusableDragHandle()),
                                            SizedBox(height: 16.h),
                                            reusableTitleBottomSheet(
                                              context,
                                              title: "Add Serial Number",
                                              isMainColor: false,
                                            ),
                                            SizedBox(height: 16.h),
                                            buildRequiredLabel("Serial Number"),
                                            SizedBox(height: 4.h),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Flexible(
                                                  child: LimitedBox(
                                                    maxWidth: 280.w,
                                                    child: Builder(
                                                        builder: (context) {
                                                      return ReusableDropdownMenu(
                                                        maxHeight: 500.h,
                                                        offset: const Offset(
                                                            0, -15),
                                                        hasSearch: false,
                                                        label: "",
                                                        listOfItemsValue:
                                                            _listSerialNumber
                                                                .map((e) => e)
                                                                .toList(),
                                                        selectedValue:
                                                            selectedSerialNumber,
                                                        hintText:
                                                            "   Select Product",
                                                        hintTextStyle: BaseText
                                                            .grey1Text14
                                                            .copyWith(
                                                          fontWeight:
                                                              BaseText.regular,
                                                          color: ColorName
                                                              .grey12Color,
                                                        ),
                                                        onTap: (focus) {},
                                                        onChange: (value) {
                                                          setState(() {
                                                            // selectedSerialNumber = value;
                                                            _listSnSelected
                                                                .add(value);
                                                            // listSerialNumber = [...listSerialNumber]
                                                            //   ..removeWhere((element) => element == value);
                                                          });

                                                          debugPrint(
                                                              "selectedSerialNumber field 1: ${_listSnSelected.toString()}");
                                                          // debugPrint(
                                                          //     "listSerialNumber: ${listSerialNumber.map((e) => e).toList()}");
                                                        },
                                                      );
                                                    }),
                                                  ),
                                                ),
                                                SizedBox(width: 8.w),
                                                reusableScanButton()
                                              ],
                                            ),
                                            SizedBox(height: 14.h),
                                            buildRequiredLabel("Reason"),
                                            SizedBox(height: 4.h),
                                            ReusableDropdownMenu(
                                              maxHeight: 500.h,
                                              offset: const Offset(0, -15),
                                              hasSearch: false,
                                              label: "",
                                              listOfItemsValue: listReason
                                                  .map((e) => e)
                                                  .toList(),
                                              selectedValue: selectedReason,
                                              isExpand: hasReasonFocus,
                                              hintText: "   Select Reason",
                                              borderColor: (hasReasonFocus)
                                                  ? ColorName.mainColor
                                                  : ColorName.borderColor,
                                              hintTextStyle:
                                                  BaseText.grey1Text14.copyWith(
                                                fontWeight: BaseText.regular,
                                                color: ColorName.grey12Color,
                                              ),
                                              onTap: (focus) {
                                                setState(() {
                                                  hasReasonFocus =
                                                      !hasReasonFocus;
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
                                              listOfItemsValue: listLocation
                                                  .map((e) => e)
                                                  .toList(),
                                              selectedValue: selectedLocation,
                                              isExpand: hasLocationFocus,
                                              hintText: "   Select Location",
                                              borderColor: (hasLocationFocus)
                                                  ? ColorName.mainColor
                                                  : ColorName.borderColor,
                                              hintTextStyle:
                                                  BaseText.grey1Text14.copyWith(
                                                fontWeight: BaseText.regular,
                                                color: ColorName.grey12Color,
                                              ),
                                              onTap: (focus) {
                                                setState(() {
                                                  hasLocationFocus =
                                                      !hasLocationFocus;
                                                });
                                              },
                                              onChange: (value) {
                                                setState(() {
                                                  selectedLocation = value;
                                                });
                                              },
                                            ),
                                            SizedBox(height: 14.h),
                                            PrimaryButton(
                                              onPressed: () {},
                                              height: 40.h,
                                              title: "Submit",
                                            ),
                                            SizedBox(height: 16.h),
                                          ],
                                        ),
                                      ),
                                    ));

                            addSerialNumberBottomSheet.then((value) => null);
                          },
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
