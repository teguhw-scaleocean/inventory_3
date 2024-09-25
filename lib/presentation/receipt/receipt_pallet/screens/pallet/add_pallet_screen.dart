import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inventory_v3/common/components/custom_app_bar.dart';
import 'package:inventory_v3/common/components/custom_form.dart';
import 'package:inventory_v3/common/components/custom_quantity_button.dart';
import 'package:inventory_v3/common/components/primary_button.dart';
import 'package:inventory_v3/common/components/reusable_dropdown_menu.dart';
import 'package:inventory_v3/common/components/reusable_field_required.dart';
import 'package:inventory_v3/data/model/pallet.dart';
import 'package:inventory_v3/presentation/receipt/receipt_pallet/cubit/add_pallet_cubit/add_pallet_cubit.dart';

import '../../../../../common/components/reusable_add_serial_number_button.dart';
import '../../../../../common/components/reusable_scan_button.dart';
import '../../../../../common/components/reusable_widget.dart';
import '../../../../../common/constants/local_images.dart';
import '../../../../../common/theme/color/color_name.dart';
import '../../../../../common/theme/text/base_text.dart';
import '../../cubit/count_cubit.dart';
import '../../cubit/count_state.dart';

class AddPalletScreen extends StatefulWidget {
  final int index;
  final bool? isFromBoth;
  const AddPalletScreen({super.key, required this.index, this.isFromBoth});

  @override
  State<AddPalletScreen> createState() => _AddPalletScreenState();
}

class _AddPalletScreenState extends State<AddPalletScreen> {
  final TextEditingController palletIdController = TextEditingController();
  List<TextEditingController> listSnController = [];
  TextEditingController snController = TextEditingController();
  TextEditingController qtyController = TextEditingController();
  TextEditingController lotsController = TextEditingController();
  Color qtyIconColor = ColorName.grey18Color;
  Color qtyTextColor = ColorName.grey12Color;
  Color borderColor = ColorName.borderColor;
  Color palletIdBorderColor = ColorName.borderColor;

  double totalQty = 0.00;

  final formKey = GlobalKey<FormState>();

  var selectedProduct;
  late Pallet selectedObjectProduct;
  bool hasProductFocus = false;
  bool hasLotShow = true;

  bool isFromBoth = false;
  bool isShowRequiredMessage = true;
  bool isQtyButtonEnabled = false;

  int index = 0;

  @override
  void initState() {
    super.initState();

    // listSnController.add(snController);
    index = widget.index;

    if (index == 1 || index == 2) {
      qtyController.text = totalQty.toString();
      debugPrint("qtyController.text: ${qtyController.text}");
    }

    isFromBoth = widget.isFromBoth ?? false;
  }

