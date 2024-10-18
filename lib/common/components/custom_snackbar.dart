import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/color/color_name.dart';
import '../theme/text/base_text.dart';

class CustomSnackbar {
  Future<void> showSuccessToastMessage(
    BuildContext context, {
    String? title,
    required String message,
    Icon? icon,
    bool? isCheckHere,
    bool? dontPop,
    void Function()? onCheckHere,
  }) {
    return Future.delayed(const Duration(milliseconds: 700), () {
      // Navigator.maybePop(context);

      var snackBar = SnackBar(
        padding:
            EdgeInsets.only(left: 16.w, right: 16.w, bottom: 10.h, top: 10.h),
        // padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.r)),
        backgroundColor: ColorName.red2Color,
        // closeIconColor: ColorName.whiteColor,
        // showCloseIcon: true,
        // duration: const Duration(minutes: 5),
        behavior: SnackBarBehavior.floating,
        content: LimitedBox(
          maxHeight: 55.h,
          child: Wrap(
            children: [
              Row(
                // crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        message,
                        style: BaseText.whiteText12,
                      )
                    ],
                  ),
                  // SizedBox(width: 8.w),
                  GestureDetector(
                    onTap: () => Navigator.maybePop(context),
                    child: icon ??
                        Icon(
                          Icons.cancel,
                          color: ColorName.whiteColor,
                          size: 20.h,
                        ),
                  ),
                  // SizedBox(width: 8.w),
                ],
              ),
            ],
          ),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }
}
