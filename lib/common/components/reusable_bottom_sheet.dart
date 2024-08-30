import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/color/color_name.dart';
import '../theme/text/base_text.dart';

Future<dynamic> reusableBottomSheet(BuildContext context, Widget widget,
    {bool? isShowDragHandle}) {
  return showModalBottomSheet(
      showDragHandle: isShowDragHandle ?? true,
      enableDrag: true,
      isDismissible: true,
      useRootNavigator: true,
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.white,
      barrierColor: Colors.black38,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      )),
      builder: (context) => widget);
}

Widget reusableDragHandle() {
  return Container(
    margin: EdgeInsets.only(top: 12.h, bottom: 16.h),
    height: 4.h,
    width: 32.w,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.w), color: ColorName.grey12Color),
  );
}

Row reusableTitleBottomSheet(BuildContext context,
    {required String title, bool isMainColor = false}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: (isMainColor)
            ? BaseText.mainText14.copyWith(fontWeight: BaseText.medium)
            : BaseText.black2Text14.copyWith(fontWeight: BaseText.medium),
      ),
      // const Spacer(flex: 2),
      InkWell(
          onTap: () => Navigator.of(context).maybePop(),
          child: Icon(Icons.close, color: ColorName.grey10Color, size: 16.w)),
    ],
  );
}
