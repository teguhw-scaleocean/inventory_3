import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:smooth_highlight/smooth_highlight.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:time_picker_spinner/time_picker_spinner.dart';

import '../../../../../common/components/custom_app_bar.dart';
import '../../../../../common/components/custom_divider.dart';
import '../../../../../common/components/primary_button.dart';
import '../../../../../common/components/reusable_floating_action_button.dart';
import '../../../../../common/components/reusable_search_bar_border.dart';
import '../../../../../common/components/reusable_tab_bar.dart';
import '../../../../../common/components/reusable_widget.dart';
import '../../../../../common/helper/tracking_helper.dart';
import '../../../../../common/theme/color/color_name.dart';
import '../../../../../common/theme/text/base_text.dart';
import '../../../../../data/model/date_time_button.dart';
import '../../../../../data/model/pallet.dart';
import '../../../../../data/model/return_product.dart';
import '../../../../../data/model/scan_view.dart';
import '../../../receipt/receipt_pallet/screens/product_detail/add_product_screen.dart';
import '../../../receipt/receipt_pallet/widget/scan_view_widget.dart';
import '../../../receipt/receipt_product/cubit/product_detail/product_menu_product_detail_cubit.dart';
import '../../../receipt/receipt_product/cubit/product_detail/product_menu_product_detail_state.dart';
import '../../../receipt/receipt_product/cubit/scan/scan_cubit.dart';
import '../../../receipt/receipt_product/cubit/scan/scan_state.dart';
import '../../../receipt/receipt_product/screens/product_detail/update_product_quantity_screen.dart';

class QualityControlProductScreen extends StatefulWidget {
  final Pallet product;
  final String tracking;
  final String status;

  const QualityControlProductScreen(
      {super.key,
      required this.product,
      required this.tracking,
      required this.status});

  @override
  State<QualityControlProductScreen> createState() =>
      _QualityControlProductScreenState();
}

