import 'dart:developer';
import 'dart:math' as math;

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
import 'package:inventory_v3/data/model/pallet.dart';
import 'package:inventory_v3/data/model/product.dart';
import 'package:inventory_v3/data/model/receipt.dart';
import 'package:inventory_v3/presentation/receipt/receipt_pallet/cubit/add_pallet_cubit/add_pallet_state.dart';
import 'package:inventory_v3/presentation/receipt/receipt_pallet/screens/pallet/add_pallet_screen.dart';
import 'package:inventory_v3/presentation/receipt/receipt_pallet/screens/receipt_product_detail.dart';
import 'package:inventory_v3/presentation/receipt/receipt_pallet/widget/scan_view_widget.dart';
import 'package:inventory_v3/presentation/receipt/receipt_product/cubit/product_detail/product_menu_product_detail_cubit.dart';
import 'package:inventory_v3/presentation/receipt/receipt_product/cubit/product_detail/product_menu_product_detail_state.dart';

import '../../../../common/components/status_badge.dart';
import '../../../../common/extensions/empty_space_extension.dart';
import '../../../../common/theme/color/color_name.dart';
import '../../../../common/theme/text/base_text.dart';
import 'product_detail/receipt_product_menu_of_product_detail_screen.dart';

class ReceiptProductMenuDetailScreen extends StatefulWidget {
  final Receipt? receipt;
  final String? scanBarcode;

  const ReceiptProductMenuDetailScreen(
      {super.key, this.receipt, this.scanBarcode = ""});

  @override
  State<ReceiptProductMenuDetailScreen> createState() =>
      _ReceiptProductMenuDetailScreenState();
}

