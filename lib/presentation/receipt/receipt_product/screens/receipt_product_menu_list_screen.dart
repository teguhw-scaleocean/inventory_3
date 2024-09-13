import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inventory_v3/data/model/scan_view.dart';
import 'package:inventory_v3/presentation/receipt/receipt_pallet/widget/scan_view_widget.dart';

import '../../../../common/components/custom_app_bar.dart';
import '../../../../common/components/receipt_product_item_card.dart';
import '../../../../common/components/reusable_search_bar_border.dart';
import '../../../../common/components/reusable_tab_bar.dart';
import '../../../../common/components/reusable_widget.dart';
import '../../../../common/theme/color/color_name.dart';
import '../../../../data/model/receipt.dart';

class ReceiptProductMenuListScreen extends StatefulWidget {
  final String title;

  const ReceiptProductMenuListScreen({super.key, required this.title});

  @override
  State<ReceiptProductMenuListScreen> createState() =>
      _ReceiptProductMenuListScreenState();
}

class _ReceiptProductMenuListScreenState
    extends State<ReceiptProductMenuListScreen>
    with SingleTickerProviderStateMixin {
  String appBarTitle = "";

  final searchKey = GlobalKey();
  final searchController = TextEditingController();

  late TabController _tabController;

  List<String> tabs = [];
  List<Receipt> listReceipt = [];

  @override
  void initState() {
    super.initState();

    appBarTitle = widget.title;

    tabs = ["All", "Waiting", "Ready", "Late"];
    listReceipt = [
      Receipt(
        id: 8,
        name: "WH/IN/00018",
        status: "Ready",
        packageName: "Package: Pallet",
        packageStatus: "Tracking: Serial Number",
        dateTime: "18/08/2024 - 15:00",
        destination: "To: Main Storage Area",
        statusColor: ColorName.readyColor,
      ),
      Receipt(
        id: 7,
        name: "WH/IN/00017",
        status: "Late",
        packageName: "Package: Pallet",
        packageStatus: "Tracking: No Tracking",
        dateTime: "17/07/2024 - 15:00",
        destination: "To: Shipping and Receive Dock",
        statusColor: ColorName.lateColor,
      ),
      Receipt(
        id: 6,
        name: "WH/IN/00016",
        status: "Waiting",
        packageName: "Package: Pallet",
        packageStatus: "Tracking: Lots",
        dateTime: "14/06/2024 - 15:00",
        destination: "To: Medical Storage",
        statusColor: ColorName.waitingColor,
      ),
      Receipt(
        id: 1,
        name: "WH/IN/00013",
        status: "Ready",
        statusColor: ColorName.readyColor,
        packageName: "Package: Pallet",
        packageStatus: "Tracking: Lots",
        dateTime: "14/06/2024 - 15:00",
        destination: "To: Main Storage Area",
      ),
      Receipt(
        id: 2,
        name: "WH/IN/00014",
        status: "Waiting",
        statusColor: ColorName.waitingColor,
        packageName: "Package: Pallet",
        packageStatus: "Tracking: No Tracking",
        dateTime: "14/06/2024 - 15:00",
        destination: "To: Medical Storage",
      ),
      Receipt(
        id: 3,
        name: "WH/IN/00015",
        status: "Late",
        statusColor: ColorName.lateColor,
        packageName: "Package: Pallet",
        packageStatus: "Tracking: Lots",
        dateTime: "14/06/2024 - 15:00",
        destination: "To: Shipping and Receiving Dock",
      ),
      Receipt(
        id: 4,
        name: "WH/IN/00015",
        status: "Ready",
        statusColor: ColorName.readyColor,
        packageName: "Package: Pallet",
        packageStatus: "Tracking: No Tracking",
        dateTime: "14/06/2024 - 15:00",
        destination: "To: Shipping and Receiving Dock",
      ),
      Receipt(
        id: 5,
        name: "WH/IN/00015",
        status: "Waiting",
        statusColor: ColorName.waitingColor,
        packageName: "Package: Pallet",
        packageStatus: "Tracking: Serial Number",
        dateTime: "14/06/2024 - 15:00",
        destination: "To: Shipping and Receiving Dock",
      ),
    ];

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
                          onSearch: _onSearch(),
                          clearData: _onSearchClear(),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    buildScanButton(
                        onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ScanView(
                                  expectedValue: "",
                                  scanType: ScanViewType.listProduct,
                                ),
                              ),
                            )),
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
          itemCount: listReceipt.length,
          itemBuilder: (context, index) {
            var item = listReceipt[index];

            return ReceiptProductItemCard(
              receipt: item,
              index: index,
            );
          }),
    );
  }
}
