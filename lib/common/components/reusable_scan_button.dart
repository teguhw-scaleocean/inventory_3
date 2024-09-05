import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/local_images.dart';
import '../theme/color/color_name.dart';

GestureDetector reusableScanButton({void Function()? onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: 40.w,
      width: 40.w,
      padding: EdgeInsets.all(12.w),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(
          color: ColorName.mainColor,
        ),
      ),
      child: SvgPicture.asset(
        LocalImages.scanIcons,
        color: ColorName.mainColor,
      ),
    ),
  );
}

GestureDetector reusableDeleteButton(void Function()? onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: 40.w,
      width: 40.w,
      padding: EdgeInsets.all(8.w),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(
          color: ColorName.badgeRedColor,
        ),
      ),
      child: const Icon(
        Icons.delete_outlined,
        color: ColorName.badgeRedColor,
      ),
    ),
  );
}