class _ReceiptProductMenuDetailScreenState
    extends State<ReceiptProductMenuDetailScreen> {
  final TextEditingController _searchController = TextEditingController();
  late Receipt receipt;

  String date = "";
  String time = "";
  String _receive = "";
  String _scanBarcode = "0.00";
  String tracking = "";

  List<dynamic> palletUpdates = [];

  var selectedUpdatePallet;

  @override
  void initState() {
    super.initState();

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
      listProducts = products;
    } else if (receipt.packageStatus
        .toString()
        .toLowerCase()
        .contains("lots")) {
      listProducts = products2;
    } else if (receipt.packageStatus
        .toString()
        .toLowerCase()
        .contains("serial number")) {
      BlocProvider.of<ProductMenuProductDetailCubit>(context)
          .getInitListProduct();
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

  onShowSuccessDialog() {
    return AwesomeDialog(
      context: context,
      animType: AnimType.bottomSlide,
      headerAnimationLoop: false,
      dialogType: DialogType.success,
      showCloseIcon: true,
      width: double.infinity,
      // padding: EdgeInsets.symmetric(horizontal: 16.w),
      body: SizedBox(
        // width: MediaQuery.sizeOf(context).width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(height: 10.h),
            Text(
              'Scan Successful!',
              style: BaseText.black2TextStyle.copyWith(
                fontSize: 16.sp,
                fontWeight: BaseText.semiBold,
              ),
            ),
            Container(height: 4.h),
            Text('Great job! You successfully scanned',
                style:
                    BaseText.grey2Text14.copyWith(fontWeight: BaseText.light)),
            Container(height: 1.h),
            Text("Pallet B654",
                textAlign: TextAlign.center,
                style: BaseText.mainText14
                    .copyWith(fontWeight: BaseText.semiBold)),
            SizedBox(height: 24.h),
          ],
        ),
      ),
      btnOkOnPress: () {
        debugPrint('OnClcik');
      },
      // btnOkIcon: Icons.check_circle,
      btnOk: PrimaryButton(
        onPressed: () {
          debugPrint('OnClcik OK');
          Navigator.of(context).pop();
        },
        height: 40.h,
        title: "OK",
      ),
      onDismissCallback: (type) {
        debugPrint('Dialog Dissmiss from callback $type');
      },
    ).show();
  }

  onShowSuccessReceiveCompleteDialog({required String productName}) {
    return AwesomeDialog(
      context: context,
      animType: AnimType.bottomSlide,
      headerAnimationLoop: false,
      dialogType: DialogType.success,
      showCloseIcon: true,
      width: double.infinity,
      // padding: EdgeInsets.symmetric(horizontal: 16.w),
      body: SizedBox(
        // width: MediaQuery.sizeOf(context).width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(height: 10.h),
            Text(
              'Receive Complete!',
              style: BaseText.black2TextStyle.copyWith(
                fontSize: 16.sp,
                fontWeight: BaseText.semiBold,
              ),
            ),
            Container(height: 4.h),
            Text(
              'All $productName',
              style: BaseText.mainText14.copyWith(
                fontWeight: BaseText.medium,
              ),
            ),
            Container(height: 1.h),
            Text(
              "have been successfully done",
              textAlign: TextAlign.center,
              style: BaseText.grey2Text14.copyWith(
                fontWeight: BaseText.light,
              ),
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
      btnOkOnPress: () {
        debugPrint('OnClcik');
      },
      // btnOkIcon: Icons.check_circle,
      btnOk: PrimaryButton(
        onPressed: () {
          debugPrint('OnClcik OK');
          Navigator.of(context).pop();
        },
        height: 40.h,
        title: "OK",
      ),
      onDismissCallback: (type) {
        debugPrint('Dialog Dissmiss from callback $type');
      },
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const CustomAppBar(title: "Receipt Detail"),
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
                    children: [
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
                  ),
                  SizedBox(height: 14.h),
                  BlocConsumer<ProductMenuProductDetailCubit,
                          ProductMenuProductDetailState>(
                      listener: (context, state) {
                    debugPrint("listener");

                    Product currentProduct = state.product!;

                    debugPrint(currentProduct.serialNumber?.length.toString());
                    debugPrint(
                        currentProduct.scannedSerialNumber?.length.toString());

                    if (currentProduct.scannedSerialNumber?.length == 11) {
                      onShowSuccessReceiveCompleteDialog(
                          productName: currentProduct.productName.toString());
                    }
                  }, builder: (context, state) {
                    final list = state.products;

                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: list.length,
                        physics: const NeverScrollableScrollPhysics(),
                        primary: false,
                        itemBuilder: (context, index) {
                          Product item = list[index];

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

            // final addPalletResult = Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => AddPalletScreen(index: indexToAddPallet),
            //   ),
            // ).then((value) {
            //   debugPrint("addPalletResult: ${value.toString()}");

            //   if (value != null) {
            //     setState(() {
            //       listProducts = value as List<Product>;
            //     });
            //   }
            // });
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

                  onShowSuccessDialog();
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

                  onShowSuccessDialog();
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

  Row buildScanAndUpdateSection(
      {required String status, Function()? onScan, Function()? onUpdate}) {
    Color? scanButtonColor;
    Color? updateButtonColor;

    switch (status) {
      case "Late":
        scanButtonColor = ColorName.mainColor;
        updateButtonColor = ColorName.updateButtonColor;
        break;
      case "Ready":
        scanButtonColor = ColorName.mainColor;
        updateButtonColor = ColorName.updateButtonColor;
        break;
      default:
        scanButtonColor = null;
        updateButtonColor = null;
    }

    return Row(
      children: [
        Flexible(
          child: GestureDetector(
            onTap: onScan,
            child: DisableButton(
              height: 40.h,
              width: double.infinity,
              iconWidget: SvgPicture.asset(
                LocalImages.scanIcons,
                color: ColorName.whiteColor,
                height: 16.w,
                width: 16.w,
              ),
              title: "Scan",
              color: scanButtonColor,
            ),
          ),
        ),
        SizedBox(width: 16.w),
        Flexible(
          child: GestureDetector(
            onTap: onUpdate,
            child: DisableButton(
              height: 40.h,
              width: double.infinity,
              // width: 156,
              iconWidget: SvgPicture.asset(
                LocalImages.updatePalleteIcons,
                height: 16.w,
                width: 16.w,
              ),
              title: "Update Pallet",
              color: updateButtonColor,
            ),
          ),
        ),
      ],
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

  InkWell buildPalleteItemCard(Product product, String tracking) {
    Product product0;
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
        assignToDone(product0);
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
            builder: (context) => ReceiptProductMenuOfProductDetailScreen(
              product: product0,
              tracking: tracking,
              status: receipt.status,
            ),
          ),
        );

        resultOfProduct.then((value) {
          if (value != null) {
            // debugPrint("value: $value");
            // setState(() {
            //   product0 = value as Product;
            //   assignToReceive(product0);
            //   assignToDone(product0);
            // });

            BlocProvider.of<ProductMenuProductDetailCubit>(context)
                .scannedSerialNumberToProduct(value);
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
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    product0.productName,
                    style: BaseText.black2Text15
                        .copyWith(fontWeight: BaseText.medium),
                  ),
                  Text(
                    code,
                    style: BaseText.baseTextStyle.copyWith(
                      color: ColorName.grey14Color,
                      fontSize: 12.sp,
                      fontWeight: BaseText.light,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  buildDateTime(
                    label: "Sch. Date: ",
                    date: date,
                    time: time,
                    isEnable:
                        (product0.hasActualDateTime == true) ? false : true,
                  ),
                  (product0.hasActualDateTime == true)
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            buildDateTime(
                              label: "Act. Date: ",
                              date: date,
                              time: time,
                              isEnable: true,
                            ),
                            SizedBox(height: 6.h),
                          ],
                        )
                      : const SizedBox(),
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
                  value: (_scanBarcode.contains("null"))
                      ? "0.00 Unit"
                      : "$_scanBarcode Unit",
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  RichText buildDateTime({
    required String label,
    required String date,
    required String time,
    bool isEnable = true,
  }) {
    return RichText(
      text: TextSpan(children: [
        TextSpan(
          text: label,
          style: BaseText.baseTextStyle.copyWith(
            fontSize: 14.sp,
            fontWeight: BaseText.light,
            color: (isEnable) ? ColorName.dateTimeColor : ColorName.grey2Color,
          ),
        ),
        TextSpan(
          text: date,
          style: BaseText.baseTextStyle.copyWith(
            fontSize: 14.sp,
            fontWeight: BaseText.regular,
            color: (isEnable) ? ColorName.dateTimeColor : ColorName.grey2Color,
          ),
        ),
        WidgetSpan(
            child: Padding(
          padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 2.5.w),
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
            color: (isEnable) ? ColorName.dateTimeColor : ColorName.grey2Color,
          ),
        ),
      ]),
    );
  }

  void assignToReceive(Product product0) {
    // if (product0.serialNumber != null) {
    double? receiveDouble = product0.serialNumber?.length.toDouble();
    _receive = receiveDouble.toString();
    // }
  }

  void assignToDone(Product product0) {
    double? doneDouble = 0.00;
    doneDouble = product0.scannedSerialNumber?.length.toDouble();
    _scanBarcode = doneDouble.toString();
    // else {
    //   _scanBarcode = _scanBarcode;
    // }
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

  Widget buildPalletButtonSection({required String status}) {
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
            child: buildOutlineButton(context,
                label: "Damage", labelTextStyle: labelTextStyle)),
        SizedBox(width: 12.w),
        Flexible(
            child: buildOutlineButton(context,
                label: "Return", labelTextStyle: labelTextStyle)),
      ],
    );
  }
}
