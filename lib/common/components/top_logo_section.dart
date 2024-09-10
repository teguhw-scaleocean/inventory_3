import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/local_images.dart';
import '../theme/text/base_text.dart';

Widget buildTopLogoSection() {
  return Container(
    height: 80,
    width: 90,
    padding: const EdgeInsets.symmetric(vertical: 24),
    // decoration: BoxDecoration(
    //   border: Border.all(
    //     color: Colors.black,
    //   ),
    // ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          // crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "Powered by",
              textAlign: TextAlign.right,
              style: BaseText.grey2Text10.copyWith(
                fontWeight: BaseText.regular,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        SvgPicture.asset(
          LocalImages.logoImage,
          // fit: BoxFit.scaleDown,
        ),
      ],
    ),
  );
}
