import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/text/base_text.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  final Color color;

  const StatusBadge({super.key, required this.status, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20.h,
      width: 65.w,
      // padding: const EdgeInsets.symmetric(
      //     vertical: 6),
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.circular(25.r)),
      child: Center(
        child: Text(
          status,
          textAlign: TextAlign.center,
          style: BaseText.whiteText12.copyWith(fontWeight: BaseText.medium),
        ),
      ),
    );
  }
}
