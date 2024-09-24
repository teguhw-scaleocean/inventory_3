import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inventory_v3/common/components/reusable_widget.dart';
import 'package:inventory_v3/common/helper/tracking_helper.dart';
import 'package:inventory_v3/presentation/receipt/receipt_both/cubit/receipt_detail/receipt_both_detail_state.dart';
import 'package:inventory_v3/presentation/receipt/receipt_product/cubit/product_detail/product_menu_product_detail_state.dart';

import '../../../../common/components/custom_app_bar.dart';
import '../../../../common/components/custom_divider.dart';
import '../../../../common/components/primary_button.dart';
import '../../../../common/components/reusable_bottom_sheet.dart';
import '../../../../common/components/reusable_dropdown_menu.dart';
import '../../../../common/components/reusable_field_required.dart';
import '../../../../common/components/reusable_floating_action_button.dart';
import '../../../../common/components/status_badge.dart';
import '../../../../common/constants/local_images.dart';
import '../../../../common/theme/color/color_name.dart';
import '../../../../common/theme/text/base_text.dart';
import '../../../../data/model/pallet.dart';
import '../../../../data/model/product.dart';
import '../../../../data/model/receipt.dart';
import '../../../../data/model/scan_view.dart';
import '../../receipt_pallet/screens/pallet/add_pallet_screen.dart';
import '../../receipt_pallet/widget/scan_view_widget.dart';
import '../../receipt_product/cubit/product_detail/product_menu_product_detail_cubit.dart';
import '../cubit/receipt_detail/receipt_both_detail_cubit.dart';
import 'product_detail/receipt_both_product_detail.dart';

class ReceiptBothDetailScreen extends StatefulWidget {
  final Receipt? receipt;
  final String? scanBarcode;

  const ReceiptBothDetailScreen({super.key, this.receipt, this.scanBarcode});

  @override
  State<ReceiptBothDetailScreen> createState() =>
      _ReceiptBothDetailScreenState();
}

class _ReceiptBothDetailScreenState extends State<ReceiptBothDetailScreen> {
  late Receipt receipt;
  late ProductMenuProductDetailCubit cubit;

  String date = "";
  String time = "";
  String _receive = "";
  String _scanBarcode = "0.00";
  String tracking = "";

  List<dynamic> palletUpdates = [];

  var selectedUpdatePallet;
  bool isSelectPalletShowError = false;

  int idTracking = 0;
  int _scanAttempt = 0;
  // int updateAttempt = 0;

  final TextEditingController _searchController = TextEditingController();

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
    idTracking = TrackingHelper().getTrackingId(tracking);

    if (idTracking == 2) {
      cubit.getInitNoTrackingListProduct();
    } else if (idTracking == 1) {
      cubit.getInitLotsListProduct();
    } else if (idTracking == 0) {
      cubit.getInitListProduct();
    }

    date = receipt.dateTime.substring(0, 10);
    time = receipt.dateTime.substring(13, 18);

    // palletUpdates.sublist(0, 1);
    log("ReceiptBothDetailScreen");

