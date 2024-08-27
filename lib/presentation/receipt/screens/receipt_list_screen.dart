import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inventory_v3/data/model/receipt.dart';
import 'package:inventory_v3/presentation/receipt/screens/receipt_screen.dart';

import '../../../common/components/custom_app_bar.dart';
import '../../../common/components/receipt_item_card.dart';
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
  List<Receipt> listReceipt = [];

  @override
  void initState() {
    super.initState();

    appBarTitle = widget.title;

    tabs = ["All", "Waiting", "Ready", "Late"];
    listReceipt = [
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
                    8.width,
                    buildScanButton(),
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
              padding: const EdgeInsets.only(left: 16),
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

  GestureDetector buildScanButton() {
    return GestureDetector(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => ReceiptScreen())),
      child: Container(
        height: 36.h,
        width: 82.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: ColorName.mainColor),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              LocalImages.scanIcons,
              height: 16.w,
              width: 16.w,
            ),
            8.width,
            LimitedBox(
              maxHeight: 16.h,
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
    );
  }

  Container _buildListSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      color: ColorName.grey8Color,
      child: ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: listReceipt.length,
          itemBuilder: (context, index) {
            var item = listReceipt[index];

            return ReceiptItemCard(receipt: item);
          }),
    );
  }
}
