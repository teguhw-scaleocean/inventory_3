import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/color/color_name.dart';
import '../theme/text/base_text.dart';

class SearchBarBorder extends StatefulWidget {
  BuildContext context;

  String queryKey;

  dynamic keySearch;

  TextEditingController controller;

  dynamic clearData;

  dynamic onSearch;

  Color? iconColor;

  Color? borderColor;

  SearchBarBorder(
    this.context, {
    Key? key,
    required this.queryKey,
    required this.keySearch,
    required this.controller,
    required this.onSearch,
    required this.clearData,
    this.iconColor,
    this.borderColor,
  }) : super(key: key);

  @override
  State<SearchBarBorder> createState() => _SearchBarBorderState();
}

class _SearchBarBorderState extends State<SearchBarBorder> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.keySearch,
      child: TextFormField(
        keyboardType: TextInputType.text,
        // autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: widget.onSearch,

        // getSelectedValue: (item) {
        //   log(item);
        // },
        controller: widget.controller,
        decoration: InputDecoration(
            prefixIcon: Container(
              padding: const EdgeInsets.only(left: 12, right: 6),
              child: const Icon(
                CupertinoIcons.search,
                size: 14,
              ),
            ),
            prefixIconConstraints: const BoxConstraints(
              minHeight: 25,
              minWidth: 25,
            ),
            prefixIconColor: widget.iconColor ?? ColorName.grey1Color,
            // prefixIconColor: ColorName.greyColor,
            // contentPadding: const EdgeInsets.symmetric(vertical: 10),
            hintText: "Search",
            hintStyle: BaseText.grey1Text14.copyWith(
              fontSize: 12,
              fontWeight: BaseText.light,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: widget.borderColor ?? ColorName.grey7Color,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: widget.borderColor ?? ColorName.grey7Color,
              ),
            ),
            focusColor: ColorName.mainColor,
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: ColorName.mainColor,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8))),
      ),
    );
  }
}
