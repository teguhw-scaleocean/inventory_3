import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inventory_v3/common/components/custom_app_bar.dart';
import 'package:inventory_v3/common/components/custom_divider.dart';
import 'package:inventory_v3/common/components/primary_button.dart';
import 'package:inventory_v3/common/components/reusable_bottom_sheet.dart';
import 'package:inventory_v3/common/components/reusable_dropdown_menu.dart';
import 'package:inventory_v3/common/components/reusable_dropdown_search.dart';
import 'package:inventory_v3/common/components/reusable_floating_action_button.dart';
import 'package:inventory_v3/common/constants/local_images.dart';
import 'package:inventory_v3/data/model/pallet_value.dart';
import 'package:inventory_v3/data/model/pallet.dart';
import 'package:inventory_v3/data/model/receipt.dart';
import 'package:inventory_v3/data/model/scan_view.dart';
import 'package:inventory_v3/presentation/receipt/receipt_pallet/cubit/add_pallet_cubit/add_pallet_state.dart';
import 'package:inventory_v3/presentation/receipt/receipt_pallet/screens/pallet/add_pallet_screen.dart';
import 'package:inventory_v3/presentation/receipt/receipt_pallet/screens/pallet/return_pallet_and_product_screen.dart';
import 'package:inventory_v3/presentation/receipt/receipt_pallet/screens/receipt_product_detail.dart';
import 'package:inventory_v3/presentation/receipt/receipt_pallet/widget/scan_view_widget.dart';
import 'package:inventory_v3/presentation/receipt/receipt_product/cubit/product_detail/product_menu_product_detail_cubit.dart';
import 'package:inventory_v3/presentation/receipt/receipt_product/cubit/product_detail/product_menu_product_detail_state.dart';

import '../../../../common/components/reusable_widget.dart';
import '../../../../common/components/status_badge.dart';
import '../../../../common/extensions/empty_space_extension.dart';
import '../../../../common/theme/color/color_name.dart';
import '../../../../common/theme/text/base_text.dart';
import '../../../../data/model/return_pallet.dart';
import '../cubit/add_pallet_cubit/add_pallet_cubit.dart';
import 'pallet/return_pallet_screen.dart';

class ReceiptDetailScreen extends StatefulWidget {
  final Receipt? receipt;
  final String? scanBarcode;

  const ReceiptDetailScreen({super.key, this.receipt, this.scanBarcode = ""});

  @override
  State<ReceiptDetailScreen> createState() => _ReceiptDetailScreenState();
}

class _ReceiptDetailScreenState extends State<ReceiptDetailScreen> {
  late ProductMenuProductDetailCubit cubit;
  final TextEditingController _searchController = TextEditingController();
  late Receipt receipt;

  String date = "";
  String time = "";
  String _receive = "";
  String _scanBarcode = "0.00";
  String tracking = "";

  List<dynamic> palletUpdates = [];

  var selectedUpdatePallet;

  int idTracking = 0;

  @override
  void initState() {
    super.initState();

    cubit = BlocProvider.of<ProductMenuProductDetailCubit>(context);

    if (widget.receipt != null) {
      receipt = widget.receipt!;
      debugPrint(receipt.toJson());
    }

    // if (widget.scanBarcode != null) {
    //   _scanBarcode = widget.scanBarcode!;
    //   debugPrint("_scanBarcode: $_scanBarcode");
    // }

    if (receipt.packageStatus
        .toString()
        .toLowerCase()
        .contains("no tracking")) {
      cubit.getInitNoTrackingListProduct();
      idTracking = 2;
    } else if (receipt.packageStatus
        .toString()
        .toLowerCase()
        .contains("lots")) {
      cubit.getInitLotsListProduct();
      idTracking = 1;
    } else if (receipt.packageStatus
        .toString()
        .toLowerCase()
        .contains("serial number")) {
      cubit.getInitListProduct();
    }

    date = receipt.dateTime.substring(0, 10);
    time = receipt.dateTime.substring(13, 18);

    pallets.map((e) {
      if (e.id < 5) {
        palletUpdates.add(e.code);
      }
    }).toList();

    // palletUpdates.sublist(0, 1);
    log("palletUpdates: ${palletUpdates.length}");
  }