    if (receipt.id == 1) {
      pallets.map((e) {
        if (e.id < 5) {
          palletUpdates.add(e.code);
        }
      }).toList(growable: false);
    } else {
      pallets.map((e) => palletUpdates.add(e.code)).toList(growable: false);
    }
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
                  SizedBox(height: 16.h),
                  buildScanAndUpdateSection(
                    status: receipt.status,
                    onScan: () async {
                      var expectedValue = "18.00";
                      // if (_scanAttempt == 0) {
                      //   expectedValue = "error";
                      // }

                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ScanView(
                            expectedValue: expectedValue,
                            scanType: ScanViewType.pallet,
                            idTracking: 1,
                            isShowErrorPalletLots: true,
                          ),
                        ),
                      ).then((value) {
                        if (value != null) {
                          setState(() {
                            _scanBarcode = value;
                            _scanAttempt = 1;
                          });
                          debugPrint("scanResultValue: $value");

                          Future.delayed(const Duration(seconds: 2), () {
                            onShowSuccessDialog(
                              context: context,
                              scannedItem:
                                  "Pallet ${listProducts.first.palletCode}",
                              isBoth: true,
                            );
                          });
                        }
                      });
                    },
                    onUpdate: () {
                      bool hasUpdateFocus = false;

                      final updateBottomSheet = reusableBottomSheet(
                          context,
                          isShowDragHandle: false,
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: SingleChildScrollView(
                              child: (palletUpdates.length < 5)
                                  ? buildDropdownMinHeight(hasUpdateFocus)
                                  : buildDropdownMaxHeight(hasUpdateFocus),
                            ),
                          ));

                      updateBottomSheet.then((value) => {
                            if (value == true)
                              {
                                Future.delayed(const Duration(seconds: 1), () {
                                  var scannedItem =
                                      "Pallet $selectedUpdatePallet";
                                  onShowSuccessDialog(
                                    context: context,
                                    scannedItem: scannedItem,
                                    isOnUpdate: true,
                                    isBoth: true,
                                  );
                                })
                              }
                          });
                    },
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

                    if (idTracking == 0) {
                      // Product? currentProduct;
                      // int? totalReceive;

                      // if (state.product != null) {
                      //   currentProduct = state.product!;
                      // }
                      // if (state.totalToDone != null) {
                      //   totalReceive = state.totalToDone!;
                      // }

                      // debugPrint(
                      //     currentProduct?.serialNumber?.length.toString());
                      // debugPrint(currentProduct?.scannedSerialNumber?.length
                      //     .toString());

                      // if (currentProduct?.scannedSerialNumber?.length ==
                      //     totalReceive) {
                      //   onShowSuccessReceiveCompleteDialog(
                      //       productName: currentProduct!.productName);
                      // }
                    } else if (idTracking != 0) {}
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

            final addPalletResult = Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddPalletScreen(
                  index: indexToAddPallet,
                  isFromBoth: true,
                ),
              ),
            );

            addPalletResult.then((value) {
              debugPrint("addPalletResult: ${value.toString()}");

              if (value != null) {
                setState(() {
                  listProducts = value as List<Product>;
                });
              }
            });
          },
          icon: Icons.add,
        ),
      ),
    );
  }

  InkWell buildPalleteItemCard(Product product, String tracking) {
    Product product0;
    product0 = product;

    String actualDate = "";
    String actualTime = "";

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
        if (product0.hasActualDateTime == true) {
          actualDate = product0.actualDateTime.toString().substring(0, 9);
          actualTime = product0.actualDateTime.toString().substring(12, 17);
        }

        break;
      case "No Tracking":
        _receive = product0.productQty.toString();
        double doneLotsQty = product0.doneQty ?? 0.00;
        _scanBarcode = doneLotsQty.toString();
        code = product0.code;
        break;
      case "Lots":
        _receive = product0.productQty.toString();
        double doneLotsQty = product0.doneQty ?? 0.00;
        _scanBarcode = doneLotsQty.toString();
        code = product0.lotsCode.toString();
        break;
      default:
    }

    // No Tracking
    // _receive = product0.productQty.toString();

    return InkWell(
      onTap: () {
        final resultOfProduct = Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReceiptBothProductDetailScreen(
              product: product0,
              tracking: tracking,
              status: receipt.status,
            ),
          ),
        );

        resultOfProduct.then((value) {
          if (value != null) {
            debugPrint("value: $value");
            setState(() {
              product0 = value as Product;
              assignToReceive(product0);
              assignToDone(product0);
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
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 0, 10.h),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: ColorName.borderColor,
                    width: 0.5,
                  ),
                ),
              ),
              child: Text(
                "Pallet ${product0.palletCode}",
                style:
                    BaseText.black2Text15.copyWith(fontWeight: BaseText.medium),
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
                              date: actualDate,
                              time: actualTime,
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

  void assignToReceive(Product product0) {
    // if (product0.serialNumber != null) {
    double? receiveDouble = product0.serialNumber?.length.toDouble();
    _receive = receiveDouble.toString();
    // }
  }

  void assignToDone(Product product0) {
    double? doneDouble = 0.00;
    if (product0.scannedSerialNumber != null) {
      doneDouble = product0.scannedSerialNumber?.length.toDouble();
    } else {
      doneDouble = product0.doneQty;
    }
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
            hintText: "  Select Pallet",
            listOfItemsValue: palletUpdates,
            selectedValue: selectedUpdatePallet,
            isExpand: hasUpdateFocus,
            onChange: (v) {
              updateSetState(() {
                selectedUpdatePallet = v;
                isSelectPalletShowError = false;
              });

              log("selectedUpdatePallet: $selectedUpdatePallet");
            },
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
          (isSelectPalletShowError)
              ? reusableFieldRequired()
              : const SizedBox(),
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
                if (selectedUpdatePallet == null) {
                  updateSetState(() {
                    isSelectPalletShowError = true;
                  });
                } else {
                  Navigator.pop(context, true);
                }
              },
              height: 40.h,
              title: "Submit",
            ),
          )
        ],
      );
    });
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
            hintText: "  Select Pallet",
            listOfItemsValue: palletUpdates,
            selectedValue: selectedUpdatePallet,
            isExpand: hasUpdateFocus,
            onChange: (v) {
              updateSetState(() {
                selectedUpdatePallet = v;
                isSelectPalletShowError = false;
              });
            },
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
          (isSelectPalletShowError)
              ? reusableFieldRequired()
              : const SizedBox(),
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
                if (selectedUpdatePallet == null) {
                  updateSetState(() {
                    isSelectPalletShowError = true;
                  });
                } else {
                  Navigator.pop(context, true);
                }
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
}
