import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/local_images.dart';
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

GestureDetector buildScanButton() {
  return GestureDetector(
    onTap: () {},
    child: Container(
      height: 36.h,
      width: 82.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: ColorName.mainColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            LocalImages.scanIcons,
            height: 16.w,
            width: 16.w,
          ),
          SizedBox(width: 8.w),
          LimitedBox(
            maxHeight: 16.h,
            child: Text(
              "Scan",
              style: BaseText.mainText14.copyWith(
                color: ColorName.mainColor,
                fontWeight: BaseText.medium,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
