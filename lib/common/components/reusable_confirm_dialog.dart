import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/color/color_name.dart';
import '../theme/text/base_text.dart';
import 'button_dialog.dart';

Future<dynamic> reusableConfirmDialog(
  BuildContext context, {
  void Function()? onPressed,
  required String title,
  String? message,
  int? maxLines,
}) {
  return showAdaptiveDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return SimpleDialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 16),
            titlePadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            surfaceTintColor: ColorName.whiteColor,
            children: [
              Container(
                width: ScreenUtil().screenWidth,
                padding: EdgeInsets.all(16.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: BaseText.black2Text14
                              .copyWith(fontWeight: BaseText.medium),
                        ),
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(
                            Icons.close,
                            size: 15,
                            color: ColorName.grey10Color,
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 24.h),
                    Flexible(
                      child: Text(
                        message ?? "",
                        maxLines: maxLines ?? 1,
                        style: BaseText.grey10Text14.copyWith(
                          fontWeight: BaseText.light,
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // mainAxisSize: MainAxisSize.max,
                      children: [
                        Flexible(
                          child: SecondaryButtonDialog(
                            onPressed: () => Navigator.pop(context),
                            height: 40.h,
                            // width: MediaQuery.sizeOf(context).width / 3.2,
                            hasBorder: true,
                            title: "Cancel",
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Flexible(
                          child: PrimaryButtonDialog(
                            onPressed: onPressed,
                            height: 40.h,
                            // width: MediaQuery.sizeOf(context).width / 3.2,
                            title: "Yes",
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ]);
      });
}
