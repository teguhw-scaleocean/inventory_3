import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inventory_v3/common/constants/local_images.dart';

import '../theme/color/color_name.dart';
import '../theme/text/base_text.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final void Function()? onTap;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onTap,
  });
  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: AppBar(
        leadingWidth: 40.w,
        leading: Container(
          padding: EdgeInsets.only(left: 16.w),
          child: InkWell(
            onTap: onTap ?? () => Navigator.pop(context),
            child: SvgPicture.asset(
              LocalImages.backIcon,
              height: 24.w,
              width: 24.w,
              fit: BoxFit.scaleDown,
            ),
          ),
        ),
        title: Text(
          title,
          style: BaseText.blackText16.copyWith(fontWeight: BaseText.semiBold),
        ),
        titleSpacing: 8.w,
        shape: const Border(
            bottom: BorderSide(
          color: ColorName.grey5Color,
        )),
      ),
    );
  }
}
