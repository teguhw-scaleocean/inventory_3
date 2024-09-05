import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_highlight/smooth_highlight.dart';

import '../../../../common/components/custom_app_bar.dart';
import '../../../../common/components/custom_divider.dart';
import '../../../../common/components/reusable_floating_action_button.dart';
import '../../../../common/components/reusable_search_bar_border.dart';
import '../../../../common/components/reusable_tab_bar.dart';
import '../../../../common/theme/color/color_name.dart';
import '../../../../common/theme/text/base_text.dart';
import '../../../../data/model/product.dart';
import '../../receipt_pallet/screens/product_detail/add_product_screen.dart';

class ReceiptProductMenuOfProductDetailScreen extends StatefulWidget {
  final Product product;
  final String tracking;

  const ReceiptProductMenuOfProductDetailScreen(
      {super.key, required this.product, required this.tracking});

  @override
  State<ReceiptProductMenuOfProductDetailScreen> createState() =>
      _ReceiptProductMenuOfProductDetailScreenState();
}

class _ReceiptProductMenuOfProductDetailScreenState
    extends State<ReceiptProductMenuOfProductDetailScreen>
    with SingleTickerProviderStateMixin {
  late Product product;
  String tracking = "";

  final searchSerialNumberController = TextEditingController();
  final searchKey = GlobalKey<FormState>();

  List<SerialNumber> serialNumberList = [];
  List<SerialNumber> serialNumberResult = [];

  String code = "";
  String quantity = "";

  final _tabs = ["Not Done", "Done"];
  late TabController tabController;

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: _tabs.length, vsync: this);

    debugPrint(widget.product.toJson());

    product = widget.product;
    tracking = widget.tracking;

    // Serial Number
    serialNumberList = widget.product.serialNumber ?? <SerialNumber>[];
    debugPrint("serialNumberList: $serialNumberList.map((e) => e.toJson())");

    if (!(tracking.toLowerCase().contains("serial number"))) {
      code = product.lotsCode ?? product.code;
    }
  }

  _onSearch() {}
  _onClearData() {}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          onTap: () => Navigator.of(context).pop(product),
          title: "Product Detail",
        ),
        body: RefreshIndicator(
          onRefresh: () => Future.delayed(const Duration(seconds: 1), () {
            setState(() {});
          }),
          child: ListView(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.h),
                    Text(
                      product.productName,
                      style: BaseText.blackText17
                          .copyWith(fontWeight: BaseText.medium),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Text(product.code,
                            style: BaseText.grey1Text13
                                .copyWith(fontWeight: BaseText.light)),
                      ],
                    ),
                    SizedBox(height: 18.h),
                    Text(
                      product.dateTime,
                      style: BaseText.baseTextStyle.copyWith(
                        fontWeight: BaseText.regular,
                        fontSize: 13.sp,
                        color: ColorName.dateTimeColor,
                      ),
                    ),
                    SizedBox(height: 16.h),
                  ],
                ),
              ),
              const CustomDivider(),
              buildTrackingLabel(tracking),
              (tracking.toLowerCase().contains("serial number"))
                  ? Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      height: 36.h,
                      width: double.infinity,
                      child: SearchBarBorder(
                        context,
                        onSearch: _onSearch(),
                        clearData: _onClearData(),
                        keySearch: searchKey,
                        controller: searchSerialNumberController,
                        queryKey: searchSerialNumberController.text,
                        borderColor: ColorName.grey9Color,
                      ),
                    )
                  : const SizedBox(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: reusableTabBar(
                  tabs: _tabs.map((e) {
                    bool isSelectedTab = false;
                    isSelectedTab = tabController.index == _tabs.indexOf(e);

                    int totalInt =
                        _tabs[0] == e ? product.productQty.toInt() : 0;
                    final total = totalInt.toString();

                    return buildTabLabel(
                      label: e,
                      total: "($total)",
                      isSelected: isSelectedTab,
                    );
                  }).toList(),
                  tabController: tabController,
                  isScrollable: true,
                  setState: setState,
                ),
              ),
              SizedBox(height: 12.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: (tracking.toLowerCase().contains("serial number"))
                    ? SizedBox(
                        height: 600.h,
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: const AlwaysScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: serialNumberList.length,
                            itemBuilder: (context, index) {
                              var item = serialNumberList[index];
                              code = item.label;

                              bool isHighlighted = false;
                              isHighlighted = serialNumberResult.contains(item);
                              debugPrint("isHighlighted: $isHighlighted");

                              return Padding(
                                  padding: EdgeInsets.only(bottom: 8.h),
                                  child: buildItemQuantity(
                                    code,
                                    isHighlighted: isHighlighted,
                                  ));
                            }),
                      )
                    : buildItemQuantity(
                        code,
                        itemProduct: product,
                      ),
              )
            ],
          ),
        ),
        floatingActionButton: reusableFloatingActionButton(
          onTap: () {
            int indexToAddProduct = 0;

            switch (tracking) {
              case "Serial Number":
                break;
              case "No Tracking":
                indexToAddProduct = 1;
                break;
              case "Lots":
                indexToAddProduct = 2;
                break;
              default:
            }

            final resultOfAddProduct = Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddProductScreen(
                  addType: indexToAddProduct,
                  code: code,
                ),
              ),
            );
            resultOfAddProduct.then((value) {
              if (value != null && value is double) {
                debugPrint("resultOfAddProduct: $value");
                setState(() {
                  var quantityDouble = value;
                  product.productQty = quantityDouble;
                  // quantity = quantityDouble.toString();
                  debugPrint("quantityDouble: ${product.productQty}");
                });
              } else if (value != null) {
                setState(() {
                  serialNumberResult = value as List<SerialNumber>;
                  serialNumberList.insertAll(0, serialNumberResult);
                  product.serialNumber = serialNumberList;
                });

                debugPrint(
                    "serialNumberResult: $serialNumberResult.map((e) => e.toJson())");
              }
            });
          },
          icon: Icons.add,
        ),
      ),
    );
  }

  Container buildTrackingLabel(String tracking) {
    String receive = "0";

    switch (tracking) {
      case "Serial Number":
        if (serialNumberList.isNotEmpty) {
          int receiveDouble = serialNumberList.length.toInt();
          receive = receiveDouble.toString();
        }
        break;
      default:
        int receiveInt = product.productQty.toInt();
        receive = receiveInt.toString();
    }

    return Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        height: 43.h,
        // padding: const EdgeInsets.symmetric(vertical: 16),
        child: Align(
          alignment: Alignment.centerLeft,
          child: RichText(
              text: TextSpan(children: [
            TextSpan(
              text: "$tracking ",
              style: BaseText.blackText15.copyWith(
                fontWeight: BaseText.medium,
              ),
            ),
            TextSpan(
              text: "($receive)",
              style: BaseText.blackText15.copyWith(
                fontWeight: BaseText.regular,
              ),
            )
          ])),
        ));
  }

  Widget buildItemQuantity(String code,
      {Product? itemProduct, bool isHighlighted = false}) {
    if (itemProduct != null) {
      int? quantityInt = itemProduct.productQty.toInt();
      quantity = quantityInt.toString();
    }

    return SmoothHighlight(
      color: ColorName.highlightColor,
      duration: const Duration(seconds: 3),
      enabled: isHighlighted,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 10.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(
            color: ColorName.grey9Color,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  code,
                  style: BaseText.black2Text14
                      .copyWith(fontWeight: BaseText.regular),
                ),
                Text(
                  "Exp. Date: 12/07/2024 - 15:00",
                  style: BaseText.baseTextStyle.copyWith(
                    color: ColorName.dateTimeColor,
                    fontSize: 12.sp,
                    fontWeight: BaseText.light,
                  ),
                )
              ],
            ),
            IntrinsicHeight(
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 0),
                    child: VerticalDivider(
                      color: ColorName.grey9Color,
                      thickness: 1.0,
                    ),
                  ),
                  SizedBox(
                    height: 36.h,
                    width: 60.w,
                    child: Center(
                      child: Text(
                        (tracking.toLowerCase().contains("serial"))
                            ? "1"
                            : quantity,
                        textAlign: TextAlign.center,
                        style: BaseText.black2Text14.copyWith(
                          fontWeight: BaseText.regular,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