  // Future<void> scanBarcodeNormal() async {
  //   String barcodeScanRes;
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   try {
  //     barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
  //         '#ff6666', 'Cancel', true, ScanMode.BARCODE);
  //     print(barcodeScanRes);
  //   } on PlatformException {
  //     barcodeScanRes = 'Failed to get platform version.';
  //   }

  //   // If the widget was removed from the tree while the asynchronous platform
  //   // message was in flight, we want to discard the reply rather than calling
  //   // setState to update our non-existent appearance.
  //   if (!mounted) return;

  //   setState(() {
  //     _scanBarcode = barcodeScanRes;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
            onTap: () => Navigator.pop(context), title: "Receipt Detail"),
        body: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        receipt.name,
                        style: BaseText.blackText17
                            .copyWith(fontWeight: BaseText.medium),
                      ),
                      StatusBadge(
                        status: receipt.status,
                        color: receipt.statusColor,
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        receipt.packageName,
                        style: BaseText.grey1Text13
                            .copyWith(fontWeight: BaseText.light),
                      ),
                      Text(
                        receipt.packageStatus,
                        style: BaseText.grey1Text13
                            .copyWith(fontWeight: BaseText.light),
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: buildScanAndUpdateSection(
                  status: receipt.status,
                  onScan: () async {
                    final scanResult = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ScanView(
                          expectedValue: "18.00",
                          scanType: ScanViewType.pallet,
                        ),
                      ),
                    ).then((value) {
                      if (value != null) {
                        setState(() {
                          _scanBarcode = value;
                        });
                        debugPrint("scanResultValue: $value");

                        Future.delayed(const Duration(seconds: 2), () {
                          onShowSuccessDialog(
                            context: context,
                            scannedItem: listPallets.first.palletCode,
                          );
                        });
                      }
                    });
                  },
                  onUpdate: () {
                    bool hasUpdateFocus = false;
                    reusableBottomSheet(
                        context,
                        isShowDragHandle: false,
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: SingleChildScrollView(
                              child: (palletUpdates.length < 5)
                                  ? buildDropdownMinHeight(hasUpdateFocus)
                                  : buildDropdownMaxHeight(hasUpdateFocus)),
                        ));
                  }),
            ),
            SizedBox(height: 16.h),
            const CustomDivider(height: 1.0, color: ColorName.grey9Color),
            Container(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: "Sch. Date: ",
                        style: BaseText.baseTextStyle.copyWith(
                          fontSize: 14.sp,
                          fontWeight: BaseText.regular,
                          color: ColorName.dateTimeColor,
                        ),
                      ),
                      TextSpan(
                        text: date,
                        style: BaseText.baseTextStyle.copyWith(
                          fontSize: 14.sp,
                          fontWeight: BaseText.medium,
                          color: ColorName.dateTimeColor,
                        ),
                      ),
                      WidgetSpan(
                          child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 6.h, horizontal: 2.5.w),
                        child: Container(
                          width: 7.w,
                          height: 1.h,
                          color: ColorName.grey2Color,
                          alignment: Alignment.center,
                        ),
                      )),
                      TextSpan(
                        text: time,
                        style: BaseText.baseTextStyle.copyWith(
                          fontSize: 14.sp,
                          fontWeight: BaseText.medium,
                          color: ColorName.dateTimeColor,
                        ),
                      ),
                    ]),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(LocalImages.receiveIcon),
                          const Dash(
                            dashColor: ColorName.grey2Color,
                            direction: Axis.vertical,
                            dashLength: 5,
                            length: 50,
                          ),
                          SvgPicture.asset(LocalImages.destinationIcon),
                        ],
                      ),
                      SizedBox(width: 16.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildPlaceStepper(
                            label: "Receive From",
                            location: "Main Storage Area",
                          ),
                          SizedBox(height: 20.h),
                          buildPlaceStepper(
                            label: "Destination Location",
                            location: "Medical Storage",
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const CustomDivider(height: 1.0, color: ColorName.grey9Color),
            Container(
              color: ColorName.backgroundColor,
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Pallet ",
                        style: BaseText.black2Text15
                            .copyWith(fontWeight: BaseText.medium),
                      ),
                      Text(
                        "(7)",
                        style: BaseText.black2Text15
                            .copyWith(fontWeight: BaseText.regular),
                      )
                    ],
                  ),
                  SizedBox(height: 12.h),
                  buildPalletButtonSection(
                    status: receipt.status,
                    onTapReturn: () {
                      if (receipt.id == 1) {
                        final returnResult = Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ReturnPalletAndProductScreen(
                                      idTracking: idTracking,
                                    )));
                      } else if (receipt.id == 6) {
                        final returnResult = Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ReturnPalletAndProductScreen(
                                      idTracking: idTracking,
                                    )));

                        returnResult.then((value) {
                          if (value != null) {
                            var result = value as ReturnPallet;
                            cubit.getReturnPalletAndProduct(result);
                            Future.delayed(const Duration(milliseconds: 600),
                                () {
                              onShowSuccessNewDialog(
                                context: context,
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                body: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(height: 10.h),
                                    Text(
                                      "Return Successful!",
                                      style: BaseText.black2TextStyle.copyWith(
                                        fontSize: 16.sp,
                                        fontWeight: BaseText.semiBold,
                                      ),
                                    ),
                                    Container(height: 4.h),
                                    Text(
                                      'Great job! You successfully returned the\npallet and product.',
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      style: BaseText.grey2Text14.copyWith(
                                        fontWeight: BaseText.light,
                                      ),
                                    ),
                                    SizedBox(height: 24.h),
                                  ],
                                ),
                              );
                            });
                          }
                        });
                      } else {
                        final returnResult = Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ReturnPalletScreen()));

                        returnResult.then((value) {
                          if (value != null) {
                            var result = value as ReturnPallet;

                            cubit.getReturnPallet(result);

                            Future.delayed(const Duration(seconds: 1), () {
                              onShowSuccessDialog(
                                context: context,
                                scannedItem: result.palletCode,
                                isOnReturn: true,
                              );
                            });
                          }
                        });
                      }
                    },
                  ),
                  SizedBox(height: 14.h),
                  BlocBuilder<ProductMenuProductDetailCubit,
                      ProductMenuProductDetailState>(builder: (context, state) {
                    final list = state.pallets;

                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: list.length,
                        physics: const NeverScrollableScrollPhysics(),
                        primary: false,
                        itemBuilder: (context, index) {
                          Pallet item = list[index];

                          tracking = receipt.packageStatus.substring(10);
                          debugPrint("tracking: $tracking");

                          return buildPalleteItemCard(item, tracking);
                        });
                  })
                ],
              ),
            )
          ],
        ),
        floatingActionButton: reusableFloatingActionButton(
          onTap: () {
            int indexToAddPallet = 0;

            switch (tracking) {
              case "Serial Number":
                break;
              case "No Tracking":
                indexToAddPallet = 1;
                break;
              case "Lots":
                indexToAddPallet = 2;
                break;

              default:
            }

            final addPalletResult = Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddPalletScreen(index: indexToAddPallet),
              ),
            ).then((value) {
              debugPrint("addPalletResult: ${value.toString()}");

              if (value != null) {
                setState(() {
                  listPallets = value as List<Pallet>;
                });
              }
            });
          },
          icon: Icons.add,
        ),
      ),
    );
  }

  buildDropdownMaxHeight(bool hasUpdateFocus) {
    return StatefulBuilder(builder: (context, updateSetState) {
      log("hasUpdateFocus: $hasUpdateFocus ");

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: reusableDragHandle()),
          SizedBox(height: 16.h),
          reusableTitleBottomSheet(context,
              title: "Update Pallet", isMainColor: false),
          SizedBox(height: 24.h),
          // buildDropdownMinHeight(
          //     updateSetState, hasUpdateFocus)
          buildLabelUpdatePallet(),
          SizedBox(height: 6.h),
          ReusableDropdownMenu(
            label: "",
            maxHeight: 500.h,
            offset: const Offset(0, 560),
            hasSearch: true,
            controller: _searchController,
            borderColor: ColorName.grey9Color,
            listOfItemsValue: palletUpdates,
            selectedValue: selectedUpdatePallet,
            isExpand: hasUpdateFocus,
            onChange: (v) {},
            onTap: (onTapValue) {
              updateSetState(() {
                // selectedUpdatePallet = onTapValue;
                // dropdownGap = 142.h;
                // submitButtonGap = 48.h;
                hasUpdateFocus = !hasUpdateFocus;
                log("hasUPdateFocus: $hasUpdateFocus");
              });
            },
          ),
          (hasUpdateFocus)
              ? Container(
                  height: 505.h,
                )
              : Container(height: 0),
          Padding(
            padding: EdgeInsets.only(
                top: (hasUpdateFocus) ? 36.h : 24.h, bottom: 24.h),
            child: PrimaryButton(
              onPressed: () {
                Navigator.pop(context);

                updateSetState(() {
                  _scanBarcode = "18.00";
                  log("scanbarcode: $_scanBarcode");

                  onShowSuccessDialog(
                    context: context,
                    scannedItem: listPallets.first.palletCode,
                  );
                });
              },
              height: 40.h,
              title: "Submit",
            ),
          )
        ],
      );
    });
  }

  buildDropdownMinHeight(bool hasUpdateFocus) {
    return StatefulBuilder(builder: (context, updateSetState) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: reusableDragHandle()),
          SizedBox(height: 16.h),
          reusableTitleBottomSheet(context,
              title: "Update Pallet", isMainColor: false),
          SizedBox(height: 24.h),
          // buildDropdownMinHeight(
          //     updateSetState, hasUpdateFocus)
          buildLabelUpdatePallet(),
          SizedBox(height: 6.h),
          ReusableDropdownMenu(
            label: "",
            hasSearch: false,
            maxHeight: 120.h,
            offset: const Offset(0, 121),
            controller: _searchController,
            borderColor: ColorName.grey9Color,
            listOfItemsValue: palletUpdates,
            selectedValue: selectedUpdatePallet,
            isExpand: hasUpdateFocus,
            onChange: (v) {},
            onTap: (onTapValue) {
              updateSetState(() {
                // selectedUpdatePallet = onTapValue;
                // dropdownGap = 142.h;
                // submitButtonGap = 48.h;
                hasUpdateFocus = !hasUpdateFocus;
                log("hasUPdateFocus: $hasUpdateFocus");
              });
            },
          ),
          (hasUpdateFocus)
              ? Container(
                  height: 110.h,
                )
              : Container(height: 0),
          Padding(
            padding: EdgeInsets.only(
                top: (hasUpdateFocus) ? 36.h : 24.h, bottom: 24.h),
            child: PrimaryButton(
              onPressed: () {
                Navigator.pop(context);

                updateSetState(() {
                  _scanBarcode = "18.00";
                  log("scanbarcode: $_scanBarcode");

                  onShowSuccessDialog(
                    context: context,
                    scannedItem: listPallets.first.palletCode,
                  );
                });
              },
              height: 40.h,
              title: "Submit",
            ),
          )
        ],
      );
    });
  }

  RichText buildLabelUpdatePallet() {
    return RichText(
      text: TextSpan(
          text: "Pallet",
          style: BaseText.grey2Text12.copyWith(fontWeight: BaseText.regular),
          children: [
            TextSpan(
              text: " *",
              style: BaseText.redText14.copyWith(
                fontWeight: BaseText.medium,
                color: ColorName.badgeRedColor,
              ),
            ),
          ]),
    );
  }

  Widget buildOutlineButton(BuildContext context,
      {required String label,
      Color? borderColor,
      Color? backgroundColor,
      TextStyle? labelTextStyle}) {
    return Material(
        // onPressed: () {},
        color: backgroundColor ?? ColorName.whiteColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.r),
            side: BorderSide(
              color: borderColor ?? ColorName.grey6Color,
              width: 1,
            )),
        elevation: 0,
        child: Container(
          height: 36.h,
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Center(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: labelTextStyle ??
                  BaseText.baseTextStyle.copyWith(
                    fontSize: 12.sp,
                    fontWeight: BaseText.medium,
                    color: ColorName.grey12Color,
                  ),
            ),
          ),
        ));
  }

  InkWell buildPalleteItemCard(Pallet product, String tracking) {
    Pallet product0;
    product0 = product;

    // Code
    String code = "";

    // By tracking type
    // if statement / switch
    // Code, Receive

    switch (tracking) {
      case "Serial Number":
        // Serial Number
        assignToReceive(product0);
        code = product0.code;
        break;
      case "No Tracking":
        _receive = product0.productQty.toString();
        code = product0.code;

        break;
      case "Lots":
        _receive = product0.productQty.toString();
        code = product0.lotsCode.toString();
        break;
      default:
    }

    // No Tracking
    _receive = product0.productQty.toString();

    return InkWell(
      onTap: () {
        final resultOfProduct = Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ReceiptProductDetailScreen(
                    product: product0, tracking: tracking)));

        resultOfProduct.then((value) {
          if (value != null) {
            debugPrint("value: $value");
            setState(() {
              product0 = value as Pallet;
              assignToReceive(product0);
            });
          }
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        // semanticContainer: true,
        // clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.r)),
          shadows: const [
            BoxShadow(
              color: Color(0x19000000),
              blurRadius: 2,
              offset: Offset(0, 0.44),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Color(0x0C000000),
              blurRadius: 3.52,
              offset: Offset(0, 1.76),
              spreadRadius: 1.32,
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 10.h),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: ColorName.borderColor,
                    width: 0.5,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Pallet ${product0.palletCode}",
                    style: BaseText.black2Text15
                        .copyWith(fontWeight: BaseText.medium),
                  ),
                  (product0.isReturn == true ||
                          product0.isReturnPalletAndProduct == true)
                      ? buildBadgeReturn()
                      : const SizedBox()
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    product0.productName,
                    style: BaseText.grey1Text15,
                  ),
                  Text(
                    code,
                    style: BaseText.baseTextStyle.copyWith(
                      color: ColorName.grey14Color,
                      fontSize: 13.sp,
                      fontWeight: BaseText.light,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: "Sch. Date: ",
                        style: BaseText.baseTextStyle.copyWith(
                          fontSize: 14.sp,
                          fontWeight: BaseText.light,
                          color: ColorName.dateTimeColor,
                        ),
                      ),
                      TextSpan(
                        text: date,
                        style: BaseText.baseTextStyle.copyWith(
                          fontSize: 14.sp,
                          fontWeight: BaseText.regular,
                          color: ColorName.dateTimeColor,
                        ),
                      ),
                      WidgetSpan(
                          child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 6.h, horizontal: 2.5.w),
                        child: Container(
                          width: 7.w,
                          height: 1.h,
                          color: ColorName.grey2Color,
                          alignment: Alignment.center,
                        ),
                      )),
                      TextSpan(
                        text: time,
                        style: BaseText.baseTextStyle.copyWith(
                          fontSize: 14.sp,
                          fontWeight: BaseText.regular,
                          color: ColorName.dateTimeColor,
                        ),
                      ),
                    ]),
                  ),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
            Row(
              children: [
                _buildBottomCardSection(
                  label: "Receive",
                  value: "$_receive Unit",
                ),
                _buildBottomCardSection(
                  label: "Done",
                  value: "$_scanBarcode Unit",
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void assignToReceive(Pallet product0) {
    if (product0.serialNumber != null) {
      double? receiveDouble = product0.serialNumber?.length.toDouble();
      _receive = receiveDouble.toString();
    }
  }

  Widget _buildBottomCardSection(
      {required String label, required String value}) {
    bool isReceive = false;
    Color bgColor;

    if (label.contains("Receive")) {
      isReceive = true;
      bgColor = ColorName.receiveBgColor;
    } else {
      bgColor = ColorName.doneBgColor;
    }

    return Flexible(
      child: Container(
        height: 60.h,
        width: MediaQuery.sizeOf(context).width / 2,
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.only(
            bottomLeft: (isReceive)
                ? const Radius.circular(6)
                : const Radius.circular(0),
            bottomRight: (!isReceive)
                ? const Radius.circular(6)
                : const Radius.circular(0),
          ),
        ),
        child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(children: [
              TextSpan(
                text: "$label\n",
                style: BaseText.baseTextStyle.copyWith(
                    fontSize: 13.sp,
                    color: (isReceive)
                        ? ColorName.receiveLabelColor
                        : ColorName.doneLabelColor),
              ),
              TextSpan(
                text: value,
                style: BaseText.baseTextStyle.copyWith(
                  fontSize: 14.sp,
                  color: (isReceive)
                      ? ColorName.receiveValueColor
                      : ColorName.doneValueColor,
                  fontWeight: BaseText.medium,
                ),
              )
            ])),
      ),
    );
  }

  Widget buildPlaceStepper({required String label, required String location}) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: BaseText.grey2Text13,
          ),
          Text(
            location,
            style: BaseText.grey10Text14.copyWith(fontWeight: BaseText.medium),
          )
        ],
      ),
    );
  }

  Widget buildPalletButtonSection({
    required String status,
    void Function()? onTapReturn,
  }) {
    TextStyle? labelTextStyle;
    switch (status) {
      case "Late":
        labelTextStyle = BaseText.mainText12
            .copyWith(color: ColorName.main2Color, fontWeight: BaseText.medium);
        break;
      case "Ready":
        labelTextStyle = BaseText.mainText12
            .copyWith(color: ColorName.main2Color, fontWeight: BaseText.medium);
        break;
      default:
    }

    return Row(
      children: [
        Flexible(
          child: buildOutlineButton(
            context,
            label: "Damage",
            labelTextStyle: labelTextStyle,
          ),
        ),
        SizedBox(width: 12.w),
        Flexible(
          child: InkWell(
            onTap: onTapReturn,
            child: buildOutlineButton(context,
                label: "Return", labelTextStyle: labelTextStyle),
          ),
        ),
      ],
    );
  }
}
