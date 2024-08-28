import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/color/color_name.dart';

Widget reusableFloatingActionButton(
    {required void Function() onTap, required IconData icon}) {
  return InkWell(
    onTap: onTap,
    child: Container(
        padding: EdgeInsets.all(15.w),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: ColorName.mainColor,
        ),
        child: Icon(
          icon,
          color: ColorName.whiteColor,
          size: 18.w,
        )),
  );
}
