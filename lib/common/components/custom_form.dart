import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inventory_v3/common/extensions/empty_space_extension.dart';

import '../theme/color/color_name.dart';
import '../theme/text/base_text.dart';

class CustomFormField extends StatefulWidget {
  final String title;
  final TextStyle? textStyle;
  final TextStyle? fillTextStyle;
  final String hintText;
  final TextEditingController? controller;
  final bool isShowTitle;
  final bool isRequired;
  final bool? isTextArea;
  void Function(String)? onChanged;
  String? Function(String?)? validator;
  final EdgeInsets? contentPadding;
  // final Function(String)? onFieldSubmitted;

  CustomFormField({
    Key? key,
    required this.title,
    this.textStyle,
    this.fillTextStyle,
    required this.hintText,
    this.controller,
    this.isShowTitle = true,
    this.isTextArea = false,
    this.isRequired = false,
    this.onChanged,
    this.validator,
    this.contentPadding,
    // this.onFieldSubmitted,
  }) : super(key: key);

  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  var text = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.isShowTitle && !widget.isRequired)
          Text(
            widget.title,
            style: (widget.textStyle != null)
                ? widget.textStyle
                : BaseText.grey1Text14.copyWith(
                    fontWeight: BaseText.regular,
                  ),
          ),
        if (widget.isShowTitle && widget.isRequired)
          RichText(
            text: TextSpan(
                text: widget.title,
                style:
                    BaseText.grey1Text14.copyWith(fontWeight: BaseText.regular),
                children: [
                  TextSpan(
                    text: " *",
                    style: BaseText.redText14.copyWith(
                      fontWeight: BaseText.medium,
                      color: ColorName.badgeRedColor,
                    ),
                  ),
                ]),
          ),
        if (widget.isShowTitle && !widget.isRequired ||
            widget.isShowTitle && widget.isRequired)
          4.height,
        TextFormField(
            controller: widget.controller,
            validator: widget.validator,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onTapOutside: (event) =>
                FocusManager.instance.primaryFocus!.unfocus(),
            onChanged: widget.onChanged,
            keyboardType:
                (widget.isTextArea == true) ? TextInputType.multiline : null,
            minLines: (widget.isTextArea == true) ? 3 : 1,
            maxLines: (widget.isTextArea == true) ? null : 1,
            style: widget.fillTextStyle ??
                BaseText.grey1Text14.copyWith(
                  fontWeight: BaseText.light,
                ),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: BaseText.grey2Text14.copyWith(
                fontWeight: BaseText.regular,
              ),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(color: ColorName.borderColor)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(color: ColorName.borderColor)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(color: ColorName.mainColor)),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(color: ColorName.redColor)),
              contentPadding: widget.contentPadding ??
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              hoverColor: ColorName.mainColor,
              focusColor: ColorName.mainColor,
            )
            // onFieldSubmitted: onFieldSubmitted,
            ),
      ],
    );
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    }
    return null;
  }
}

class CustomFormPassword extends StatefulWidget {
  final String title;
  final String hintText;
  bool obscureText;
  final TextEditingController? controller;
  final bool isShowTitle;
  final EdgeInsets? contentPadding;
  String? Function(String?)? validator;
  // final Function(String)? onFieldSubmitted;

  CustomFormPassword({
    Key? key,
    required this.title,
    required this.hintText,
    this.obscureText = false,
    this.controller,
    this.isShowTitle = true,
    this.contentPadding,
    this.validator,
    // this.onFieldSubmitted,
  }) : super(key: key);

  @override
  State<CustomFormPassword> createState() => _CustomFormPasswordState();
}

class _CustomFormPasswordState extends State<CustomFormPassword> {
  bool isSecure = false;
  var textPassword = '';
  // late Function iconState;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.isShowTitle)
          Text(
            widget.title,
            style: BaseText.grey1Text14.copyWith(
              fontWeight: BaseText.regular,
            ),
          ),
        if (widget.isShowTitle) const SizedBox(height: 4),
        TextFormField(
          obscureText: isSecure,
          obscuringCharacter: '●',
          style: BaseText.blackText12.copyWith(
            fontWeight: (!isSecure) ? BaseText.light : BaseText.black,
            color: ColorName.blackNewColor,
          ),
          controller: widget.controller,
          validator: widget.validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onTapOutside: (event) =>
              FocusManager.instance.primaryFocus!.unfocus(),
          decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: BaseText.grey2Text14.copyWith(
                fontWeight: BaseText.regular,
              ),
              contentPadding: widget.contentPadding ?? const EdgeInsets.all(12),
              hoverColor: ColorName.mainColor,
              focusColor: ColorName.mainColor,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(color: ColorName.borderColor)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(color: ColorName.borderColor)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(color: ColorName.mainColor)),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(color: ColorName.redColor)),
              suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      isSecure = !isSecure;
                    });
                    log(isSecure.toString());
                  },
                  icon: SizedBox(
                    width: 18,
                    height: 18,
                    child: Icon(
                      (!isSecure) ? Icons.visibility : Icons.visibility_off,
                      color: ColorName.grey3Color,
                      size: 16.5,
                    ),
                  ))),
          // onFieldSubmitted: onFieldSubmitted,
        ),
      ],
    );
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password wajib diisi';
    }
    return null;
  }
}
