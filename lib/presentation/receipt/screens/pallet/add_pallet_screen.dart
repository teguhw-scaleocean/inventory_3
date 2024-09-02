import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inventory_v3/common/components/custom_form.dart';
import 'package:inventory_v3/common/components/reusable_dropdown_menu.dart';
import 'package:inventory_v3/data/model/product.dart';

class AddPalletScreen extends StatefulWidget {
  final int index;
  const AddPalletScreen({super.key, required this.index});

  @override
  State<AddPalletScreen> createState() => _AddPalletScreenState();
}

class _AddPalletScreenState extends State<AddPalletScreen> {
  final TextEditingController palletIdController = TextEditingController();
  List<TextEditingController> listSnController = [];

  var selectedProduct;
  bool hasProductFocus = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomFormField(
                title: "Pallet ID",
                isShowTitle: true,
                isRequired: true,
                controller: palletIdController,
                hintText: "Input Pallet ID",
              ),
              SizedBox(height: 14.h),
              ReusableDropdownMenu(
                maxHeight: 120.h,
                label: "Product",
                listOfItemsValue: products3.map((e) => e.productName).toList(),
                selectedValue: selectedProduct,
                isExpand: hasProductFocus,
                hintText: "  Select Product",
                onTap: (focus) {
                  setState(() {
                    hasProductFocus = !hasProductFocus;
                  });
                  debugPrint("hasProductFocus: $hasProductFocus");
                },
                onChange: (value) {},
              )
            ],
          ),
        ),
      ),
    );
  }
}
