import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inventory_v3/common/components/custom_app_bar.dart';
import 'package:inventory_v3/presentation/receipt/receipt_pallet/cubit/count_cubit.dart';
import 'package:inventory_v3/presentation/receipt/receipt_pallet/cubit/count_state.dart';

import '../../../../../common/components/custom_form.dart';
import '../../../../../common/components/custom_quantity_button.dart';
import '../../../../../common/components/primary_button.dart';
import '../../../../../common/components/reusable_add_serial_number_button.dart';
import '../../../../../common/components/reusable_scan_button.dart';
import '../../../../../common/components/reusable_widget.dart';
import '../../../../../common/theme/color/color_name.dart';
import '../../../../../common/theme/text/base_text.dart';
import '../../../../../data/model/product.dart';

class AddProductScreen extends StatefulWidget {
  final int addType;
  final String code;

  const AddProductScreen({
    super.key,
    required this.addType,
    this.code = "",
  });

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final formSnKey = GlobalKey<FormState>();
  final noTrackingKey = GlobalKey<FormState>();
  int addType = 0;
  String tracking = "";

  var qtyController = TextEditingController();
  final serialNumberConhtroller = TextEditingController();
  List<TextEditingController> listSnController = [];
  List<SerialNumber> listSerialNumber = [];

  bool hasScanButton = true;

  String label = "";
  String code = "";
  double totalQty = 0.00;
  Color qtyIconColor = ColorName.grey18Color;
  Color qtyTextColor = ColorName.grey12Color;
  Color borderColor = ColorName.borderColor;

  @override
  void initState() {
    super.initState();

    addType = widget.addType;

    if (addType == 0) {
      tracking = "Serial Number";
    } else if (addType == 1) {
      tracking = "Qty No Tracking";
      label = "SKU";
      code = widget.code;
      qtyController.text = totalQty.toString();
    } else {
      tracking = "Qty Lots";
      label = "LOTS";
      code = widget.code;
      qtyController.text = totalQty.toString();
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
              : _buildOtherSection(label, code),
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
              } else {
                var checkResultQty = context.read<CountCubit>().state.quantity;
                debugPrint("checkResultQty: $checkResultQty");
                totalQty = checkResultQty;
                debugPrint("totalQty: $totalQty");
                if (totalQty > 0) {
                  Navigator.pop(context, totalQty);
                }
                return;
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

  Widget _buildOtherSection(String labels, String code) {
    bool isQtyButtonEnabled = false;

    return StatefulBuilder(builder: (context, otherSetState) {
      double value = 0.0;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          buildDisableField(label: labels, value: code),
          SizedBox(height: 14.h),
          buildRequiredLabel("Quantity"),
          SizedBox(height: 4.h),
          BlocConsumer<CountCubit, CountState>(listener: (context, state) {
            qtyController.value = TextEditingValue(
              text: state.quantity.toString(),
            );
            debugPrint("qtyController listen: ${qtyController.text}");

            isQtyButtonEnabled = state.quantity > 0;
          }, builder: (context, state) {
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
                // otherSetState(() {
                // totalQty = double.tryParse(v) ?? 0.00;

                // // setState(() {
                // qtyController.value = TextEditingValue(
                //   text: totalQty.toString(),
                // );

                // if (totalQty >= 1) {
                //   qtyIconColor = ColorName.grey10Color;
                //   qtyTextColor = ColorName.grey10Color;
                // }
                // });
                // });
              },
              onDecreased: () {
                // if (totalQty != 0.0) {
                //   otherSetState(() {
                //     totalQty--;
                //     qtyController =
                //         TextEditingController(text: totalQty.toString());
                //     qtyIconColor = ColorName.grey10Color;
                //     qtyTextColor = ColorName.grey10Color;
                //     debugPrint("totalQty Increased: $totalQty");
                //   });
                // } else {
                //   otherSetState(() {
                //     borderColor = ColorName.badgeRedColor;
                //     qtyIconColor = ColorName.grey18Color;
                //   });
                // }
                if (state.quantity >= 1) {
                  context.read<CountCubit>().decrement(value);
                  // qtyController =
                  //     TextEditingController(text: state.quantity.toString());
                }
              },
              onIncreased: () {
                value = double.parse(qtyController.text);
                // if (totalQty >= 1) {
                // otherSetState(() {
                //   qtyIconColor = ColorName.grey10Color;
                //   qtyTextColor = ColorName.grey10Color;
                //   borderColor = ColorName.borderColor;
                //   totalQty++;
                //   qtyController =
                //       TextEditingController(text: totalQty.toString());
                // });
                // }
                context.read<CountCubit>().increment(value);
                // qtyController =
                //     TextEditingController(text: state.quantity.toString());
              },
            );
          }),
          BlocBuilder<CountCubit, CountState>(builder: (context, state) {
            if (isQtyButtonEnabled) {
              return const SizedBox();
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(
                      CupertinoIcons.info_circle_fill,
                      color: ColorName.badgeRedColor,
                      size: 13.w,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      "This field is required. Please fill it in.",
                      style: BaseText.red2Text12.copyWith(
                        fontWeight: BaseText.light,
                      ),
                    )
                  ],
                )
              ],
            );
          }),
        ],
      );
    });
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
