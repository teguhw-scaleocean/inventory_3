import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/color/color_name.dart';
import '../theme/text/base_text.dart';

RichText buildRequiredLabel(String label) {
  return RichText(
    text: TextSpan(
        text: label,
        style: BaseText.grey1Text14.copyWith(fontWeight: BaseText.regular),
        children: [
          TextSpan(
            text: " *",
            style: BaseText.redText14.copyWith(
              fontWeight: BaseText.medium,
              color: ColorName.badgeRedColor,
            ),
          ),
        ]),
  );
}

Column buildDisableField({
  required String label,
  required String value,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: BaseText.grey1Text14.copyWith(fontWeight: BaseText.regular),
      ),
      SizedBox(height: 4.h),
      Container(
        height: 40.h,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: ColorName.grey16Color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.w),
            side: const BorderSide(
              color: ColorName.grey9Color,
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              value,
              style: BaseText.grey1Text14.copyWith(
                color: ColorName.grey17Color,
                fontWeight: BaseText.regular,
              ),
            )
          ],
        ),
      ),
      SizedBox(height: 14.h),
    ],
  );
}
