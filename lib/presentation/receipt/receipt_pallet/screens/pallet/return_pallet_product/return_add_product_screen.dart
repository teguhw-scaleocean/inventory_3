import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inventory_v3/common/components/button_dialog.dart';
import 'package:inventory_v3/common/components/custom_app_bar.dart';
import 'package:inventory_v3/data/model/pallet.dart';

import '../../../../../../common/components/custom_form.dart';
import '../../../../../../common/components/custom_quantity_button.dart';
import '../../../../../../common/components/primary_button.dart';
import '../../../../../../common/components/reusable_add_serial_number_button.dart';
import '../../../../../../common/components/reusable_confirm_dialog.dart';
import '../../../../../../common/components/reusable_dropdown_menu.dart';
import '../../../../../../common/components/reusable_scan_button.dart';
import '../../../../../../common/components/reusable_widget.dart';
import '../../../../../../common/theme/color/color_name.dart';
import '../../../../../../common/theme/text/base_text.dart';
import '../../../cubit/count_cubit.dart';
import '../../../cubit/count_state.dart';

class ReturnAddProductScreen extends StatefulWidget {
  final int idTracking;
  final bool? isEdit;

  const ReturnAddProductScreen({
    super.key,
    required this.idTracking,
    this.isEdit,
  });

  @override
  State<ReturnAddProductScreen> createState() => _ReturnAddProductScreenState();
}

class _ReturnAddProductScreenState extends State<ReturnAddProductScreen> {
  final TextEditingController palletIdController = TextEditingController();
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

  var selectedSerialNumber1;
  bool hasSerialNumber1Focus = false;

  var selectedLots;
  bool hasLotsFocus = false;

  String titleAppBar = "";
  bool isEdit = false;

  bool isQtyButtonEnabled = false;

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
  List<String> listLots = [
    "LOTS-NM0983642",
    "LOTS-NM0983643",
    "LOTS-NM0983644",
    "LOTS-NM0983645",
    "LOTS-NM0983646",
    "LOTS-NM0983647",
    "LOTS-NM0983648",
  ];

  List<dynamic> listSnController = [];
  List<dynamic> listSnSelected = [];

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

    isEdit = widget.isEdit ?? false;
    idTracking = widget.idTracking;

    titleAppBar = isEdit == true ? "Edit Product: Pallet A493" : "Add Product";

