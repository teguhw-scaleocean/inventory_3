import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inventory_v3/common/components/custom_app_bar.dart';

import '../../../../common/components/custom_form.dart';
import '../../../../common/components/custom_quantity_button.dart';
import '../../../../common/components/primary_button.dart';
import '../../../../common/components/reusable_add_serial_number_button.dart';
import '../../../../common/components/reusable_scan_button.dart';
import '../../../../common/components/reusable_widget.dart';
import '../../../../common/theme/color/color_name.dart';
import '../../../../data/model/product.dart';

class AddProductScreen extends StatefulWidget {
  final int addType;

  const AddProductScreen({
    super.key,
    required this.addType,
  });

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final formSnKey = GlobalKey<FormState>();
  final noTrackingKey = GlobalKey<FormState>();
  int addType = 0;
  String tracking = "";

  final qtyController = TextEditingController();
  final serialNumberConhtroller = TextEditingController();
  List<TextEditingController> listSnController = [];
  List<SerialNumber> listSerialNumber = [];

  bool hasScanButton = true;

  double totalQty = 0.00;
  Color qtyIconColor = ColorName.grey18Color;
  Color qtyTextColor = ColorName.grey12Color;

  @override
  void initState() {
    super.initState();

    addType = widget.addType;

    if (addType == 0) {
      tracking = "Serial Number";
    } else if (addType == 1) {
      tracking = "Qty No Tracking";
    } else {
      tracking = "Qty Lots";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: "Add $tracking"),
        body: Container(
          padding: EdgeInsets.all(16.w),
          child: (addType == 0)
              ? _buildSerialNumberSection()
              : (addType == 1)
                  ? _buildNoTrackingSection()
                  : _buildLotsSection(),
        ),
        bottomNavigationBar: Container(
          width: double.infinity,
          height: 72.h,
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 16.h),
          decoration: const BoxDecoration(
            color: ColorName.whiteColor,
          ),
          child: PrimaryButton(
            onPressed: () {
              if (addType == 0) {
                if (formSnKey.currentState!.validate()) {
                  if (listSnController.isNotEmpty) {
                    listSnController.map((e) {
                      SerialNumber serialNumber = SerialNumber(
                        id: Random().nextInt(100),
                        label: e.text,
                        expiredDateTime: "Exp. Date: 02/07/2024 - 14:00",
                        quantity: 1,
                      );
                      listSerialNumber.add(serialNumber);
                    }).toList();
                  } else {
                    SerialNumber serialNumber = SerialNumber(
                      id: Random().nextInt(100),
                      label: serialNumberConhtroller.text,
                      expiredDateTime: "Exp. Date: 02/07/2024 - 14:00",
                      quantity: 1,
                    );
                    listSerialNumber.add(serialNumber);
                  }
                }

                debugPrint(
                    "listSerialNumber: $listSerialNumber.map((e) => e.toJson())");
                Navigator.pop(context, listSerialNumber);
              } else if (addType == 1) {
                if (noTrackingKey.currentState!.validate()) {
                  debugPrint("totalQty: $totalQty");
                  // Navigator.pop(context, totalQty);
                }
              }
            },
            height: 40.h,
            title: "Submit",
          ),
        ),
      ),
    );
  }

  Widget _buildLotsSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [],
    );
  }

  Widget _buildNoTrackingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        buildDisableField(label: "SKU", value: "value"),
        SizedBox(height: 14.h),
        buildRequiredLabel("Quantity"),
        SizedBox(height: 4.h),
        Form(
          key: noTrackingKey,
          child: CustomQuantityButton(
            controller: qtyController,
            iconColor: qtyIconColor,
            textColor: qtyTextColor,
            onChanged: (v) {
              // double? inputValue = 0.00;
            },
            onSubmitted: (v) {
              setState(() {
                totalQty = double.tryParse(v) ?? 0.00;

                setState(() {
                  qtyController.value = TextEditingValue(
                    text: totalQty.toString(),
                  );

                  if (totalQty >= 1) {
                    qtyIconColor = ColorName.grey10Color;
                    qtyTextColor = ColorName.grey10Color;
                  }
                });
              });
            },
            onDecreased: () {
              if (totalQty >= 1) {
                setState(() {
                  totalQty--;
                  qtyController.text = totalQty.toString();
                  qtyIconColor = ColorName.grey10Color;
                  qtyTextColor = ColorName.grey10Color;
                });
              }
            },
            onIncreased: () {
              // if (totalQty >= 1) {
              setState(() {
                totalQty++;
                qtyController.text = totalQty.toString();
                qtyIconColor = ColorName.grey10Color;
                qtyTextColor = ColorName.grey10Color;
              });
              // }
            },
          ),
        ),
      ],
    );
  }

  Form _buildSerialNumberSection() {
    return Form(
      key: formSnKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          buildRequiredLabel("Serial Number"),
          SizedBox(height: 4.h),
          (hasScanButton)
              ? Row(
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
                          controller: serialNumberConhtroller,
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return "This field is required. Please fill it in.";
                            }
                            return null;
                          },
                          // onChanged: (v) {
                          //   hasScanButton = v.isEmpty;
                          //   setState(() {});
                          // },
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    reusableScanButton()
                  ],
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: listSnController.length,
                  itemBuilder: (context, index) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            LimitedBox(
                              maxWidth: 280.w,
                              child: CustomFormField(
                                title: "",
                                hintText: "Input Serial Number",
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 16.w),
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

                              if (listSnController.isEmpty) {
                                setState(() => hasScanButton = true);
                              }
                            })
                          ],
                        ),
                        SizedBox(height: 6.h),
                      ],
                    );
                  }),
          SizedBox(height: 6.h),
          reusableAddSerialNumberButton(
            onTap: () {
              setState(() {
                listSnController.add(TextEditingController());
                hasScanButton = false;
              });

              debugPrint("listSnController: ${listSnController.length}");
            },
            maxwidth: MediaQuery.sizeOf(context).width - 32.w,
            isCenterTitle: true,
          )
        ],
      ),
    );
  }
}
