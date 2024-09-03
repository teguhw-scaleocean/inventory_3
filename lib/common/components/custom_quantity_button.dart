import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/color/color_name.dart';

class CustomQuantityButton extends StatelessWidget {
  const CustomQuantityButton({
    super.key,
    this.onSubmitted,
    required this.controller,
    required this.iconColor,
    required this.textColor,
    required this.onDecreased,
    required this.onIncreased,
    this.onChanged,
  });

  final TextEditingController controller;
  final Function(String)? onSubmitted;
  final Function(String)? onChanged;
  final Function()? onDecreased;
  final Function()? onIncreased;

  final Color iconColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 183.w,
      height: 40.h,
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFE9E9E9)),
          borderRadius: BorderRadius.circular(6.r),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 40.w,
            height: double.infinity,
            decoration: const BoxDecoration(
                // borderRadius: BorderRadius.only(
                //   topLeft: Radius.circular(6.r),
                //   bottomLeft: Radius.circular(6.r),
                // ),
                // border: const Border(
                //   left: BorderSide(color: Color(0xFFE9E9E9)),
                //   top: BorderSide(color: Color(0xFFE9E9E9)),
                //   right: BorderSide(width: 1, color: Color(0xFFE9E9E9)),
                //   bottom: BorderSide(color: Color(0xFFE9E9E9)),
                // ),
                ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: onDecreased,
                  child: Container(
                    width: 20.w,
                    height: 20.w,
                    decoration: const BoxDecoration(
                        // color: Color(0xFFD9D9D9),
                        ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.remove,
                      color: iconColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 100.w,
            height: double.infinity,
            // padding: EdgeInsets.symmetric(vertical: 12.h),
            clipBehavior: Clip.antiAlias,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                left: BorderSide(color: Color(0xFFE9E9E9)),
                // top: BorderSide(width: 1, color: Color(0xFFE9E9E9)),
                right: BorderSide(color: Color(0xFFE9E9E9)),
                // bottom: BorderSide(width: 1, color: Color(0xFFE9E9E9)),
              ),
            ),
            child: TextField(
              // readOnly: isSubmitted,
              textAlign: TextAlign.center,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              controller: controller,
              style: TextStyle(
                color: textColor,
                fontSize: 14.sp,
                fontFamily: 'Lexend',
                fontWeight: FontWeight.w400,
              ),
              decoration: const InputDecoration.collapsed(hintText: ""),
              onSubmitted: onSubmitted,
              onChanged: onChanged,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(
                  RegExp(r'[0-9]'),
                ),
                FilteringTextInputFormatter.deny(
                  RegExp(r'^0+'), //users can't type 0 at 1st position
                ),
              ],
            ),
          ),
          SizedBox(
            width: 40.w,
            height: double.infinity,
            // decoration: const ShapeDecoration(
            //   shape: RoundedRectangleBorder(
            //     side: BorderSide(width: 1, color: Color(0xFFE9E9E9)),
            //     borderRadius: BorderRadius.only(
            //       topRight: Radius.circular(6),
            //       bottomRight: Radius.circular(6),
            //     ),
            //   ),
            // ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: onIncreased,
                  child: Container(
                    width: 20.w,
                    height: 20.w,
                    decoration: const BoxDecoration(
                        // color: Color(0xFFD9D9D9),
                        ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.add,
                      color: ColorName.grey10Color,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
