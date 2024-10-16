import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inventory_v3/common/components/custom_app_bar.dart';
import 'package:inventory_v3/common/components/reusable_floating_action_button.dart';
import 'package:inventory_v3/common/extensions/empty_space_extension.dart';
import 'package:inventory_v3/data/model/pallet.dart';
import 'package:inventory_v3/data/model/product.dart';
import 'package:inventory_v3/presentation/receipt/receipt_pallet/cubit/add_pallet_cubit/add_pallet_cubit.dart';
import 'package:inventory_v3/presentation/receipt/receipt_pallet/screens/product_detail/add_product_screen.dart';
import 'package:smooth_highlight/smooth_highlight.dart';

import '../../../../common/components/custom_divider.dart';
import '../../../../common/components/reusable_search_bar_border.dart';
import '../../../../common/components/reusable_tab_bar.dart';
import '../../../../common/theme/color/color_name.dart';
import '../../../../common/theme/text/base_text.dart';

class QualityControlProductDetailScreen extends StatefulWidget {
  final Pallet product;
  final String tracking;

  const QualityControlProductDetailScreen(
      {super.key, required this.product, required this.tracking});

  @override
  State<QualityControlProductDetailScreen> createState() =>
      _QualityControlProductDetailScreenState();
}

class _QualityControlProductDetailScreenState
    extends State<QualityControlProductDetailScreen>
    with TickerProviderStateMixin {
  late Pallet product;
  String tracking = "";

  final searchSerialNumberController = TextEditingController();
  final searchKey = GlobalKey<FormState>();

  List<SerialNumber> serialNumberList = [];
  List<SerialNumber> serialNumberResult = [];

  String code = "";
  String quantity = "";

  bool isReturn = false;
  bool isReturnPalletAndProduct = false;

  bool isDamage = false;
  bool isDamagePalletAndProduct = false;

  bool isHighlightedAddQty = false;
  bool isHighlightedAddSn = false;

  late TabController _tabController;
  List<String> tabs = ["Not Done", "Done"];

  var totalDamageQty = 1;

  @override
  void initState() {
    super.initState();

    debugPrint(widget.product.toJson());

    product = widget.product;
    tracking = widget.tracking;

    isReturn = product.isReturn ?? false;
    isReturnPalletAndProduct = product.isReturnPalletAndProduct ?? false;

    isDamage = product.isDamage ?? false;
    isDamagePalletAndProduct = product.isDamagePalletAndProduct ?? false;

    if (isDamage || isDamagePalletAndProduct) {
      tabs.add("Damage");
    }

    if (isReturn || isReturnPalletAndProduct) {
      tabs.add("Return");
    }

    debugPrint("tabs: ${tabs.map((e) => e).toList()}");

    // if (isReturn || isReturnPalletAndProduct) {
    //   tabs.insert(tabs.lastIndexOf(tabs.last), "Return");
    // }

    // if (isDamage || isDamagePalletAndProduct) {
    //   tabs.insert(tabs.lastIndexOf(tabs.last), "Damage");
    // }

    // Serial Number
    serialNumberList = widget.product.serialNumber ?? <SerialNumber>[];
    debugPrint("serialNumberList: $serialNumberList.map((e) => e.toJson())");

    if (!(tracking.toLowerCase().contains("serial number"))) {
      code = product.lotsCode ?? product.code;
    }

    _tabController = TabController(length: tabs.length, vsync: this);
  }

  _onSearch() {}
  _onClearData() {}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: tabs.length,
        child: Scaffold(
          appBar: CustomAppBar(
            onTap: () => Navigator.of(context).pop(product),
            title: "Product Detail",
          ),
          body: (isReturnPalletAndProduct || isDamagePalletAndProduct)
              ? buildReturnProductDetail(context)
              : buildDefaultProductDetail(context),
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
                    isFromBoth: false,
                  ),
                ),
              );
              resultOfAddProduct.then((value) {
                if (value != null && value is double) {
                  debugPrint("resultOfAddProduct: $value");
                  setState(() {
                    var quantityDouble = value;
                    product.productQty = product.productQty + quantityDouble;
                    product.notDoneQty = product.notDoneQty! + quantityDouble;
                    isHighlightedAddQty = true;
                    // quantity = quantityDouble.toString();
                    debugPrint("notDoneQty: ${product.notDoneQty}");
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
      ),
    );
  }

  buildReturnProductDetail(BuildContext context) {
    return Column(
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
                style:
                    BaseText.blackText17.copyWith(fontWeight: BaseText.medium),
              ),
              SizedBox(height: 8.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(product.code,
                      style: BaseText.grey1Text13
                          .copyWith(fontWeight: BaseText.light)),
                  Text("Pallet ${product.palletCode}",
                      style: BaseText.grey1Text13
                          .copyWith(fontWeight: BaseText.light)),
                ],
              ),
              SizedBox(height: 16.h),
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
        SizedBox(height: 12.h),
        Expanded(
          child: Column(
            children: [
              Container(
                height: 38.h,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: reusableTabBar(
                  tabs: tabs.map((e) {
                    bool isSelectedTab = false;
                    isSelectedTab = _tabController.index == tabs.indexOf(e);

                    var total = 0;
                    var totalDone = 0;

                    if (tracking.toLowerCase().contains("serial number")) {
                      total = serialNumberList.length;
                      totalDone = serialNumberResult.length;
                    } else {
                      total = product.productQty.toInt();
                    }
                    if (isDamagePalletAndProduct) {
                      int totalDamageQtyToInt = product.damagedQty!.toInt();
                      totalDamageQty = totalDamageQtyToInt;
                      total = (total - totalDamageQty).toInt();
                    }

                    var totalReturn = 1;

                    return buildTabLabel(
                      label: e,
                      total: (tabs[0] == e)
                          ? "($total)"
                          : (tabs[1] == e)
                              ? "($totalDone)"
                              : (tabs[2] == "Damage")
                                  ? "($totalDamageQty)"
                                  : "($totalReturn)",
                      isSelected: isSelectedTab,
                    );
                  }).toList(),
                  tabController: _tabController,
                  isScrollable: true,
                  setState: setState,
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Not Done
                    (tracking.toLowerCase().contains("serial number"))
                        ? SizedBox(
                            height: 600.h,
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: const AlwaysScrollableScrollPhysics(),
                                padding: EdgeInsets.symmetric(
                                    vertical: 12.h, horizontal: 16.w),
                                scrollDirection: Axis.vertical,
                                itemCount: serialNumberList.length,
                                itemBuilder: (context, index) {
                                  var item = serialNumberList[index];
                                  code = item.label;

                                  bool isHighlighted = false;
                                  isHighlighted =
                                      serialNumberResult.contains(item);
                                  debugPrint("isHighlighted: $isHighlighted");

                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 8.h),
                                    child: buildItemQuantity(
                                      code,
                                      isHighlighted: isHighlighted,
                                    ),
                                  );
                                }),
                          )
                        : Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 12.h,
                              horizontal: 16.w,
                            ),
                            child: Column(
                              children: [
                                buildItemQuantity(
                                  code,
                                  itemProduct: product,
                                ),
                              ],
                            ),
                          ),
                    // DOne
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "No items scanned or updated yet",
                          style: BaseText.grey10Text14,
                        ),
                        Text(
                          "Completed items will be shown here.",
                          style: BaseText.grey1Text14.copyWith(
                            fontWeight: BaseText.light,
                          ),
                        )
                      ],
                    ),
                    // Damage
                    if (isDamagePalletAndProduct)
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 12.h, horizontal: 16.w),
                        child: Column(
                          children: [
                            buildItemQuantityDamage(
                              code,
                              itemProduct: product,
                            )
                          ],
                        ),
                      ),

                    // Return
                    if (isReturnPalletAndProduct)
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 12.h, horizontal: 16.w),
                        child: Column(
                          children: [buildItemQuantityReturn(code)],
                        ),
                      )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  SingleChildScrollView buildDefaultProductDetail(BuildContext context) {
    return SingleChildScrollView(
      primary: false,
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(product.code,
                        style: BaseText.grey1Text13
                            .copyWith(fontWeight: BaseText.light)),
                    Text("Pallet ${product.palletCode}",
                        style: BaseText.grey1Text13
                            .copyWith(fontWeight: BaseText.light)),
                  ],
                ),
                SizedBox(height: 16.h),
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
                              child: (isReturn || isDamage)
                                  ? buildItemQuantityReturn(
                                      code,
                                      isHighlighted: isHighlighted,
                                    )
                                  : buildItemQuantity(
                                      code,
                                      isHighlighted: isHighlighted,
                                    ));
                        }),
                  )
                : buildItemQuantity(
                    code,
                    itemProduct: product,
                    isHighlighted: isHighlightedAddQty,
                  ),
          )
        ],
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
              text: (isReturn)
                  ? "Return: $tracking "
                  : (isDamage)
                      ? "Damage: $tracking"
                      : "$tracking ",
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
      {Pallet? itemProduct, bool isHighlighted = false}) {
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

  Widget buildItemQuantityReturn(String code,
      {Pallet? itemProduct, bool isHighlighted = false}) {
    String returnQuantity = "0";
    if (itemProduct != null) {
      int? quantityInt = itemProduct.returnQty?.toInt() ?? 0;
      returnQuantity = quantityInt.toString();
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
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  code,
                  style: BaseText.black2Text14
                      .copyWith(fontWeight: BaseText.regular),
                ),
                SizedBox(height: 9.h),
                Text(
                  "Reason: Does not meet standarts",
                  style:
                      BaseText.grey1Text12.copyWith(fontWeight: BaseText.light),
                ),
                SizedBox(height: 8.h),
                Text(
                  "Location: Storage Area B, IN01",
                  style:
                      BaseText.grey1Text12.copyWith(fontWeight: BaseText.light),
                ),
                SizedBox(height: 9.h),
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
                    height: 86.h,
                    width: 60.w,
                    child: Center(
                      child: Text(
                        (tracking.toLowerCase().contains("serial"))
                            ? "1"
                            : returnQuantity,
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

  Widget buildItemQuantityDamage(String code,
      {Pallet? itemProduct, bool isHighlighted = false}) {
    String damageQuantity = "";
    var damageTemp = itemProduct!.damagedQty ?? 0.0;
    damageQuantity = damageTemp.toInt().toString();

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
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  code,
                  style: BaseText.black2Text14
                      .copyWith(fontWeight: BaseText.regular),
                ),
                SizedBox(height: 9.h),
                Flexible(
                  child: Text(
                    "Reason: ${itemProduct.damageProducts?.reason}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: BaseText.grey1Text12
                        .copyWith(fontWeight: BaseText.light),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  "Location: ${itemProduct.damageProducts?.location}",
                  style:
                      BaseText.grey1Text12.copyWith(fontWeight: BaseText.light),
                ),
                SizedBox(height: 9.h),
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
                    height: 86.h,
                    width: 58.w,
                    child: Center(
                      child: Text(
                        damageQuantity,
                        overflow: TextOverflow.ellipsis,
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