    if (isEdit == true) {
      selectedProduct = listProduct.first.productName;
      selectedObjectProduct = listProduct.firstWhere(
        (element) => element.productName == selectedProduct,
        orElse: () => listProduct.first,
      );
      selectedSerialNumber = listSerialNumber.first;
      selectedReason = listReason.first;
      selectedLocation = listLocation.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          onTap: () => Navigator.pop(context),
          title: titleAppBar,
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
                    selectedObjectProduct = listProduct.firstWhere(
                        (element) => element.productName == selectedProduct);
                  });
                  debugPrint(
                      "selectedObjectProduct: ${selectedObjectProduct.toString()}");
                },
              ),
              (selectedProduct != null)
                  ? SizedBox(height: 14.h)
                  : const SizedBox(),
              (selectedProduct != null)
                  ? buildDisableField(
                      label: "SKU",
                      value: (idTracking == 0)
                          ? selectedObjectProduct.sku!
                          : selectedObjectProduct.code,
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
                        child: Builder(builder: (context) {
                          return ReusableDropdownMenu(
                            maxHeight: 500.h,
                            offset: const Offset(0, -15),
                            hasSearch: false,
                            label: "",
                            listOfItemsValue:
                                listSerialNumber.map((e) => e).toList(),
                            selectedValue: selectedSerialNumber,
                            hintText: "   Select Product",
                            hintTextStyle: BaseText.grey1Text14.copyWith(
                              fontWeight: BaseText.regular,
                              color: ColorName.grey12Color,
                            ),
                            onTap: (focus) {},
                            onChange: (value) {
                              setState(() {
                                // selectedSerialNumber = value;
                                listSnSelected.add(value);
                                // listSerialNumber = [...listSerialNumber]
                                //   ..removeWhere((element) => element == value);
                              });

                              debugPrint(
                                  "selectedSerialNumber field 1: ${listSnSelected.toString()}");
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
              if (idTracking == 0) SizedBox(height: 6.h),
              if (idTracking == 0)
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
                                child: ReusableDropdownMenu(
                                  maxHeight: 500.h,
                                  offset: const Offset(0, -15),
                                  hasSearch: false,
                                  label: "",
                                  listOfItemsValue:
                                      listSerialNumber.map((e) => e).toList(),
                                  selectedValue: selectedSerialNumber1,
                                  isExpand: hasSerialNumber1Focus,
                                  borderColor: (hasSerialNumber1Focus)
                                      ? ColorName.mainColor
                                      : ColorName.borderColor,
                                  hintText: "   Select Product",
                                  hintTextStyle: BaseText.grey1Text14.copyWith(
                                    fontWeight: BaseText.regular,
                                    color: ColorName.grey12Color,
                                  ),
                                  onTap: (focus) {
                                    setState(() {
                                      hasSerialNumber1Focus =
                                          !hasSerialNumber1Focus;
                                    });
                                    debugPrint(
                                        "hasProductFocus: $hasSerialNumber1Focus");
                                  },
                                  onChange: (value) {
                                    setState(() {
                                      listSnSelected.add(value);
                                    });
                                    debugPrint(
                                        "selectedSerialNumber: ${listSnSelected.map((e) => e).toList()}");
                                  },
                                ),
                              ),
                              SizedBox(width: 8.w),
                              reusableDeleteButton(() {
                                setState(() {
                                  // listSnController[idTracking].clear();
                                  // listSnController[idTracking].dispose();
                                  var removeItemByIndex = index + 1;
                                  listSnController.removeAt(index);
                                  listSnSelected.removeAt(removeItemByIndex);
                                });

                                debugPrint(
                                    "listSnController: ${listSnController.length}");
                                debugPrint(
                                    "selectedSerialNumber: ${listSnSelected.map((e) => e).toList()}");
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
                    setState(() {
                      listSnController.add("empty-${listSnController.length}");

                      debugPrint(
                          "listSnController.length: ${listSnController.length}");
                    });
                  },
                  maxwidth: ScreenUtil().screenWidth - 32.w,
                  isCenterTitle: true,
                ),
              (idTracking == 1)
                  ? StatefulBuilder(builder: (context, otherSetState) {
                      double value = 0.0;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 14.h),
                          buildRequiredLabel("Lots Number"),
                          SizedBox(height: 4.h),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                child: LimitedBox(
                                  maxWidth: 280.w,
                                  child: Builder(builder: (context) {
                                    return ReusableDropdownMenu(
                                      maxHeight: 500.h,
                                      offset: const Offset(0, -15),
                                      hasSearch: false,
                                      label: "",
                                      listOfItemsValue:
                                          listLots.map((e) => e).toList(),
                                      selectedValue: selectedLots,
                                      hintText: "   Select Lots Number",
                                      hintTextStyle:
                                          BaseText.grey1Text14.copyWith(
                                        fontWeight: BaseText.regular,
                                        color: ColorName.grey12Color,
                                      ),
                                      onTap: (focus) {},
                                      onChange: (value) {
                                        setState(() {
                                          selectedLots = value;
                                        });

                                        debugPrint(
                                            "selectedLots: ${selectedLots.toString()}");
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
                          buildRequiredLabel("Quantity"),
                          SizedBox(height: 4.h),
                          BlocConsumer<CountCubit, CountState>(
                              listener: (context, state) {
                            qtyController.value = TextEditingValue(
                              text: state.quantity.toString(),
                            );
                            debugPrint(
                                "qtyController listen: ${qtyController.text}");

                            isQtyButtonEnabled = state.quantity > 0;
                          }, builder: (context, state) {
                            var countCubit = context.read<CountCubit>();

                            borderColor = ColorName.borderColor;

                            qtyIconColor = (isQtyButtonEnabled)
                                ? ColorName.grey10Color
                                : ColorName.grey18Color;
                            qtyTextColor = (isQtyButtonEnabled)
                                ? ColorName.grey10Color
                                : ColorName.grey12Color;

                            return CustomQuantityButton(
                              controller: qtyController,
                              borderColor: borderColor,
                              iconColor: qtyIconColor,
                              textColor: qtyTextColor,
                              onChanged: (v) {
                                if (v.isEmpty || v == "0.0") {
                                  otherSetState(() {
                                    isQtyButtonEnabled = false;
                                  });
                                } else {
                                  otherSetState(() {
                                    isQtyButtonEnabled = true;
                                  });
                                }
                              },
                              onSubmitted: (v) {
                                otherSetState(() {
                                  value = double.parse(v);
                                  qtyController.value = TextEditingValue(
                                    text: value.toString(),
                                  );

                                  countCubit.submit(value);
                                });
                              },
                              onDecreased: () {
                                if (state.quantity >= 1) {
                                  countCubit.decrement(value);
                                }
                              },
                              onIncreased: () {
                                countCubit.increment(value);
                              },
                            );
                          }),
                        ],
                      );
                    })
                  : const SizedBox(),
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
          child: (isEdit)
              ? Row(
                  children: [
                    Flexible(
                      child: SecondaryButtonDialog(
                        onPressed: () {
                          Future.delayed(const Duration(milliseconds: 500), () {
                            reusableConfirmDialog(
                              context,
                              title: "Confirm Return",
                              message:
                                  "Are you sure you want to delete this\nreturned product?",
                              maxLines: 2,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            );
                          });
                        },
                        height: 40.h,
                        width: 160.w,
                        title: "Delete",
                        hasBorder: true,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Flexible(
                      child: PrimaryButtonDialog(
                        onPressed: () {
                          Future.delayed(const Duration(milliseconds: 500), () {
                            reusableConfirmDialog(
                              context,
                              title: "Confirm Return",
                              message:
                                  "Are you sure you want to update this\nreturned product?",
                              maxLines: 2,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            );
                          });
                        },
                        height: 40.h,
                        width: 160.w,
                        title: "Update",
                      ),
                    )
                  ],
                )
              : PrimaryButton(
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