class _QualityControlProductScreenState
    extends State<QualityControlProductScreen>
    with SingleTickerProviderStateMixin {
  late ProductMenuProductDetailCubit productDetailCubit;
  late Pallet product;
  String tracking = "";
  String status = "";
  // Scan Result
  String _scanBarcode = "";
  int idTracking = 0;

  final searchSerialNumberController = TextEditingController();
  final searchKey = GlobalKey<FormState>();

  List<SerialNumber> serialNumberList = [];
  List<SerialNumber> serialNumberResult = [];
  List<SerialNumber> serialNumberAddQtyResult = [];

  var selectedSerialNumber;

  List<DateTimeButton> dateTimeButtons = [
    DateTimeButton(index: 0, label: "Date"),
    DateTimeButton(index: 1, label: "Time"),
  ];
  List<String> timeHeaders = ["Hour", "Minute", "AM/PM"];
  final DateRangePickerController _controller = DateRangePickerController();
  final List<String> views = <String>['Month', 'Year', 'Decade', 'Century'];

  String code = "";
  String quantity = "";

  final _tabs = ["Not Done", "Done"];
  late TabController tabController;

  bool isCardHighlighted = false;

  var selectedDate;
  // TimeOfDay time = TimeOfDay.now();
  final DateTime _dateTime = DateTime.now();
  var selectedTime;
  String inputDate = "";

  // Total Not Done
  int totalInt = 0;
  String total = "";
  // Total Done
  int totalDoneInt = 0;
  String totalDone = "";

  // Serial Number
  bool isHighlighted = false;
  // Lots
  bool isHighlightedLots = false;

  // Return Product
  bool isReturnProduct = false;
  var totalReturn = 1;

  // Damage Product
  bool isDamageProduct = false;
  var totalDamage = 1;

  @override
  void initState() {
    super.initState();

    debugPrint(widget.product.toJson());

    product = widget.product;
    tracking = widget.tracking;
    status = widget.status;

    isReturnProduct = product.isReturn ?? false;
    if (isReturnProduct) {
      // _tabs.insert(2, "Return");
      _tabs.add("Return");
    }

    isDamageProduct = product.isDamageProduct ?? false;
    if (isDamageProduct) {
      _tabs.add("Damage");
    }

    tabController = TabController(length: _tabs.length, vsync: this);

    idTracking = TrackingHelper().getTrackingId(tracking);

    if (!(tracking.toLowerCase().contains("serial number"))) {
      code = product.lotsCode ?? product.code;
    } else {
      // Serial Number
      serialNumberList = widget.product.serialNumber ?? <SerialNumber>[];
      // if (product.id == 2) {
      //   serialNumberList = List.generate(
      //     product.productQty.toInt(),
      //     (index) => SerialNumber(
      //       id: Random().nextInt(100),
      //       label: "BP1234567845$index",
      //       expiredDateTime: "Exp. Date: 12/07/2024 - 16:00",
      //       quantity: 1,
      //     ),
      //   );
      // }
      debugPrint("serialNumberList: $serialNumberList.map((e) => e.toJson())");
      BlocProvider.of<ProductMenuProductDetailCubit>(context)
          .setTotalToDone(serialNumberList.length);

      BlocProvider.of<ScanCubit>(context)
          .setListOfSerialNumber(serialNumberList);

      // selectedDate =
      //     "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";
      // selectedTime = "${TimeOfDay.now().hour}:${TimeOfDay.now().minute}";
    }
  }

  @override
  void dispose() {
    super.dispose();

    tabController.dispose();
    searchSerialNumberController.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    productDetailCubit =
        BlocProvider.of<ProductMenuProductDetailCubit>(context);
  }

  _onSearch() {}
  _onClearData() {}

  @override
  Widget build(BuildContext context) {
    // final itemInputDate = context.watch<ScanCubit>().state.isItemInputDate;

    // debugPrint("itemInputDate: $itemInputDate");
    // if (itemInputDate == true) {
    //   debugPrint("itemInputDate minta true: $itemInputDate");
    // }
    debugPrint("tracking: $tracking");
    return SafeArea(
      child: DefaultTabController(
        length: _tabs.length,
        child: Scaffold(
          appBar: CustomAppBar(
            onTap: () => Navigator.of(context).pop(product),
            title: "Product Detail",
          ),
          body: MultiBlocListener(
            listeners: [
              BlocListener<ScanCubit, ScanState>(
                listener: (context, state) {
                  final itemInputDate = state.isItemInputDate;
                  debugPrint("itemInputDate: //");
                  if (itemInputDate == true) {}
                },
              ),
              BlocListener<ProductMenuProductDetailCubit,
                  ProductMenuProductDetailState>(
                listener: (context, state) {
                  debugPrint("listener ProductMenuProductDetailCubit");

                  if (idTracking == 0) {
                    product.doneQty = state.snTotalDone?.toDouble() ?? 0.00;
                  }
                  if (idTracking != 0) {
                    // product.doneQty = state.lotsTotalDone?.toDouble() ?? 0.00;
                    product = state.product ?? product;
                  }
                },
              ),
            ],
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              // shrinkWrap: true,
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
                      SizedBox(height: 18.h),
                      BlocBuilder<ProductMenuProductDetailCubit,
                          ProductMenuProductDetailState>(
                        builder: (context, state) {
                          final doneQtyStatus = state.isDoneQty == true;

                          debugPrint("doneQtyStatus: $doneQtyStatus");
                          if (doneQtyStatus) {
                            return buildScanAndUpdateSection(
                              status: "",
                              onScan: () {},
                              onUpdate: () {},
                            );
                          }
                          return buildScanAndUpdateSection(
                            status: status,
                            onScan: () async {
                              // int idTracking = 0;
                              String firstExpectedValue = "";
                              bool isShowErrorPalletLots = false;

                              if (tracking
                                  .toLowerCase()
                                  .contains("serial number")) {
                                firstExpectedValue =
                                    serialNumberList.first.label;
                              } else if (idTracking == 1) {
                                // idTracking = 1;
                                firstExpectedValue = code;
                                isShowErrorPalletLots = true;

                                debugPrint(
                                    "isShowError: $isShowErrorPalletLots, idTracking: $idTracking");
                              }

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ScanView(
                                    expectedValue: firstExpectedValue,
                                    scanType: ScanViewType.productQc,
                                    idTracking: idTracking,
                                    isShowErrorPalletLots:
                                        isShowErrorPalletLots,
                                  ),
                                ),
                              ).then((value) {
                                if (value != null) {
                                  if (value
                                      .toString()
                                      .contains("inputExpirationDate")) {
                                    BlocProvider.of<ScanCubit>(context)
                                        .setIsItemInputDate(true);
                                  } else if (tracking
                                      .toLowerCase()
                                      .contains("serial number")) {
                                    setState(() {
                                      _scanBarcode = value;

                                      selectedSerialNumber = serialNumberList
                                          .firstWhere((element) =>
                                              element.label == _scanBarcode);
                                      serialNumberList.removeWhere((element) =>
                                          element == selectedSerialNumber);
                                      serialNumberResult
                                          .add(selectedSerialNumber);
                                      product.scannedSerialNumber =
                                          serialNumberResult;
                                      product.hasActualDateTime = true;
                                      product.actualDateTime =
                                          _getScanActualDate();
                                    });

                                    Future.delayed(const Duration(seconds: 2),
                                        () {
                                      String scannedItem =
                                          "Serial Number: $_scanBarcode";

                                      onShowSuccessDialog(
                                        context: context,
                                        scannedItem: scannedItem,
                                      );
                                    });
                                  } else if (idTracking == 1) {
                                    BlocProvider.of<
                                                ProductMenuProductDetailCubit>(
                                            context)
                                        .getLotsScannedTotalDone(
                                      totalDoneInt,
                                      product: product,
                                    );

                                    setState(() {});

                                    Future.delayed(const Duration(seconds: 2),
                                        () {
                                      _scanBarcode = value;
                                      String scannedItem =
                                          "1 Lots: $_scanBarcode";

                                      onShowSuccessDialog(
                                        context: context,
                                        scannedItem: scannedItem,
                                      );
                                    });
                                  }

                                  // BlocProvider.of<ProductMenuProductDetailCubit>(
                                  //         context)
                                  //     .scannedSerialNumberToProduct(product);
                                  // debugPrint("scanResultValue: ");
                                }
                              });
                            },
                            onUpdate: () {
                              BlocProvider.of<ProductMenuProductDetailCubit>(
                                      context)
                                  .getCurrentProduct(product);

                              if (idTracking == 0) {
                                BlocProvider.of<ProductMenuProductDetailCubit>(
                                        context)
                                    .setListOfSerialNumber(serialNumberList);

                                Navigator.push<String>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        UpdateProductQuantityScreen(
                                      tracking: tracking,
                                    ),
                                  ),
                                ).then((value) {
                                  if (value != null) {
                                    setState(() {
                                      serialNumberResult = [
                                        ...serialNumberList
                                      ];
                                      serialNumberList.clear();
                                    });

                                    Future.delayed(const Duration(seconds: 2),
                                        () {
                                      String scannedItem = "Serial Number";
                                      onShowSuccessDialog(
                                        context: context,
                                        scannedItem: scannedItem,
                                        isOnUpdate: true,
                                      );
                                    });
                                  }
                                });
                              }
                              if (idTracking == 1) {
                                Navigator.push<String>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        UpdateProductQuantityScreen(
                                      tracking: tracking,
                                    ),
                                  ),
                                ).then((value) {
                                  if (value != null) {
                                    var updateTotal =
                                        productDetailCubit.state.updateTotal;
                                    setState(() {
                                      product =
                                          productDetailCubit.state.product ??
                                              product;
                                    });

                                    debugPrint("product success: $product");

                                    Future.delayed(const Duration(seconds: 2),
                                        () {
                                      String scannedItem =
                                          "$updateTotal Lots: $value";
                                      onShowSuccessDialog(
                                        context: context,
                                        scannedItem: scannedItem,
                                        isOnUpdate: true,
                                      );
                                    });
                                  }
                                });
                              }
                              if (idTracking == 2) {
                                Navigator.push<String>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        UpdateProductQuantityScreen(
                                      tracking: tracking,
                                    ),
                                  ),
                                ).then((value) {
                                  if (value != null) {
                                    Future.delayed(const Duration(seconds: 2),
                                        () {
                                      String scannedItem = "SKU: $value";
                                      onShowSuccessDialog(
                                        context: context,
                                        scannedItem: scannedItem,
                                        isOnUpdate: true,
                                      );
                                    });
                                  }
                                });
                              }
                            },
                            updateLabel: "Update Qty",
                          );
                        },
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
                  height: 38.h,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: reusableTabBar(
                    tabs: _tabs.map((e) {
                      bool isSelectedTab = false;
                      isSelectedTab = tabController.index == _tabs.indexOf(e);

                      if (tracking.toLowerCase().contains("serial number")) {
                        totalInt = product.notDoneQty!.toInt();
                        total = totalInt.toString();

                        totalDoneInt = product.doneQty!.toInt();
                        totalDone = totalDoneInt.toString();
                      } else {
                        // log(product.toJson());

                        totalInt =
                            _tabs[0] == e ? product.notDoneQty!.toInt() : 0;
                        total = totalInt.toString();

                        if (product.returnQty != null) {
                          total = (totalInt - product.returnQty!)
                              .toInt()
                              .toString();
                          totalReturn = (product.returnQty)?.toInt() ?? 0;
                        }

                        // totalDoneInt = context
                        //         .watch<ProductMenuProductDetailCubit>()
                        //         .state
                        //         .product?.doneQty?.toInt() ??
                        //     totalDoneInt;
                        totalDone = product.doneQty?.toInt().toString() ?? "0";

                        if (totalDoneInt == totalInt) {
                          total = "0";

                          debugPrint("total0: $total");
                        }
                      }

                      if (isDamageProduct) {
                        int totalDamageQtyToInt = product.damagedQty!.toInt();
                        totalDamage = totalDamageQtyToInt;
                        totalInt = (totalInt - totalDamage).toInt();
                        total = totalInt.toString();
                      }

                      return buildTabLabel(
                        label: e,
                        total: e == _tabs[0]
                            ? "($total)"
                            : e == _tabs[1]
                                ? "($totalDone)"
                                : e.contains("Damage")
                                    ? "($totalDamage)"
                                    : "($totalReturn)",
                        isSelected: isSelectedTab,
                      );
                    }).toList(),
                    tabController: tabController,
                    isScrollable: true,
                    setState: setState,
                  ),
                ),
                // SizedBox(height: 12.h),
                Expanded(
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      BlocBuilder<ProductMenuProductDetailCubit,
                          ProductMenuProductDetailState>(
                        builder: (context, state) {
                          final doneQtyStatus = state.isDoneQty == true;

                          debugPrint(
                              "doneQtyStatus In Item Card: $doneQtyStatus");

                          return Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.w, vertical: 12.h),
                            child: (idTracking == 0 && !doneQtyStatus)
                                ? SizedBox(
                                    height: 600.h,
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const AlwaysScrollableScrollPhysics(),
                                        scrollDirection: Axis.vertical,
                                        itemCount: serialNumberList.length,
                                        itemBuilder: (context, index) {
                                          var item = serialNumberList[index];
                                          code = item.label;

                                          isCardHighlighted =
                                              serialNumberAddQtyResult
                                                  .contains(item);

                                          return Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 8.h),
                                              child: buildItemQuantity(
                                                code,
                                                isHighlighted:
                                                    isCardHighlighted,
                                                itemSerialNumber: item,
                                                tabIndex: 0,
                                              ));
                                        }),
                                  )
                                : (doneQtyStatus)
                                    ? Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "All Done",
                                            style: BaseText.grey10Text14
                                                .copyWith(
                                                    fontWeight:
                                                        BaseText.semiBold),
                                          ),
                                          Text(
                                            "All Lots have been completed.",
                                            style:
                                                BaseText.grey1Text14.copyWith(
                                              fontWeight: BaseText.light,
                                            ),
                                          )
                                        ],
                                      )
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          buildItemQuantity(
                                            code,
                                            itemProduct: product,
                                            tabIndex: 0,
                                            isHighlighted: isCardHighlighted,
                                          ),
                                        ],
                                      ),
                          );
                        },
                      ),
                      (idTracking == 0 && serialNumberResult.isNotEmpty)
                          ? Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.w, vertical: 12.h),
                              height: 600.h,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  itemCount: serialNumberResult.length,
                                  itemBuilder: (context, index) {
                                    var item = serialNumberResult[index];
                                    code = item.label;

                                    isHighlighted = serialNumberResult
                                        .contains(selectedSerialNumber);
                                    debugPrint("isHighlighted: qtl");

                                    return Padding(
                                        padding: EdgeInsets.only(bottom: 8.h),
                                        child: buildItemQuantity(
                                          code,
                                          isHighlighted: isHighlighted,
                                          itemSerialNumber: item,
                                          tabIndex: 1,
                                        ));
                                  }),
                            )
                          : (idTracking != 0)
                              ? Builder(builder: (context) {
                                  isHighlightedLots = totalDoneInt > 0;

                                  debugPrint("isHighlightedLots: qtl");
                                  return Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16.w, vertical: 12.h),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        buildItemQuantity(
                                          code,
                                          itemProduct: product,
                                          isHighlighted: isHighlightedLots,
                                          tabIndex: 1,
                                        ),
                                      ],
                                    ),
                                  );
                                })
                              : Column(
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
                      if (isReturnProduct && idTracking != 2)
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 12.h, horizontal: 16.w),
                          child: Column(
                            children: [
                              buildItemQuantityReturn(code),
                            ],
                          ),
                        ),
                      if (isReturnProduct && idTracking == 2)
                        ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            shrinkWrap: true,
                            itemCount: product.returnProductNoTracking?.length,
                            itemBuilder: (context, index) {
                              var item =
                                  product.returnProductNoTracking![index];

                              return Padding(
                                padding: EdgeInsets.only(
                                    top: (index == 0) ? 12.h : 8.h),
                                child: buildItemQuantityReturn(
                                  code,
                                  product: item,
                                ),
                              );
                            }),
                      if (isDamageProduct && idTracking != 2)
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 12.h, horizontal: 16.w),
                          child: Column(
                            children: [
                              buildItemQuantityDamage(code),
                            ],
                          ),
                        ),
                      if (isDamageProduct && idTracking == 2)
                        ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            shrinkWrap: true,
                            itemCount: product.damagedProducts?.length,
                            itemBuilder: (context, index) {
                              var item = product.damagedProducts![index];

                              return Padding(
                                padding: EdgeInsets.only(
                                    top: (index == 0) ? 12.h : 8.h),
                                child: buildItemQuantityDamage(
                                  code,
                                  itemProduct: item,
                                ),
                              );
                            })
                    ],
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
                    isCardHighlighted = true;
                    debugPrint(
                        "quantityDouble: ${product.notDoneQty}, isCardHighlighted: $isCardHighlighted");
                  });
                } else if (value != null) {
                  setState(() {
                    // var snResult = value as List<SerialNumber>;
                    serialNumberAddQtyResult = value as List<SerialNumber>;
                    serialNumberList.insertAll(0, serialNumberAddQtyResult);
                    product.serialNumber = serialNumberList;

                    var totalSerialNumber = serialNumberAddQtyResult.length;
                    product.productQty = product.productQty + totalSerialNumber;
                    product.notDoneQty =
                        product.notDoneQty! + totalSerialNumber;
                    isCardHighlighted = true;
                  });

                  debugPrint("notDoneQty: ${product.notDoneQty}");
                  // setState(() {
                  // });

                  // debugPrint(
                  //     "serialNumberResult: $serialNumberResult.map((e) => e.toJson())");
                }
              });
            },
            icon: Icons.add,
          ),
        ),
      ),
    );
  }

  Widget buildItemQuantityReturn(String code,
      {Pallet? itemProduct,
      ReturnProduct? product,
      bool isHighlighted = false}) {
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
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  code,
                  style: BaseText.black2Text14
                      .copyWith(fontWeight: BaseText.regular),
                ),
                SizedBox(height: 9.h),
                (isReturnProduct && idTracking == 2)
                    ? Text(
                        "Reason: ${product!.reason}",
                        style: BaseText.grey1Text12
                            .copyWith(fontWeight: BaseText.light),
                      )
                    : Text(
                        "Reason: Overstock",
                        style: BaseText.grey1Text12
                            .copyWith(fontWeight: BaseText.light),
                      ),
                SizedBox(height: 8.h),
                (isReturnProduct && idTracking == 2)
                    ? Text(
                        "Location: ${product!.location}",
                        style: BaseText.grey1Text12
                            .copyWith(fontWeight: BaseText.light),
                      )
                    : Text(
                        "Location: Warehouse A-342-3-4",
                        style: BaseText.grey1Text12
                            .copyWith(fontWeight: BaseText.light),
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
                            : (isReturnProduct && idTracking == 2)
                                ? "${product?.quantity}"
                                : "$totalReturn",
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

  String _getScanActualDate() {
    String actDateTime = "";
    String actDate = "";
    String actTime = "";
    actDate =
        "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";
    actTime = "${DateTime.now().hour}:${DateTime.now().minute}";
    actDateTime = "$actDate - $actTime";
    debugPrint(actDateTime);

    return actDateTime;
  }

  Container buildTrackingLabel(String tracking) {
    String receive = "0";

    int receiveInt = product.productQty.toInt();
    receive = receiveInt.toString();

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

  Widget buildItemQuantityDamage(String code,
      {ReturnProduct? itemProduct, bool isHighlighted = false}) {
    String damageQuantity = "";
    int? damageTemp = 0;
    if (itemProduct != null) {
      damageTemp = itemProduct.quantity;
    } else {
      damageTemp = totalDamage;
    }
    damageQuantity = damageTemp!.toInt().toString();

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
                  "Reason: Cracked housing",
                  style:
                      BaseText.grey1Text12.copyWith(fontWeight: BaseText.light),
                ),
                SizedBox(height: 8.h),
                Text(
                  "Location: Warehouse A-342-3-4",
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
                        damageQuantity,
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

  Widget buildItemQuantity(
    String code, {
    Pallet? itemProduct,
    bool isHighlighted = false,
    SerialNumber? itemSerialNumber,
    int tabIndex = 0,
  }) {
    if (itemProduct != null) {
      int? quantityInt = itemProduct.notDoneQty?.toInt();
      quantity = quantityInt.toString();
    }

    var qtyHeight = (itemSerialNumber?.isInputDate == true ||
            itemSerialNumber?.isInputDate == true)
        ? 80.h
        : 36.h;
    var qtyWidth = 60.w;

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
                (itemSerialNumber?.isInputDate == true)
                    ? RichText(
                        text: TextSpan(children: [
                        TextSpan(
                          text: "Exp. Date: ",
                          style: BaseText.baseTextStyle.copyWith(
                            color: ColorName.dateTimeColor,
                            fontSize: 12.sp,
                            fontWeight: BaseText.light,
                          ),
                        ),
                        TextSpan(
                            text: "-",
                            style: BaseText.grey1Text13.copyWith(
                              color: ColorName.mainColor,
                              fontWeight: BaseText.medium,
                            ))
                      ]))
                    : Text(
                        (tracking.toLowerCase().contains("serial"))
                            ? "${itemSerialNumber?.expiredDateTime}"
                            : "Exp. Date: 12/07/2024 - 15:00",
                        style: BaseText.baseTextStyle.copyWith(
                          color: ColorName.dateTimeColor,
                          fontSize: 12.sp,
                          fontWeight: BaseText.light,
                        ),
                      ),
                SizedBox(height: 12.h),
                (itemSerialNumber?.isInputDate == true)
                    ? InkWell(
                        onTap: () {
                          int idSerialNumber = itemSerialNumber?.id ?? 0;

                          int selectedIndex = 0;
                          Future.delayed(const Duration(milliseconds: 600), () {
                            showAdaptiveDialog<bool>(
                              context: context,
                              barrierDismissible: true,
                              builder: (context) {
                                return StatefulBuilder(
                                    builder: (context, dateTimeSetState) {
                                  return Dialog(
                                    insetPadding:
                                        EdgeInsets.symmetric(horizontal: 16.w),
                                    // titlePadding: EdgeInsets.zero,
                                    // contentPadding: EdgeInsets.zero,
                                    surfaceTintColor: ColorName.whiteColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(6.r))),
                                    child: Container(
                                      margin: EdgeInsets.zero,
                                      padding: EdgeInsets.all(16.w),
                                      width: double.infinity,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          _buildHeaderMenu(context),
                                          SizedBox(height: 16.h),
                                          Wrap(
                                            direction: Axis.horizontal,
                                            children: dateTimeButtons.map((e) {
                                              return GestureDetector(
                                                onTap: () {
                                                  dateTimeSetState(() {
                                                    selectedIndex = e.index;

                                                    debugPrint(selectedIndex
                                                        .toString());
                                                  });
                                                },
                                                child: buildCustomTab(
                                                    selectedIndex, e),
                                              );
                                            }).toList(),
                                          ),
                                          SizedBox(height: 8.h),
                                          (selectedIndex == 0)
                                              ? _buildDateBodySection(
                                                  dateTimeSetState)
                                              : buildTimeBodySection(
                                                  dateTimeSetState),
                                          SizedBox(height: 16.h),
                                          PrimaryButton(
                                            onPressed: () {
                                              if (selectedDate == null ||
                                                  selectedTime == null) {
                                                return;
                                              }

                                              var itemInputDateSerialNumber =
                                                  serialNumberList.firstWhere(
                                                      (element) =>
                                                          element.id ==
                                                          idSerialNumber);
                                              dateTimeSetState(() {
                                                final index = serialNumberList
                                                    .indexWhere((element) =>
                                                        element.id ==
                                                        idSerialNumber);
                                                serialNumberList[index] =
                                                    serialNumberList[index]
                                                        .copyWith(
                                                  isInputDate: false,
                                                  expiredDateTime:
                                                      "Exp. Date $selectedDate - $selectedTime",
                                                );
                                              });

                                              debugPrint(
                                                  itemInputDateSerialNumber
                                                      .toString());
                                              debugPrint(serialNumberList
                                                  .map((e) => e.expiredDateTime)
                                                  .toList()
                                                  .toString());

                                              Navigator.of(context).pop(true);
                                            },
                                            height: 40.h,
                                            title: "Save",
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                });
                              },
                            ).then((value) {
                              if (value == true) {
                                setState(() {
                                  debugPrint("state page nih");
                                });
                              }
                            });
                          });
                        },
                        child: buildExpDateButton(
                          label: 'Input Exp. Date',
                          eColor: ColorName.blue3Color,
                        ),
                      )
                    : (itemSerialNumber?.isEditDate == true)
                        ? buildExpDateButton(
                            label: "Edit Exp. Date",
                            eColor: ColorName.yellow2Color,
                          )
                        : const SizedBox()
              ],
            ),
            // Container(
            //   // height: double.infinity,
            //   width: 1.w,
            //   // padding: EdgeInsets.symmetric(vertical: 12.h),
            //   // decoration: BoxDecoration(
            //   color: ColorName.grey9Color,
            //   // ),
            // ),
            (tabIndex == 0)
                ? buildTotalQtyNotDone(qtyHeight, qtyWidth)
                : buildTotalQtyDone(qtyHeight, qtyWidth),
          ],
        ),
      ),
    );
  }

  Container buildTotalQtyNotDone(double qtyHeight, double qtyWidth) {
    return Container(
      // height: double.infinity,
      height: qtyHeight,
      width: qtyWidth,
      decoration: const BoxDecoration(
          border: Border(
        left: BorderSide(color: ColorName.grey9Color),
      )),
      child: Center(
        child: Text(
          (tracking.toLowerCase().contains("serial")) ? "1" : quantity,
          textAlign: TextAlign.center,
          style: BaseText.black2Text14.copyWith(
            fontWeight: BaseText.regular,
          ),
        ),
      ),
    );
  }

  Container buildTotalQtyDone(double qtyHeight, double qtyWidth) {
    return Container(
      // height: double.infinity,
      height: qtyHeight,
      width: qtyWidth,
      decoration: const BoxDecoration(
          border: Border(
        left: BorderSide(color: ColorName.grey9Color),
      )),
      child: Center(
        child: Text(
          totalDone,
          textAlign: TextAlign.center,
          style: BaseText.black2Text14.copyWith(
            fontWeight: BaseText.regular,
          ),
        ),
      ),
    );
  }

  Row _buildHeaderMenu(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Date and Time",
          style: BaseText.black2Text14.copyWith(
            fontWeight: BaseText.medium,
          ),
        ),
        GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(Icons.close))
      ],
    );
  }

  SingleChildScrollView _buildDateBodySection(StateSetter dateTimeSetState) {
    return SingleChildScrollView(
      child: Container(
        clipBehavior: Clip.antiAlias,
        height: 320.h,
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(4.r),
            border: Border.all(
              color: ColorName.grey12Color,
            )),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SfDateRangePicker(
              controller: _controller,
              view: DateRangePickerView.month,
              headerHeight: 40.h,
              headerStyle: DateRangePickerHeaderStyle(
                  textStyle: BaseText.grey10Text14
                      .copyWith(fontWeight: BaseText.medium),
                  textAlign: TextAlign.center),
              monthViewSettings: DateRangePickerMonthViewSettings(
                weekendDays: const [7],
                viewHeaderHeight: 40.h,
                enableSwipeSelection: false,
                dayFormat: "EEE",
                showTrailingAndLeadingDates: true,
                firstDayOfWeek: 1,
                viewHeaderStyle: DateRangePickerViewHeaderStyle(
                  textStyle: BaseText.grey1Text12.copyWith(
                    fontWeight: BaseText.regular,
                  ),
                ),
              ),
              monthCellStyle: DateRangePickerMonthCellStyle(
                textStyle: BaseText.grey1Text14,
                weekendTextStyle: _getRedText(),
              ),
              yearCellStyle: DateRangePickerYearCellStyle(
                  todayCellDecoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(6.w),
                    color: ColorName.grey6Color,
                  ),
                  todayTextStyle: BaseText.grey10Text14.copyWith(
                    fontWeight: BaseText.light,
                  ),
                  textStyle: BaseText.grey10Text14.copyWith(
                    fontWeight: BaseText.light,
                  )),
              selectionColor: ColorName.dateTimeColor,
              allowViewNavigation: true,
              onSelectionChanged: (dateRangePickerSelectionChangedArgs) {
                dateTimeSetState(() {
                  var dateSelected = _controller.selectedDate;
                  selectedDate = DateFormat('dd/MM/yyyy').format(dateSelected!);
                  debugPrint(selectedDate.toString());
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Container buildCustomTab(int selectedIndex, DateTimeButton e) {
    return Container(
      height: 40.h,
      width: 148.w,
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
        color: (selectedIndex == e.index)
            ? ColorName.mainColor
            : Colors.transparent,
        width: 1.8.h,
      ))),
      child: Center(
        child: Text(
          e.label,
          textAlign: TextAlign.center,
          style: (selectedIndex == e.index)
              ? BaseText.mainText14
              : BaseText.grey2Text14.copyWith(fontWeight: BaseText.light),
        ),
      ),
    );
  }

  TextStyle _getRedText() {
    return BaseText.redText14.copyWith(
      fontWeight: BaseText.regular,
      color: ColorName.badgeRedColor,
    );
  }

  Container buildTimeBodySection(StateSetter dateTimeSetState) {
    return Container(
        height: 300.h,
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(4.r),
            border: Border.all(
              color: ColorName.grey12Color,
            )),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 12.h),
            SizedBox(
              height: 44.h,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: timeHeaders.map<Widget>((e) {
                  double left = 0;
                  double right = 0;
                  final isFirst = e == timeHeaders.first;
                  final isLast = e == timeHeaders.last;
                  left = isFirst ? 12.w : 0;
                  right = isLast ? 28.w : 24.w;

                  return _buildHeaderDateAndTime(
                    e,
                    margin: EdgeInsets.fromLTRB(
                      left,
                      8.h,
                      right,
                      8.h,
                    ),
                  );
                }).toList(),
              ),
            ),
            TimePickerSpinner(
              spacing: 2,
              locale: const Locale('en', ''),
              time: _dateTime,
              is24HourMode: false,
              isShowSeconds: false,
              itemHeight: 40.h,
              itemWidth: 85.w,
              normalTextStyle:
                  BaseText.grey1Text12.copyWith(fontWeight: BaseText.light),
              highlightedTextStyle: BaseText.grey10TextStyle.copyWith(
                fontSize: 12.sp,
                fontWeight: BaseText.medium,
              ),
              isForce2Digits: true,
              alignment: Alignment.center,
              onTimeChange: (time) {
                dateTimeSetState(() {
                  selectedTime = "${time.hour}:${time.minute}";
                });
                debugPrint(selectedTime.toString());
              },
            ),
          ],
        ));
  }

  Container _buildHeaderDateAndTime(String title,
      {required EdgeInsetsGeometry margin}) {
    return Container(
      height: 28.h,
      width: 64.w,
      // decoration: BoxDecoration(
      //     border: Border.all(
      //   color: Colors.black,
      // )),
      margin: margin,
      padding: EdgeInsets.symmetric(vertical: 4.h),
      alignment: Alignment.center,
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: BaseText.grey2Text12,
      ),
    );
  }

  // child: CupertinoDatePicker(
  //     mode: CupertinoDatePickerMode
  //         .time,
  //     initialDateTime: DateTime(
  //         2024,
  //         1,
  //         1,
  //         time.hour,
  //         time.minute),
  //     minuteInterval: 1,
  //     use24hFormat: false,
  //     onDateTimeChanged:
  //         (DateTime newDateTime) {
  //       dateTimeSetState(() {
  //         selectedTime =
  //             newDateTime;

  //         debugPrint(
  //             "selectedTime: $selectedTime");
  //       });
  //     }),
}
