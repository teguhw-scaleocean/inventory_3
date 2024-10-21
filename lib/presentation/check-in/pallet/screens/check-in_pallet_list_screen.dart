import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/components/check-in_item_card.dart';
import '../../../../common/components/custom_app_bar.dart';
import '../../../../common/components/reusable_search_bar_border.dart';
import '../../../../common/components/reusable_tab_bar.dart';
import '../../../../common/components/reusable_widget.dart';
import '../../../../common/theme/color/color_name.dart';
import '../../../../data/model/check-in_model.dart';
import '../../../../data/model/scan_view.dart';
import '../../../receipt/receipt_pallet/widget/scan_view_widget.dart';
import '../cubit/check-in_cubit.dart';
import '../cubit/check-in_state.dart';

class CheckInPalletScreen extends StatefulWidget {
  final String appBarTitle;

  const CheckInPalletScreen({super.key, required this.appBarTitle});

  @override
  State<CheckInPalletScreen> createState() =>
      _QualityControlPalletListScreenState();
}

class _QualityControlPalletListScreenState extends State<CheckInPalletScreen>
    with SingleTickerProviderStateMixin {
  late CheckInCubit checkInCubit;

  String appBarTitle = "";

  final searchKey = GlobalKey();
  final searchController = TextEditingController();

  late TabController _tabController;

  List<String> tabs = [];
  List<CheckInModel> listOfCheckIn = [];

  bool isBothListScreen = false;

  onSearch() {}
  onSearchClear() {}

  @override
  void initState() {
    super.initState();

    appBarTitle = widget.appBarTitle;
    tabs = ["All", "Waiting", "Ready", "Late"];

    _tabController = TabController(length: 4, vsync: this);

    // listQualityControl = qualityControls;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    checkInCubit = BlocProvider.of<CheckInCubit>(context);

    checkInCubit.setInitialCheckIn();
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
                      ScanView screen;
                      if (isBothListScreen) {
                        var expectedValue = "A494";
                        screen = ScanView(
                          expectedValue: expectedValue,
                          scanType: ScanViewType.listBothQc,
                          idTracking: 1,
                        );
                      } else {
                        screen = const ScanView(
                          expectedValue: "1.0",
                          scanType: ScanViewType.listPalletQC,
                          idTracking: 1,
                        );
                      }
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => screen,
                          ));
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

  Widget _buildListSection() {
    return BlocBuilder<CheckInCubit, CheckInState>(
      builder: (context, state) {
        listOfCheckIn = state.listCheckIn ?? [];

        return Container(
          padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 8.h),
          color: ColorName.backgroundColor,
          child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: listOfCheckIn.length,
              itemBuilder: (context, index) {
                var item = listOfCheckIn[index];

                return CheckInItemCard(
                  checkInModel: item,
                );
              }),
        );
      },
    );
  }
}
