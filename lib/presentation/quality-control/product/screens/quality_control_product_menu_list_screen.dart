import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inventory_v3/common/components/custom_app_bar.dart';
import 'package:inventory_v3/common/components/qc_item_card.dart';
import 'package:inventory_v3/data/model/quality_control.dart';
import 'package:inventory_v3/data/model/scan_view.dart';
import 'package:inventory_v3/presentation/receipt/receipt_pallet/widget/scan_view_widget.dart';

import '../../../../common/components/reusable_search_bar_border.dart';
import '../../../../common/components/reusable_tab_bar.dart';
import '../../../../common/components/reusable_widget.dart';
import '../../../../common/theme/color/color_name.dart';
import '../../../../data/model/product.dart';

class QualityControlProductMenuListScreen extends StatefulWidget {
  final String appBarTitle;

  const QualityControlProductMenuListScreen(
      {super.key, required this.appBarTitle});

  @override
  State<QualityControlProductMenuListScreen> createState() =>
      _QualityControlProductMenuListScreenState();
}

class _QualityControlProductMenuListScreenState
    extends State<QualityControlProductMenuListScreen>
    with SingleTickerProviderStateMixin {
  String appBarTitle = "";

  final searchKey = GlobalKey();
  final searchController = TextEditingController();

  late TabController _tabController;

  List<String> tabs = [];
  List<QualityControl> listQualityControl = [];

  onSearch() {}
  onSearchClear() {}

  @override
  void initState() {
    super.initState();

    appBarTitle = widget.appBarTitle;
    tabs = ["All", "Waiting", "Ready", "Late"];

    _tabController = TabController(length: 4, vsync: this);

    listQualityControl = qualityControls;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          onTap: () => Navigator.pop(context),
          title: appBarTitle,
        ),
        body: Column(
          children: [
            SizedBox(
              height: 62.h,
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 10.h),
                child: Row(
                  children: [
                    Flexible(
                      child: SizedBox(
                        height: 36.h,
                        child: SearchBarBorder(
                          context,
                          controller: searchController,
                          queryKey: searchController.text,
                          keySearch: searchKey,
                          onSearch: onSearch(),
                          clearData: onSearchClear(),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    buildScanButton(onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ScanView(
                                    expectedValue: "1.0",
                                    scanType: ScanViewType.listProductQc,
                                    idTracking: 1,
                                  )));
                    }),
                  ],
                ),
              ),
            ),
            Container(
              // height: 32,
              // width: double.infinity,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: ColorName.borderColor,
                    width: 0.5,
                  ),
                ),
              ),
              padding: EdgeInsets.only(left: 16.w),
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
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: tabs.map<Widget>((e) {
                  return _buildListSection();
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _buildListSection() {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 8.h),
      color: ColorName.backgroundColor,
      child: ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: listQualityControl.length,
          itemBuilder: (context, index) {
            var item = listQualityControl[index];

            return QcItemCard(
              qualityControl: item,
              isProductMenu: true,
            );
          }),
    );
  }
}