  List<Pallet> listProduct = [
    Pallet(
      id: 2,
      palletCode: "B490",
      productName: "Stethoscope",
      code: "ST_12942",
      sku: "BPM201-345",
      dateTime: "Sch. Date: 12/07/2024 - 15:30",
      productQty: 1,
    ),
    Pallet(
      id: 3,
      palletCode: "B491",
      productName: "Blood Pressure Monitor",
      code: "BP_12942",
      sku: "BPM201-346",
      dateTime: "Sch. Date: 12/07/2024 - 15:30",
      productQty: 1,
    ),
    Pallet(
      id: 4,
      palletCode: "B492",
      productName: "Thermometer",
      code: "TH_12942",
      sku: "BPM201-347",
      dateTime: "Sch. Date: 12/07/2024 - 15:30",
      productQty: 1,
    ),
    Pallet(
      id: 5,
      palletCode: "B493",
      productName: "Pulse Oximeter",
      code: "PO_12942",
      sku: "BPM201-348",
      dateTime: "Sch. Date: 12/07/2024 - 15:30",
      productQty: 1,
    ),
    Pallet(
      id: 6,
      palletCode: "B494",
      productName: "Surgical Gloves",
      code: "SG_12942",
      sku: "BPM201-349",
      dateTime: "Sch. Date: 12/07/2024 - 15:30",
      productQty: 1,
    ),
    Pallet(
      id: 7,
      palletCode: "B495",
      productName: "Digital Thermometer",
      code: "DT_12942",
      sku: "BPM201-350",
      dateTime: "Sch. Date: 12/07/2024 - 15:30",
      productQty: 1,
    ),
    Pallet(
      id: 8,
      palletCode: "B496",
      productName: "Nebulizer Machine",
      code: "NB_12942",
      sku: "BPM201-351",
      dateTime: "Sch. Date: 12/07/2024 - 15:30",
      productQty: 1,
    ),
    Pallet(
      id: 1,
      palletCode: "B497",
      productName: "Monitor",
      code: "MN_12942",
      sku: "BPM201-352",
      dateTime: "Sch. Date: 12/07/2024 - 15:30",
      productQty: 1,
    )
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const CustomAppBar(title: "Add Pallet"),
        body: Column(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16.w),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StatefulBuilder(builder: (context, palletIdSetState) {
                        return CustomFormField(
                          title: "Pallet ID",
                          isShowTitle: true,
                          isRequired: true,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 16.w),
                          borderColor: (isShowRequiredMessage)
                              ? ColorName.badgeRedColor
                              : palletIdBorderColor,
                          fillTextStyle: BaseText.grey10Text14,
                          controller: palletIdController,
                          hintText: "Input Pallet ID",
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              // return "This field is required. Please fill it in.";
                            }
                            return null;
                          },
                          onChanged: (v) {
                            isShowRequiredMessage = v.isEmpty;
                            setState(() {});
                          },
                        );
                      }),
                      (isShowRequiredMessage)
                          ? reusableFieldRequired()
                          : const SizedBox(),
                      SizedBox(height: 14.h),
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
                              value: selectedObjectProduct.sku!,
                            )
                          : const SizedBox(),
                      if (index == 0) buildRequiredLabel("Serial Number"),
                      if (index == 0) SizedBox(height: 4.h),
                      if (index == 0)
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
                                      // var icon = CupertinoIcons
                                      //     .info_circle_fill.codePoint
                                      //     .toRadixString(16);

                                      // debugPrint(icon);
                                      return "This field is required. Please fill it in.";
                                    }
                                    return null;
                                  },
                                  // onChanged: (v) {
                                  //   snController.text = v;
                                  // },
                                ),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            reusableScanButton()
                          ],
                        ),
                      if (index == 0) SizedBox(height: 6.h),
                      if (index == 0)
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
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 16.w),
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
                                      reusableDeleteButton(() {
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
                      if (index == 0) SizedBox(height: 6.h),
                      if (index == 0)
                        reusableAddSerialNumberButton(onTap: () {
                          setState(() {
                            listSnController.add(TextEditingController());

                            debugPrint(
                                "listSnController.length: ${listSnController.length}");
                          });
                        }),
                      if (index == 1 || index == 2)
                        StatefulBuilder(builder: (context, otherSetState) {
                          double value = 0.0;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // SizedBox(height: 14.h),
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

                                borderColor = (isQtyButtonEnabled)
                                    ? ColorName.borderColor
                                    : ColorName.badgeRedColor;

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
                                    });

                                    countCubit.submit(value);
                                  },
                                  onDecreased: () {
                                    if (state.quantity >= 1) {
                                      countCubit.decrement(value);
                                    }
                                  },
                                  onIncreased: () {
                                    value = double.parse(qtyController.text);

                                    countCubit.increment(value);
                                  },
                                );
                              }),
                              BlocBuilder<CountCubit, CountState>(
                                  builder: (context, state) {
                                if (isQtyButtonEnabled) {
                                  return const SizedBox();
                                }
                                return reusableFieldRequired();
                              }),
                            ],
                          );
                        }),
                      if (index == 2 && selectedProduct != null && !isFromBoth)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 14.h),
                            buildRequiredLabel("Lots"),
                            SizedBox(height: 4.h),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: LimitedBox(
                                    maxWidth: 280.w,
                                    child: CustomFormField(
                                      title: "",
                                      hintText: "Input Lots Number",
                                      fillTextStyle: BaseText.grey10Text14,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 16.w),
                                      isShowTitle: false,
                                      isRequired: true,
                                      controller: lotsController,
                                      validator: (v) {
                                        if (v == null || v.isEmpty) {
                                          // var icon = CupertinoIcons
                                          //     .info_circle_fill.codePoint
                                          //     .toRadixString(16);

                                          // debugPrint(icon);
                                          return "This field is required. Please fill it in.";
                                        }
                                        return null;
                                      },
                                      onChanged: (v) {
                                        hasLotShow = v.isEmpty;
                                        setState(() {});
                                        //   snController.text = v;
                                      },
                                    ),
                                  ),
                                ),
                                Visibility(
                                    visible: hasLotShow,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(width: 8.w),
                                        reusableScanButton(),
                                      ],
                                    ))
                              ],
                            ),
                          ],
                        ),
                      if (isFromBoth &&
                          index == 2 &&
                          qtyController.value.text != "0.0")
                        _buildLotsField(),
                      // ColorName.grey10Color,
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
                final quantityTotal =
                    BlocProvider.of<CountCubit>(context).state.quantity;

                switch (index) {
                  case 0:
                    onSubmitSerialNumber();
                    break;
                  case 1:
                    onSubmitNoTracking(quantityTotal);
                    break;
                  case 2:
                    onSubmitLots(quantityTotal);
                    break;
                  default:
                }

                // context
                //     .read<AddPalletCubit>()
                //     .onSubmit(product: selectedObjectProduct);

                debugPrint(
                    "listProducts: ${listPallets.map((e) => e.toString()).toList()}");
                Navigator.pop(context, listPallets);
              }
            },
            height: 40,
            title: "Submit",
          ),
        ),
      ),
    );
  }

  void onSubmitLots(total) {
    selectedObjectProduct.palletCode = palletIdController.text;
    selectedObjectProduct.productQty = total;
    selectedObjectProduct.lotsCode = lotsController.text;
    listPallets.insert(0, selectedObjectProduct);
  }

  void onSubmitNoTracking(total) {
    selectedObjectProduct.palletCode = palletIdController.text;
    selectedObjectProduct.productQty = total;
    listPallets.insert(0, selectedObjectProduct);
  }

  void onSubmitSerialNumber() {
    // TextField to SerialNumber 1
    debugPrint("serialNumber: -----");
    SerialNumber serialNumber = SerialNumber(
      id: Random().nextInt(100),
      label: snController.text,
      expiredDateTime: "Exp. Date: 02/07/2024 - 14:00",
      quantity: 1,
    );
    selectedObjectProduct.serialNumber = [serialNumber];

    // TextField to SerialNumber Other
    if (listSnController.isNotEmpty) {
      debugPrint("serialNumber: -----not empty");
      var listSerialNumber = listSnController.map((ted) {
        SerialNumber serialNumber = SerialNumber(
          id: Random().nextInt(100),
          label: ted.text,
          expiredDateTime: "Exp. Date: 02/07/2024 - 14:00",
          quantity: 1,
        );
        selectedObjectProduct.serialNumber?.add(serialNumber);
      }).toList();
    }

    debugPrint(
        "serialNumber: ${selectedObjectProduct.serialNumber?.map((e) => e.toString()).toList()}");

    selectedObjectProduct.palletCode = palletIdController.text;
    listPallets.insert(0, selectedObjectProduct);
  }

  Widget _buildLotsField() {
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
                child: CustomFormField(
                  title: "",
                  hintText: "Input Lots Number",
                  fillTextStyle: BaseText.grey10Text14,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                  isShowTitle: false,
                  isRequired: true,
                  controller: lotsController,
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      // var icon = CupertinoIcons
                      //     .info_circle_fill.codePoint
                      //     .toRadixString(16);

                      // debugPrint(icon);
                      return "This field is required. Please fill it in.";
                    }
                    return null;
                  },
                  onChanged: (v) {
                    setState(() {});
                    //   snController.text = v;
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
