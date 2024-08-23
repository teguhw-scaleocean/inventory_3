import 'package:flutter/material.dart';

import '../theme/color/color_name.dart';

Widget reusableFloatingActionButton(
    {required void Function() onTap, required IconData icon}) {
  return InkWell(
    onTap: onTap,
    child: Container(
        padding: const EdgeInsets.all(15),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: ColorName.mainColor,
        ),
        child: Icon(
          icon,
          color: ColorName.whiteColor,
          size: 18,
        )),
  );
}
