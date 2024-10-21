import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inventory_v3/data/model/operation_model.dart';
import 'package:inventory_v3/presentation/quality-control/quality_control_screen.dart';
import 'package:inventory_v3/presentation/receipt/receipt_screen.dart';

import '../../../common/constants/local_images.dart';
import '../../../common/theme/color/color_name.dart';
import '../../../common/theme/text/base_text.dart';
import '../../check-in/check-in_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // List<>

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorName.backgroundColor,
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
                      Transform.scale(
                        scale: 0.75,
                        child: const Icon(
                          Icons.logout,
                          color: ColorName.mainColor,
                          // size: 14.w,
                        ),
                      )
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
                  _buildMenuTitle("OPERATIONS"),
                  SizedBox(height: 10.h),
                  // GridView.builder(
                  //   shrinkWrap: true,
                  //   // crossAxisCount: 2,
                  //   gridDelegate:
                  //       const SliverGridDelegateWithFixedCrossAxisCount(
                  //     crossAxisCount: 2,
                  //     crossAxisSpacing: 12,
                  //     mainAxisSpacing: 12,
                  //     childAspectRatio: 1.25,
                  //   ),
                  //   scrollDirection: Axis.vertical,
                  //   itemCount: listOfOperation.length,
                  //   itemBuilder: (context, index) {
                  //     var item = listOfOperation[index];

                  //     return _buildItemOperation(
                  //       leadingIcon: item.imgPath,
                  //       label: item.name,
                  //       total: item.total,
                  //     );
                  //   },
                  // )
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: listOfOperation.map((e) {
                      return _buildItemOperation(
                        onTap: () {
                          late Widget screen;

                          if (e.id == 1) {
                            screen = ReceiptScreen();
                          } else if (e.id == 2) {
                            screen = QualityControlScreen();
                          } else if (e.id == 3) {
                            screen = CheckInScreen();
                          } else {
                            return;
                          }

                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => screen));
                        },
                        leadingIcon: e.imgPath,
                        bgColor: e.color,
                        label: e.name,
                        total: e.total,
                      );
                    }).toList(),
                  ),

                  SizedBox(height: 20.h),
                  _buildMenuTitle("INVENTORY"),
                  SizedBox(height: 10.h),

                  _buildItemInventory(
                    leadingIcon: LocalImages.masterIcon,
                    label: "Master Item",
                  ),
                  SizedBox(height: 8.h),
                  _buildItemInventory(
                    leadingIcon: LocalImages.itemLocatorIcon,
                    label: "Item Locator",
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

  Widget _buildItemOperation({
    void Function()? onTap,
    required String leadingIcon,
    required Color bgColor,
    required String label,
    required int total,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 158.w,
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: bgColor,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(leadingIcon),
            SizedBox(height: 12.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: BaseText.grey10Text15.copyWith(
                    fontWeight: BaseText.semiBold,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  "$total Item",
                  style: BaseText.grey1Text12,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
