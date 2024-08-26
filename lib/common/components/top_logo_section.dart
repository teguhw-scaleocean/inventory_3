import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/local_images.dart';

Widget buildTopLogoSection() {
  return SvgPicture.asset(
    LocalImages.logoImage,
    height: 80,
    width: 90,
    fit: BoxFit.scaleDown,
  );
}
