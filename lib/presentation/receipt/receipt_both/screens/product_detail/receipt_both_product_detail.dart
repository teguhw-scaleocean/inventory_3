import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:inventory_v3/data/model/scan_view.dart';
import 'package:inventory_v3/presentation/receipt/receipt_pallet/widget/scan_view_widget.dart';
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
import '../../../../../data/model/product.dart';
import '../../../receipt_pallet/screens/product_detail/add_product_screen.dart';
import '../../../receipt_product/cubit/product_detail/product_menu_product_detail_cubit.dart';
import '../../../receipt_product/cubit/scan/scan_cubit.dart';
import '../../../receipt_product/cubit/scan/scan_state.dart';
import '../../../receipt_product/screens/product_detail/update_product_quantity_screen.dart';
import '../../cubit/receipt_detail/receipt_both_detail_cubit.dart';

class ReceiptBothProductDetailScreen extends StatefulWidget {
  final Product product;
  final String tracking;
  final String status;

  const ReceiptBothProductDetailScreen({
    super.key,
    required this.product,
    required this.tracking,
    required this.status,
  });

  @override
  State<ReceiptBothProductDetailScreen> createState() =>
      _ReceiptBothProductDetailScreenState();
}

class _ReceiptBothProductDetailScreenState
    extends State<ReceiptBothProductDetailScreen>
    with SingleTickerProviderStateMixin {
  late ProductMenuProductDetailCubit bothCubit;
  late Product product;
  String tracking = "";
  String status = "";
  // Scan Result
  String _scanBarcode = "";
  int idTracking = 0;

  final searchSerialNumberController = TextEditingController();
  final searchKey = GlobalKey<FormState>();

  List<SerialNumber> serialNumberList = [];
  List<SerialNumber> serialNumberResult = [];

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
  bool isHighlightedLotsNotDone = false;
  bool isHighlightedLots = false;

  @override
  void initState() {
    super.initState();

    debugPrint("ReceiptBothProductDetailScreen");

    tabController = TabController(length: _tabs.length, vsync: this);

    debugPrint(widget.product.toJson());

    product = widget.product;
    tracking = widget.tracking;
    status = widget.status;

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
      // BlocProvider.of<ProductMenuProductDetailCubit>(context)
      //     .setTotalToDone(serialNumberList.length);

      // BlocProvider.of<ScanCubit>(context)
      //     .setListOfSerialNumber(serialNumberList);

      // selectedDate =
      //     "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";
      // selectedTime = "${TimeOfDay.now().hour}:${TimeOfDay.now().minute}";
    }

    bothCubit = BlocProvider.of<ProductMenuProductDetailCubit>(context);
  }

  @override
  void dispose() {
    super.dispose();

    tabController.dispose();
    searchSerialNumberController.dispose();
  }

  _onSearch() {}
  _onClearData() {}

  @override
  Widget build(BuildContext context) {
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
                      Builder(
                        builder: (context) {
                          // debugPrint("doneQtyStatus: $doneQtyStatus");
                          return buildScanAndUpdateSection(
                            status: status,
                            onScan: () async {
                              String firstExpectedValue = "";

                              if (idTracking == 0) {
                                firstExpectedValue =
                                    serialNumberList.first.label;
                              } else {
                                // idTracking = 1;
                                firstExpectedValue = code;
                              }

                              final scanResult = Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ScanView(
                                            expectedValue: firstExpectedValue,
                                            scanType: ScanViewType.product,
                                            idTracking: idTracking,
                                          )));

                              scanResult.then((value) {
                                if (idTracking == 1) {
                                  bothCubit.getBothLotsScannedTotalDone(1);
                                  var doneQty =
                                      bothCubit.state.lotsTotalDone ?? 0;
                                  product.doneQty = doneQty.toDouble();

                                  debugPrint(
                                      "doneQty=====> ${product.doneQty}");

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
                              });
                            },
                            onUpdate: () {
                              if (idTracking == 1) {
                                bothCubit.getCurrentProduct(product);

                                Navigator.push<String>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        UpdateProductQuantityScreen(
                                      tracking: tracking,
                                    ),
                                  ),
                                ).then((value) {
                                  var doneFromUpdateTemp =
                                      bothCubit.state.updateTotal ?? 0;

                                  if (value != null) {
                                    Future.delayed(const Duration(seconds: 2),
                                        () {
                                      String scannedItem =
                                          "$doneFromUpdateTemp Lots: $value";
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

                      if (idTracking == 0) {
                        totalInt = serialNumberList.length;
                        total = totalInt.toString();

                        totalDoneInt = (serialNumberResult.isNotEmpty)
                            ? serialNumberResult.length
                            : 0;
                        totalDone = totalDoneInt.toString();
                      } else {
                        totalInt =
                            _tabs[0] == e ? product.productQty.toInt() : 0;
                        total = totalInt.toString();

                        totalDoneInt = context
                                .watch<ProductMenuProductDetailCubit>()
                                .state
                                .lotsTotalDone ??
                            totalDoneInt;
                        totalDone = totalDoneInt.toString();

                        if (totalDoneInt == totalInt) {
                          total = "0";

                          debugPrint("total0: $total");
                        }
                      }

                      return buildTabLabel(
                        label: e,
                        total: (_tabs[0] == e) ? "($total)" : "($totalDone)",
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
                      Builder(
                        builder: (context) {
                          // final doneQtyStatus = state.isDoneQty == true;

                          // debugPrint(
                          //     "doneQtyStatus In Item Card: $doneQtyStatus");

                          return Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.w, vertical: 12.h),
                            child:
                                // (idTracking == 0 && !doneQtyStatus)
                                (idTracking == 0)
                                    ? SizedBox(
                                        height: 600.h,
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const AlwaysScrollableScrollPhysics(),
                                            scrollDirection: Axis.vertical,
                                            itemCount: serialNumberList.length,
                                            itemBuilder: (context, index) {
                                              var item =
                                                  serialNumberList[index];
                                              code = item.label;

                                              bool isHighlighted = false;
                                              isHighlighted = serialNumberResult
                                                  .contains(item);
                                              debugPrint("isHighlighted: QTL");

                                              return Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 8.h),
                                                  child: buildItemQuantity(
                                                    code,
                                                    isHighlighted:
                                                        isHighlighted,
                                                    itemSerialNumber: item,
                                                    tabIndex: 0,
                                                  ));
                                            }),
                                      )
                                    // : (doneQtyStatus)
                                    //     ? Column(
                                    //         mainAxisAlignment:
                                    //             MainAxisAlignment.center,
                                    //         crossAxisAlignment:
                                    //             CrossAxisAlignment.center,
                                    //         children: [
                                    //           Text(
                                    //             "All Done",
                                    //             style: BaseText.grey10Text14
                                    //                 .copyWith(
                                    //                     fontWeight:
                                    //                         BaseText.semiBold),
                                    //           ),
                                    //           Text(
                                    //             "All Lots have been completed.",
                                    //             style:
                                    //                 BaseText.grey1Text14.copyWith(
                                    //               fontWeight: BaseText.light,
                                    //             ),
                                    //           )
                                    //         ],
                                    //       )
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          buildItemQuantity(
                                            code,
                                            itemProduct: product,
                                            tabIndex: 0,
                                            isHighlighted:
                                                isHighlightedLotsNotDone,
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
                          : (idTracking == 1 && totalDoneInt > 0)
                              ? Builder(builder: (context) {
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
                                          isHighlighted: true,
                                          tabIndex: 1,
                                        ),
                                      ],
                                    ),
                                  );
                                })
                              : (idTracking == 2 && totalDoneInt > 0)
                                  ? Builder(builder: (context) {
                                      // isHighlightedLots = totalDoneInt > 0;

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
                                              isHighlighted: true,
                                              tabIndex: 1,
                                            ),
                                          ],
                                        ),
                                      );
                                    })
                                  : (idTracking == 2 && totalDoneInt == 0)
                                      ? Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "No product scanned yet.",
                                              style: BaseText.grey10Text14
                                                  .copyWith(
                                                      fontWeight:
                                                          BaseText.semiBold),
                                            ),
                                            Text(
                                              "Completed items will be shown here.",
                                              style:
                                                  BaseText.grey1Text14.copyWith(
                                                fontWeight: BaseText.light,
                                              ),
                                            )
                                          ],
                                        )
                                      : const SizedBox()
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
                  ),
                ),
              );
              resultOfAddProduct.then((value) {
                if (value != null && value is double) {
                  debugPrint("resultOfAddProduct: $value");
                  setState(() {
                    var quantityDouble = value;
                    product.productQty = product.productQty + quantityDouble;
                    isHighlighted = true;
                    isHighlightedLotsNotDone = true;
                    // debugPrint(
                    //     "quantityDouble: ${product.productQty}, isCardHighlighted: $isCardHighlighted");
                    debugPrint(
                        "quantityDouble: ${product.productQty}, isHighlightedLotsNotDone: $isHighlightedLotsNotDone");
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

    switch (tracking) {
      case "Serial Number":
        if (serialNumberList.isNotEmpty) {
          // int receiveDouble = serialNumberList.length.toInt() +
          //     serialNumberResult.length.toInt();
          int receiveDouble = product.serialNumber?.length.toInt() ?? 0;
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

  Widget buildItemQuantity(
    String code, {
    Product? itemProduct,
    bool isHighlighted = false,
    SerialNumber? itemSerialNumber,
    int tabIndex = 0,
  }) {
    if (itemProduct != null) {
      int? quantityInt = itemProduct.productQty.toInt();
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
}
