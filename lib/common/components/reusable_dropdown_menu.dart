// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/color/color_name.dart';
import '../theme/text/base_text.dart';
// import 'package:sales_app/common/extensions/empty_space_extension.dart';

// import '../theme/theme.dart';

// ignore: must_be_immutable
class ReusableDropdownMenu extends StatefulWidget {
  final String label;
  final String? hintText;
  final List<dynamic> listOfItemsValue;
  final dynamic selectedValue;
  final Function(dynamic)? onChange;
  final Function(bool)? onTap;
  final double? maxHeight;
  // bool isSimpleWidget;
  final Offset? offset;
  final Color? borderColor;
  final TextEditingController? controller;
  bool isExpand;

  ReusableDropdownMenu({
    Key? key,
    required this.label,
    required this.listOfItemsValue,
    required this.selectedValue,
    this.onChange,
    // this.isSimpleWidget = false,
    this.hintText,
    this.onTap,
    this.maxHeight,
    this.offset,
    this.borderColor,
    this.isExpand = false,
    this.controller,
  }) : super(key: key);

  @override
  State<ReusableDropdownMenu> createState() => _ReusableDropdownMenuState();
}

class _ReusableDropdownMenuState extends State<ReusableDropdownMenu> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.label.isNotEmpty)
            Text(widget.label,
                style: BaseText.grey2Text12.copyWith(
                    fontWeight: BaseText.regular, color: ColorName.grey2Color)),
          (widget.label.isEmpty)
              ? const SizedBox(height: 0)
              : SizedBox(height: 4.h),
          DropdownButtonHideUnderline(
            child: Container(
              // height: 45,
              padding: EdgeInsets.only(top: 12.h, bottom: 12.h),
              decoration: BoxDecoration(
                  color: ColorName.whiteColor,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                      color: widget.borderColor ?? ColorName.borderColor)),
              child: DropdownButtonFormField2(
                decoration: InputDecoration.collapsed(
                  hintText: widget.hintText,
                  hintStyle: BaseText.grey2Text12.copyWith(
                    color: ColorName.grey2Color,
                    fontWeight: BaseText.light,
                  ),
                ),
                // icon: const Icon(Icons.keyboard_arrow_down_rounded),
                value: widget.selectedValue,
                items: widget.listOfItemsValue.map<DropdownMenuItem>((e) {
                  return DropdownMenuItem(
                      value: e,
                      child: Text(
                        e,
                        style: BaseText.grey2Text12
                            .copyWith(fontWeight: BaseText.light),
                      ));
                }).toList(),
                onChanged: widget.onChange,
                //            onSaved: (value) {
                //   selectedValue = value.toString();
                // },

                selectedItemBuilder: (context) => widget.listOfItemsValue
                    .map((e) => Text(
                          e,
                          style: BaseText.grey2Text12
                              .copyWith(fontWeight: BaseText.regular),
                        ))
                    .toList(),
                buttonStyleData: const ButtonStyleData(
                  padding: EdgeInsets.zero,
                ),
                iconStyleData: IconStyleData(
                  icon: Padding(
                    padding: EdgeInsets.only(right: 16.w),
                    child: (widget.isExpand)
                        ? const Icon(Icons.keyboard_arrow_up_rounded,
                            color: ColorName.grey2Color)
                        : const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: ColorName.grey2Color,
                          ),
                  ),
                ),
                dropdownStyleData: DropdownStyleData(
                  maxHeight: widget.maxHeight,
                  offset: widget.offset ?? const Offset(0, -10),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  elevation: 1,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.r),
                    ),
                    color: ColorName.whiteColor,
                  ),
                  scrollbarTheme: ScrollbarThemeData(
                      radius: const Radius.circular(99),
                      thickness: MaterialStateProperty.all(6),
                      thumbColor: MaterialStateColor.resolveWith(
                          (states) => ColorName.grey15Color)
                      // thumbVisibility: MaterialStateProperty.all(true),
                      ),
                ),
                menuItemStyleData: const MenuItemStyleData(
                  padding: EdgeInsets.zero,
                ),
                onMenuStateChange: widget.onTap,
                dropdownSearchData: DropdownSearchData(
                  searchController: widget.controller,
                  searchMatchFn: (item, searchValue) {
                    // final searchResult = widget.listOfItemsValue
                    //     .firstWhere((element) => element == item);
                    final result = item.value.toString().contains(searchValue);
                    log("result: $result");
                    return result;
                  },
                  searchInnerWidgetHeight: 45.h,
                  searchInnerWidget: (widget.listOfItemsValue.length <= 4)
                      ? const SizedBox()
                      : Container(
                          height: 45.h,
                          margin: EdgeInsets.all(8.w),
                          child: TextFormField(
                              controller: widget.controller,
                              decoration: InputDecoration(
                                hintText: widget.hintText,
                                hintStyle: BaseText.grey2Text14.copyWith(
                                  fontWeight: BaseText.regular,
                                  color: ColorName.grey12Color,
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: const BorderSide(
                                        color: ColorName.borderColor)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: const BorderSide(
                                        color: ColorName.borderColor)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: const BorderSide(
                                        color: ColorName.mainColor)),
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: const BorderSide(
                                        color: ColorName.redColor)),
                                // contentPadding:
                                //     EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                hoverColor: ColorName.mainColor,
                                focusColor: ColorName.mainColor,
                              )),
                        ),
                ),
                //  ??
                //     (value) {
                //       if (!widget.isExpand) {
                //         setState(() {
                //           widget.isExpand = true;
                //         });
                //       } else {
                //         setState(() {
                //           widget.isExpand = false;
                //         });
                //       }

                // debugPrint(widget.isExpand.toString());
                // },
                // (value) {
                //   widget.newSetState!(() {
                //     widget.selectedValue = value;

                //     log(widget.selectedValue.name);
                //   });
                // }
              ),
            ),
          )
        ],
      ),
    );
  }
}
