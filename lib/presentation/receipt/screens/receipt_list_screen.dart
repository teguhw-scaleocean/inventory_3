import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../common/components/custom_app_bar.dart';
import '../../../common/components/reusable_search_bar_border.dart';
import '../../../common/components/reusable_tab_bar.dart';
import '../../../common/components/status_badge.dart';
import '../../../common/constants/local_images.dart';
import '../../../common/extensions/empty_space_extension.dart';
import '../../../common/theme/color/color_name.dart';
import '../../../common/theme/text/base_text.dart';

class ReceiptListScreen extends StatefulWidget {
  final String title;

  const ReceiptListScreen({super.key, required this.title});

  @override
  State<ReceiptListScreen> createState() => _ReceiptListScreenState();
}

class _ReceiptListScreenState extends State<ReceiptListScreen>
    with SingleTickerProviderStateMixin {
  String appBarTitle = "";

  final searchKey = GlobalKey();
  final searchController = TextEditingController();

  late TabController _tabController;

  List<String> tabs = [];

  @override
  void initState() {
    super.initState();

    appBarTitle = widget.title;

    tabs = ["All", "Waiting", "Ready", "Late"];

    _tabController = TabController(length: 4, vsync: this);
  }

  _onSearch() {}

  _onSearchClear() {}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: appBarTitle),
        body: Column(
          children: [
            Container(
              height: 62,
              color: Colors.amber,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
                child: Row(
                  children: [
                    Flexible(
                      child: SizedBox(
                        height: 36,
                        child: SearchBarBorder(
                          context,
                          controller: searchController,
                          queryKey: searchController.text,
                          keySearch: searchKey,
                          onSearch: _onSearch(),
                          clearData: _onSearchClear(),
                        ),
                      ),
                    ),
                    8.width,
                    Container(
                      height: 36,
                      width: 82,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: ColorName.mainColor),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 16,
                            width: 16,
                            child: SvgPicture.asset(LocalImages.scanIcons),
                          ),
                          8.width,
                          LimitedBox(
                            maxHeight: 16,
                            child: Text(
                              "Scan",
                              style: BaseText.mainText14.copyWith(
                                color: ColorName.mainColor,
                                fontWeight: BaseText.medium,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              // height: 32,
              // width: double.infinity,
              padding: const EdgeInsets.only(left: 16),
              color: Colors.amber,
              child: reusableTabBar(
                tabs: tabs.map((e) {
                  bool isSelectedTab = false;
                  isSelectedTab = _tabController.index == tabs.indexOf(e);

                  return buildTabLabel(
                      label: e,
                      total: "(${Random().nextInt(100)})",
                      isSelected: isSelectedTab);
                }).toList(),
                tabController: _tabController,
                isScrollable: true,
                setState: setState,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
