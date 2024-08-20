// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inventory_v3/common/extensions/empty_space_extension.dart';

import '../theme/color/color_name.dart';
import '../theme/text/base_text.dart';

class PrimaryButton extends StatelessWidget {
  double height;
  double? width;
  String title;
  Color? color;
  Widget? icon;
  TextStyle? textStyle;

  void Function()? onPressed;

  PrimaryButton({
    Key? key,
    required this.height,
    this.width,
    required this.title,
    this.color,
    this.icon,
    this.textStyle,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: color ?? ColorName.mainColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: SizedBox(
        height: height,
        width: width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon ?? const SizedBox(),
            (icon != null) ? 6.width : 0.width,
            Text(
              title,
              style: textStyle ??
                  BaseText.whiteText14.copyWith(fontWeight: BaseText.medium),
            ),
          ],
        ),
      ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  double height;
  double? width;
  String title;
  Widget? icon;
  bool? hasBorder;
  Color? colors;
  void Function()? onPressed;

  SecondaryButton({
    Key? key,
    required this.height,
    this.width,
    required this.title,
    this.icon,
    this.hasBorder,
    this.colors,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: (colors != null) ? colors : ColorName.whiteColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
          side: (hasBorder == true)
              ? const BorderSide(
                  color: ColorName.mainColor,
                  width: 1,
                )
              : BorderSide.none),
      child: Container(
        height: height,
        width: width,
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon ?? const SizedBox(),
            (icon != null) ? 6.width : 0.width,
            Text(
              title,
              style: BaseText.mainText12.copyWith(fontWeight: BaseText.regular),
            ),
          ],
        ),
      ),
    );
  }
}

class DisableButton extends StatelessWidget {
  double height;
  double width;
  String title;
  Color? color;

  DisableButton({
    Key? key,
    required this.height,
    required this.width,
    required this.title,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color ?? ColorName.grey4Color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      child: SizedBox(
        height: height,
        width: width,
        child: Center(
            child: Text(
          title,
          style: BaseText.whiteText14.copyWith(fontWeight: BaseText.semiBold),
        )),
      ),
    );
  }
}
