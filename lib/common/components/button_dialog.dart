// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/color/color_name.dart';
import '../theme/text/base_text.dart';

class PrimaryButtonDialog extends StatelessWidget {
  double height;
  double? width;
  String title;
  Color? color;
  Widget? icon;

  void Function()? onPressed;

  PrimaryButtonDialog({
    Key? key,
    required this.height,
    this.width,
    required this.title,
    this.color,
    this.icon,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: color ?? ColorName.mainColor,
      elevation: 0,
      focusElevation: 0,
      hoverElevation: 0,
      highlightElevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.r)),
      child: SizedBox(
        height: height,
        width: width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon ?? const SizedBox(),
            (icon != null) ? SizedBox(width: 6.w) : SizedBox(width: 0.w),
            Text(
              title,
              style:
                  BaseText.whiteText12.copyWith(fontWeight: BaseText.semiBold),
            ),
          ],
        ),
      ),
    );
  }
}

class SecondaryButtonDialog extends StatelessWidget {
  double height;
  double? width;
  String title;
  Widget? icon;
  bool? hasBorder;
  Color? colors;
  void Function()? onPressed;

  SecondaryButtonDialog({
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
      elevation: 0,
      focusElevation: 0,
      hoverElevation: 0,
      highlightElevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
          side: (hasBorder == true)
              ? const BorderSide(
                  color: ColorName.mainColor,
                  width: 1,
                )
              : BorderSide.none),
      child: SizedBox(
        height: height,
        width: width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon ?? const SizedBox(),
            (icon != null) ? SizedBox(width: 6.w) : SizedBox(width: 0.w),
            Text(
              title,
              style:
                  BaseText.mainText12.copyWith(fontWeight: BaseText.semiBold),
            ),
          ],
        ),
      ),
    );
  }
}

class DisableButtonDialog extends StatelessWidget {
  double height;
  double width;
  String title;
  Color? color;

  DisableButtonDialog({
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
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      child: SizedBox(
        height: height,
        width: width,
        child: Center(
            child: Text(
          title,
          style: BaseText.whiteText12.copyWith(fontWeight: BaseText.semiBold),
        )),
      ),
    );
  }
}
