import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inventory_v3/common/components/custom_app_bar.dart';

import '../../../../common/components/custom_form.dart';
import '../../../../common/components/primary_button.dart';
import '../../../../common/components/reusable_add_serial_number_button.dart';
import '../../../../common/components/reusable_scan_button.dart';
import '../../../../common/components/reusable_widget.dart';
import '../../../../common/theme/color/color_name.dart';

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
  int addType = 0;
  String tracking = "";

  final serialNumberConhtroller = TextEditingController();
  List<TextEditingController> listSnController = [];

  bool hasScanButton = true;

  @override
  void initState() {
    super.initState();

    addType = widget.addType;

    if (addType == 0) {
      tracking = "Serial Number";
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
              : Container(
                  color: Colors.amber,
                ),
        ),
        bottomNavigationBar: Container(
          width: double.infinity,
          height: 72.h,
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 16.h),
          decoration: const BoxDecoration(
            color: ColorName.whiteColor,
          ),
          child: PrimaryButton(
            onPressed: () {},
            height: 40.h,
            title: "Submit",
          ),
        ),
      ),
    );
  }

  Column _buildSerialNumberSection() {
    return Column(
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
    );
  }
}
