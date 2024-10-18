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
                  SizedBox(height: 17.h),
                  _buildNotificationSection()
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  // _buildMenuTitle("Operations"),
                  // SizedBox(height: 10.h),
                  // _buildItemOperation()

                  // _buildMenuTitle("INVENTORY"),
                  SizedBox(height: 10.h),
                  _buildItemInventory(
                    leadingIcon: LocalImages.masterIcon,
                    label: "Master Item",
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _buildItemInventory(
      {required String leadingIcon, required String label}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: ColorName.grey6Color,
          )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(leadingIcon),
              SizedBox(width: 8.w),
              Text(
                label,
                style: BaseText.grey10Text15
                    .copyWith(fontWeight: BaseText.semiBold),
              ),
            ],
          ),
          SizedBox(
            height: 12.h,
            child: const FittedBox(
              child: Icon(
                Icons.arrow_forward_ios,
                color: ColorName.grey1Color,
              ),
            ),
          )
        ],
      ),
    );
  }

  Row _buildMenuTitle(String title) {
    return Row(
      children: [
        Text(
          title,
          style: BaseText.grey2Text12.copyWith(fontWeight: BaseText.semiBold),
        ),
      ],
    );
  }

  Container _buildNotificationSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.5.h),
      decoration: BoxDecoration(
        color: ColorName.whiteColor,
        borderRadius: BorderRadius.all(
          Radius.circular(8.r),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Check Notification", style: BaseText.grey1Text11),
              SizedBox(height: 4.h),
              Text(
                "Warehouse Stock Opname Schedule",
                style: BaseText.grey10Text12.copyWith(
                  fontWeight: BaseText.semiBold,
                ),
              )
            ],
          ),
          SvgPicture.asset(LocalImages.notifIcon)
        ],
      ),
    );
  }

  Container _buildItemOperation() {
    return Container(
      width: 158.w,
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: ColorName.receiptColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(LocalImages.receiptIcon),
          SizedBox(height: 12.h),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Receipt",
                style: BaseText.grey10Text15.copyWith(
                  fontWeight: BaseText.semiBold,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                "16 Item",
                style: BaseText.grey1Text12,
              )
            ],
          ),
        ],
      ),
    );
  }
}
