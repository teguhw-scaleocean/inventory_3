import 'package:flutter/material.dart';

import '../extensions/empty_space_extension.dart';
import '../theme/color/color_name.dart';
import '../theme/text/base_text.dart';

TabBar reusableTabBar({
  required List<Widget> tabs,
  required TabController tabController,
  required bool isScrollable,
  required setState,
}) {
  return TabBar(
      dividerHeight: 0.0,
      isScrollable: isScrollable,
      tabAlignment: TabAlignment.start,
      indicatorColor: ColorName.mainColor,
      indicatorWeight: 1.5,
      indicatorPadding: const EdgeInsets.only(bottom: 0),
      indicatorSize: TabBarIndicatorSize.tab,
      // indicator:
      labelPadding: const EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 9),
      labelColor: ColorName.mainColor,
      unselectedLabelColor: ColorName.grey2Color,
      labelStyle: BaseText.mainText14.copyWith(fontWeight: BaseText.regular),
      unselectedLabelStyle: BaseText.grey2Text14.copyWith(
        fontWeight: BaseText.light,
      ),
      controller: tabController,
      onTap: (int i) {
        setState(() {});
      },
      tabs: tabs);
}

Row buildTabLabel({
  required String label,
  required String total,
  bool? isCenter,
  bool? isLabelTotal,
  bool? isSelected,
}) {
  return (isCenter == true && isLabelTotal == true)
      ? Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
            ),
            4.width,
            Text(
              total,
            )
          ],
        )
      : (isCenter == true)
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                ),
              ],
            )
          : Row(
              children: [
                Text(
                  label,
                ),
                4.width,
                Text(
                  total,
                  style: (isSelected == true)
                      ? BaseText.mainText12
                          .copyWith(fontWeight: BaseText.regular)
                      : BaseText.grey2Text12.copyWith(
                          fontWeight: BaseText.light,
                        ),
                )
              ],
            );
}
