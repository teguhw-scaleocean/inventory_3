import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../common/components/button_dialog.dart';
import '../../../../../common/components/custom_app_bar.dart';
import '../../../../../common/components/custom_quantity_button.dart';
import '../../../../../common/components/primary_button.dart';
import '../../../../../common/components/product_return_item_card.dart';
import '../../../../../common/components/reusable_add_serial_number_button.dart';
import '../../../../../common/components/reusable_bottom_sheet.dart';
import '../../../../../common/components/reusable_confirm_dialog.dart';
import '../../../../../common/components/reusable_dropdown_menu.dart';
import '../../../../../common/components/reusable_scan_button.dart';
import '../../../../../common/components/reusable_widget.dart';
import '../../../../../common/theme/color/color_name.dart';
import '../../../../../common/theme/text/base_text.dart';
import '../../../../../data/model/pallet.dart';
import '../../../../../data/model/return_pallet.dart';
import '../../../../../data/model/return_product.dart';
import '../../../receipt_pallet/cubit/count_cubit.dart';
import '../../../receipt_pallet/cubit/count_state.dart';

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
  TextEditingController qtyController = TextEditingController();
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
  List<String> listLots = [
    "LOTS-NM0983642",
    "LOTS-NM0983643",
    "LOTS-NM0983644",
    "LOTS-NM0983645",
    "LOTS-NM0983646",
    "LOTS-NM0983647",
    "LOTS-NM0983648",
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

  bool hasProductFocus = false;
  bool hasSerialNumberFocus = false;
  bool hasReasonFocus = false;
  bool hasLocationFocus = false;
  bool isShowResult = false;
  bool isEdit = false;

  int idTracking = 0;

  late ReturnProduct returnProduct;
  var serialNumberBottomSheet;
  String titleMenu = "Add Serial Number";

  var lotsBottomSheet;
  String titleLotsMenu = "Add Lots Number";

  bool isQtyButtonEnabled = false;

  Color qtyIconColor = ColorName.grey18Color;
  Color qtyTextColor = ColorName.grey12Color;
  Color borderColor = ColorName.borderColor;

  late CountCubit countCubit;
  ReturnProduct? returnObject;

  @override
  void initState() {
    super.initState();
    idTracking = widget.idTracking;

    _listProduct = listPallets;

    countCubit = context.read<CountCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          onTap: () => Navigator.pop(context),
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
              (idTracking == 0 && isShowResult)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildRequiredLabel("Serial Number"),
                        SizedBox(height: 6.h),
                        ProductReturnItemCard(
                          onTapEdit: () {
                            isEdit = true;
                            debugPrint("isEdit: $isEdit");
                            titleMenu = "Edit Serial Number";
                            //BottomSheet
                            var selectedSerialNumber = returnProduct.code;
                            var selectedReason = returnProduct.reason;
                            var selectedLocation = returnProduct.location;

                            serialNumberBottomSheet = reusableBottomSheet(
                                context,
                                isShowDragHandle: false,
                                Builder(builder: (context) {
                              return reusableProductBottomSheet(
                                context,
                                // addSetState,
                                titleMenu,
                                isEdit: true,
                                selectedSerialNumber: selectedSerialNumber,
                                selectedReason: selectedReason,
                                selectedLocation: selectedLocation,
                              );
                            }));

                            serialNumberBottomSheet.then((value) {
                              if (value != null) {
                                setState(() {
                                  isShowResult = true;
                                  returnProduct = value;
                                });
                              }
                            });
                          },
                          item: returnProduct,
                        ),
                      ],
                    )
                  : (idTracking == 1 && isShowResult)
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildRequiredLabel("Lots Number"),
                            SizedBox(height: 4.h),
                            ProductReturnItemCard(
                              item: returnProduct,
                              onTapEdit: () {
                                isEdit = true;
                                titleLotsMenu = "Edit Lots Number";
                                //BottomSheet
                                var selectedLotsNumber = returnProduct.code;
                                var selectedReason = returnProduct.reason;
                                var selectedLocation = returnProduct.location;

                                lotsBottomSheet = reusableBottomSheet(context,
                                    isShowDragHandle: false,
                                    Builder(builder: (context) {
                                  return reusableProductBottomSheet(
                                    context,
                                    titleLotsMenu,
                                    isEdit: true,
                                    selectedLotsNumber: selectedLotsNumber,
                                    selectedReason: selectedReason,
                                    selectedLocation: selectedLocation,
                                  );
                                }));

                                lotsBottomSheet.then((value) {
                                  if (value != null) {
                                    setState(() {
                                      isShowResult = true;
                                      returnProduct = value;
                                    });
                                  }
                                });
                              },
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
                            //BottomSheet
                            var selectedSerialNumber;
                            var selectedReason;
                            var selectedLocation;

                            serialNumberBottomSheet = reusableBottomSheet(
                                context,
                                isShowDragHandle: false,
                                Builder(builder: (context) {
                              return reusableProductBottomSheet(
                                context,
                                // addSetState,
                                titleMenu,
                                selectedSerialNumber: selectedSerialNumber,
                                selectedReason: selectedReason,
                                selectedLocation: selectedLocation,
                              );
                            }));

                            serialNumberBottomSheet.then((value) {
                              if (value != null) {
                                setState(() {
                                  isShowResult = true;
                                  returnProduct = value;
                                });
                              }
                            });
                          },
                          maxwidth: ScreenUtil().screenWidth - 32.w,
                          isCenterTitle: true,
                        ),
                      ],
                    )
                  : (idTracking == 1)
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 14.h),
                            reusableAddSerialNumberButton(
                              onTap: () {
                                var selectedLots;
                                var selectedReason;
                                var selectedLocation;

                                lotsBottomSheet = reusableBottomSheet(context,
                                    isShowDragHandle: false, Builder(
                                  builder: (context) {
                                    return reusableProductBottomSheet(
                                      context,
                                      titleLotsMenu,
                                      selectedLotsNumber: selectedLots,
                                      selectedReason: selectedReason,
                                    );
                                  },
                                ));

                                lotsBottomSheet.then((value) {
                                  if (value != null) {
                                    setState(() {
                                      isShowResult = true;
                                      returnProduct = value;
                                    });
                                  }
                                });
                              },
                              maxwidth: ScreenUtil().screenWidth - 32.w,
                              isCenterTitle: true,
                              title: titleLotsMenu,
                            )
                          ],
                        )
                      : const SizedBox(),
            ],
          ),
        ),
        bottomNavigationBar: buildBottomNavbar(
          child: PrimaryButton(
            onPressed: () {
              if (selectedObjectProduct == null || _listProduct.isEmpty) {
                return;
              }

              ReturnPallet returnOfProducts = ReturnPallet(
                id: selectedObjectProduct.id,
                palletCode: selectedObjectProduct.palletCode,
                reason: returnProduct.reason,
                location: returnProduct.location,
              );
              // var returnOfProducts;

              Future.delayed(const Duration(milliseconds: 500), () {
                reusableConfirmDialog(
                  context,
                  title: "Confirm Return",
                  message: "Are you sure you want to return this\nProduct?",
                  maxLines: 2,
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context, returnObject);
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

  Widget reusableProductBottomSheet(
    BuildContext context,
    String titleMenu, {
    selectedSerialNumber,
    selectedLotsNumber,
    selectedReason,
    selectedLocation,
    bool isEdit = false,
  }) {
    return StatefulBuilder(builder: (context, addSetState) {
      double value = 0.0;
      String deleteMessage = "";
      String updateMessage = "";

      if (idTracking == 0) {
        deleteMessage = "Are you sure you want to delete this\nSerial Number?";
        updateMessage = "Are you sure you want to update this\nSerial Number?";
      } else if (idTracking == 1) {
        deleteMessage = "Are you sure you want to delete this\nLots Number?";
        updateMessage = "Are you sure you want to update this\nLots Number?";
      }
      return SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(child: reusableDragHandle()),
              SizedBox(height: 16.h),
              reusableTitleBottomSheet(
                context,
                title: titleMenu,
                isMainColor: false,
              ),
              SizedBox(height: 16.h),
              if (idTracking == 0)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    buildRequiredLabel("Serial Number"),
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
                                    _listSerialNumber.map((e) => e).toList(),
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
                                  addSetState(() {
                                    hasSerialNumberFocus =
                                        !hasSerialNumberFocus;
                                  });
                                },
                                onChange: (value) {
                                  addSetState(() {
                                    // selectedSerialNumber = value;
                                    _listSnSelected.add(value);
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
                  ],
                ),
              if (idTracking == 1)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                                selectedValue: selectedLotsNumber,
                                hintText: "   Select Lots Number",
                                hintTextStyle: BaseText.grey1Text14.copyWith(
                                  fontWeight: BaseText.regular,
                                  color: ColorName.grey12Color,
                                ),
                                onTap: (focus) {},
                                onChange: (value) {
                                  setState(() {
                                    selectedLotsNumber = value;
                                  });

                                  debugPrint(
                                      "selectedLots: ${selectedLotsNumber.toString()}");
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
                      debugPrint("qtyController listen: ${qtyController.text}");

                      isQtyButtonEnabled = state.quantity > 0;
                    }, builder: (context, state) {
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
                            addSetState(() {
                              isQtyButtonEnabled = false;
                            });
                          } else {
                            addSetState(() {
                              isQtyButtonEnabled = true;
                            });
                          }
                        },
                        onSubmitted: (v) {
                          addSetState(() {
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
                ),
              SizedBox(height: 14.h),
              buildRequiredLabel("Reason"),
              SizedBox(height: 4.h),
              ReusableDropdownMenu(
                maxHeight: 120.h,
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
                  addSetState(() {
                    hasReasonFocus = !hasReasonFocus;
                  });
                },
                onChange: (value) {
                  addSetState(() {
                    selectedReason = value;

                    debugPrint("selectedReason: $selectedReason");
                  });
                },
              ),
              SizedBox(height: 14.h),
              buildRequiredLabel("Location"),
              SizedBox(height: 4.h),
              ReusableDropdownMenu(
                maxHeight: 120.h,
                offset: const Offset(0, 121),
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
                  addSetState(() {
                    hasLocationFocus = !hasLocationFocus;
                  });
                },
                onChange: (value) {
                  addSetState(() {
                    selectedLocation = value;
                    debugPrint("selectedLocation: $selectedLocation");
                  });
                },
              ),
              (hasLocationFocus)
                  ? Container(
                      height: 110.h,
                    )
                  : Container(height: 0),
              Padding(
                padding: EdgeInsets.only(
                  top: (hasLocationFocus) ? 36.h : 24.h,
                ),
                child: (isEdit)
                    ? Row(
                        children: [
                          Flexible(
                            child: SecondaryButtonDialog(
                              onPressed: () {
                                Future.delayed(
                                    const Duration(milliseconds: 500), () {
                                  reusableConfirmDialog(
                                    context,
                                    title: "Confirm Delete",
                                    message: deleteMessage,
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
                                Future.delayed(
                                    const Duration(milliseconds: 500), () {
                                  reusableConfirmDialog(
                                    context,
                                    title: "Confirm Update",
                                    message: updateMessage,
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
                          if (idTracking == 0) {
                            if (_listSnSelected.isEmpty ||
                                selectedReason == null ||
                                selectedLocation == null) {
                              return;
                            }
                            returnObject = ReturnProduct(
                              id: 1,
                              code: _listSnSelected.first,
                              reason: selectedReason,
                              location: selectedLocation,
                            );
                          } else if (idTracking == 1) {
                            if (selectedLotsNumber == null ||
                                selectedReason == null ||
                                selectedLocation == null) {
                              return;
                            }
                            var quantity = countCubit.state.quantity;
                            returnObject = ReturnProduct(
                              id: selectedObjectProduct.id,
                              code: selectedLotsNumber,
                              quantity: quantity.toInt(),
                              reason: selectedReason,
                              location: selectedLocation,
                            );
                          }
                          Navigator.pop(context, returnObject);
                        },
                        height: 40.h,
                        title: "Submit",
                      ),
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      );
    });
  }
}
