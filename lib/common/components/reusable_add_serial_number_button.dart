import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/color/color_name.dart';
import '../theme/text/base_text.dart';

GestureDetector reusableAddSerialNumberButton({
  void Function()? onTap,
  double? maxwidth,
  bool isCenterTitle = false,
  String? title,
}) {
  return GestureDetector(
    onTap: onTap,
    child: SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          Container(
            width: maxwidth ?? 155.w,
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(6.w),
              color: ColorName.blue2Color,
            ),
            child: Row(
              crossAxisAlignment: (isCenterTitle)
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start,
              mainAxisAlignment: (isCenterTitle)
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              children: [
                Container(
                  height: 16.w,
                  width: 16.w,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.add,
                    color: ColorName.blue1Color,
                    size: 13.h,
                  ),
                ),
                SizedBox(width: 4.w),
                Text(
                  title ?? "Add Serial Number",
                  textAlign: TextAlign.center,
                  style: BaseText.mainText12.copyWith(
                    fontWeight: BaseText.medium,
                    color: ColorName.blue1Color,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
