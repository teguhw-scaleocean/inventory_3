import 'package:flutter/material.dart';

import '../theme/text/base_text.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  final Color color;

  const StatusBadge({super.key, required this.status, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      width: 65,
      // padding: const EdgeInsets.symmetric(
      //     vertical: 6),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(25)),
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
