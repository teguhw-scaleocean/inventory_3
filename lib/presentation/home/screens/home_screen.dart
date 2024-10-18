import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../common/constants/local_images.dart';
import '../../../common/theme/color/color_name.dart';
import '../../../common/theme/text/base_text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              height: 176.h,
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 14.h,
              ),
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage(
                  LocalImages.backgroundHome,
                ),
                fit: BoxFit.cover,
              )),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            height: 40.h,
                            width: 40.w,
                            child: const CircleAvatar(
                              backgroundColor: ColorName.mainColor,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                  text: TextSpan(children: [
                                TextSpan(
                                  text: "Hai, ",
                                  style: BaseText.black2Text14,
                                ),
                                TextSpan(
                                    text: "Theresia",
                                    style: BaseText.black2Text14.copyWith(
                                      fontWeight: BaseText.semiBold,
                                    ))
                              ])),
                              SizedBox(height: 6.h),
                              Row(
                                children: [
                                  SvgPicture.asset(
                                      LocalImages.iconLocationWHIcon),
                                  SizedBox(width: 4.w),
                                  Text(
                                    "Central Warehouse",
                                    style: BaseText.grey10Text12.copyWith(
                                      fontWeight: BaseText.light,
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  const Icon(
                                    Icons.keyboard_arrow_down_outlined,
                                    color: ColorName.grey10Color,
                                  )
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                      const Icon(Icons.logout, color: ColorName.mainColor)
                    ],
                  ),
                ],
              ),
            ),
            const Column(
              children: [],
            ),
          ],
        ),
      ),
    );
  }
}
