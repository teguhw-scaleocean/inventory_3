import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inventory_v3/common/constants/local_images.dart';

import '../theme/color/color_name.dart';
import '../theme/text/base_text.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({
    super.key,
    required this.title,
  });
  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: AppBar(
        leadingWidth: 40,
        leading: Container(
          padding: const EdgeInsets.only(left: 16),
          child: InkWell(
            onTap: () => Navigator.pop(context),
            child: SvgPicture.asset(LocalImages.backIcon),
          ),
        ),
        title: Text(
          title,
          style: BaseText.blackText16.copyWith(fontWeight: BaseText.semiBold),
        ),
        titleSpacing: 8,
        shape: const Border(
            bottom: BorderSide(
          color: ColorName.grey5Color,
        )),
      ),
    );
  }
}
