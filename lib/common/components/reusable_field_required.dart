import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/color/color_name.dart';
import '../theme/text/base_text.dart';

Column reusableFieldRequired() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 4.h),
      Row(
        children: [
          Icon(
            CupertinoIcons.info_circle_fill,
            color: ColorName.badgeRedColor,
            size: 13.w,
          ),
          SizedBox(width: 4.w),
          Text(
            "This field is required. Please fill it in.",
            style: BaseText.red2Text12.copyWith(
              fontWeight: BaseText.light,
            ),
          )
        ],
      )
    ],
  );
}
