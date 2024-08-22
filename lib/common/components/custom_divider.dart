import 'package:flutter/material.dart';

import '../theme/color/color_name.dart';

class CustomDivider extends StatelessWidget {
  final double? height;
  final double? thickness;
  final Color? color;

  const CustomDivider({super.key, this.height, this.thickness, this.color});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: height ?? 1.0,
      thickness: thickness ?? 1.0,
      color: color ?? ColorName.grey9Color,
    );
  }
}
