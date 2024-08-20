import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/local_images.dart';
import '../theme/text/base_text.dart';

Flexible buildTopLogoSection() {
  return Flexible(
    child: SizedBox(
      height: 80,
      width: 90,
      // color: Colors.amber,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Powered by",
                style: BaseText.grey2Text10,
                textAlign: TextAlign.end,
              ),
            ],
          ),
          SvgPicture.asset(LocalImages.logoImage),
        ],
      ),
    ),
  );
}
