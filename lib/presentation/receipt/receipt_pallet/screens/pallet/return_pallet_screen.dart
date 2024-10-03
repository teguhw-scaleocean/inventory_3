import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inventory_v3/common/components/custom_app_bar.dart';
import 'package:inventory_v3/common/components/primary_button.dart';
import 'package:inventory_v3/common/components/reusable_confirm_dialog.dart';
import 'package:inventory_v3/data/model/pallet.dart';

import '../../../../../common/components/reusable_dropdown_menu.dart';
import '../../../../../common/components/reusable_widget.dart';
import '../../../../../common/theme/color/color_name.dart';
import '../../../../../common/theme/text/base_text.dart';
import '../../../../../data/model/reason.dart';
import '../../../../../data/model/return_pallet.dart';

class ReturnPalletScreen extends StatefulWidget {
  final bool? isDamage;

  const ReturnPalletScreen({super.key, this.isDamage});

  @override
  State<ReturnPalletScreen> createState() => _ReturnPalletScreenState();
}

class _ReturnPalletScreenState extends State<ReturnPalletScreen> {
  var selectedPallet;
  var selectedObjectPallet;
  bool hasPalletFocus = false;

  var selectedReason;
  bool hasReasonFocus = false;

  var selectedLocation;
  bool hasLocationFocus = false;

  List<Pallet> listPalletTemp = [];
  List<String> listReason = [
    "Does not meet standards",
    "Wrong product",
    "Other"
  ];
  List<String> listLocation = ["Warehouse A-342-3-4", "Warehouse B-342-3-4"];

  bool isDamage = false;

  String appbarTitle = "";

  @override
  void initState() {
    super.initState();

    isDamage = widget.isDamage ?? false;

    if (isDamage) {
      appbarTitle = "Damage: Pallet";
      listReason = listDamageReason;
    } else {
      appbarTitle = "Return: Pallet";
    }

    debugPrint(appbarTitle);

    listPalletTemp = listPallets.map((e) {
      return e.copyWith(palletCode: "Pallet ${e.palletCode}");
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          onTap: () => Navigator.pop(context),
          title: appbarTitle,
        ),
        body: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildRequiredLabel("Pallet"),
              SizedBox(height: 4.h),
              ReusableDropdownMenu(
                maxHeight: 500.h,
                offset: const Offset(0, -15),
                hasSearch: false,
                label: "",
                listOfItemsValue:
                    listPalletTemp.map((e) => e.palletCode).toList(),
                selectedValue: selectedPallet,
                isExpand: hasPalletFocus,
                hintText: "   Select Pallet",
                borderColor: (hasPalletFocus)
                    ? ColorName.mainColor
                    : ColorName.borderColor,
                hintTextStyle: BaseText.grey1Text14.copyWith(
                  fontWeight: BaseText.regular,
                  color: ColorName.grey12Color,
                ),
                onTap: (focus) {
                  setState(() {
                    hasPalletFocus = !hasPalletFocus;
                  });
                  debugPrint("hasPalletFocus: $hasPalletFocus");
                },
                onChange: (value) {
                  setState(() {
                    selectedPallet = value;
                    selectedObjectPallet = listPalletTemp
                        .firstWhere((element) => element.palletCode == value);
                  });
                  debugPrint(
                      "selectedObjectPallet: ${selectedObjectPallet.toString()}");
                },
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
                hintText: "   Select Return Location",
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
              if (selectedPallet == null ||
                  selectedReason == null ||
                  selectedLocation == null) {
                return;
              }

              ReturnPallet returnPallet = ReturnPallet(
                id: selectedObjectPallet.id,
                palletCode: selectedPallet,
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
