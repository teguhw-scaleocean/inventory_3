import 'package:flutter/material.dart';

import '../../../common/theme/color/color_name.dart';

class Indicator extends StatelessWidget {
  final int positionIndex, currentIndex;

  const Indicator(
      {super.key, required this.currentIndex, required this.positionIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8,
      width: 8,
      decoration: BoxDecoration(
        // border: Border.all(color: Colors.blue),
        color: positionIndex == currentIndex
            ? ColorName.mainColor
            : ColorName.grey3Color,
        borderRadius: BorderRadius.circular(100),
      ),
    );
  }
}
