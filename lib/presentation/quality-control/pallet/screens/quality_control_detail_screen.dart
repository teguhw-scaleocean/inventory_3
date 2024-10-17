import 'dart:developer';

import 'package:flutter/material.dart';
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
import 'package:inventory_v3/common/components/reusable_floating_action_button.dart';
import 'package:inventory_v3/common/constants/local_images.dart';
import 'package:inventory_v3/data/model/pallet.dart';
import 'package:inventory_v3/data/model/pallet_value.dart';
import 'package:inventory_v3/data/model/quality_control.dart';
import 'package:inventory_v3/presentation/quality-control/pallet/screens/quality_control_product_detail.dart';
import 'package:inventory_v3/presentation/receipt/receipt_pallet/screens/pallet/add_pallet_screen.dart';
import 'package:inventory_v3/presentation/receipt/receipt_product/cubit/product_detail/product_menu_product_detail_cubit.dart';
import 'package:inventory_v3/presentation/receipt/receipt_product/cubit/product_detail/product_menu_product_detail_state.dart';

import '../../../../common/components/reusable_field_required.dart';
import '../../../../common/components/reusable_widget.dart';
import '../../../../common/components/status_badge.dart';
import '../../../../common/theme/color/color_name.dart';
import '../../../../common/theme/text/base_text.dart';
import '../../../../data/model/return_pallet.dart';
import '../../../../data/model/scan_view.dart';
import '../../../receipt/receipt_pallet/widget/scan_view_widget.dart';

class QualityControlDetailScreen extends StatefulWidget {
  final QualityControl? qualityControl;
  final String? scanBarcode;

  const QualityControlDetailScreen(
      {super.key, this.qualityControl, this.scanBarcode = ""});

  @override
  State<QualityControlDetailScreen> createState() =>
      _QualityControlDetailScreenState();
}

class _QualityControlDetailScreenState
    extends State<QualityControlDetailScreen> {
  late ProductMenuProductDetailCubit cubit;
  final TextEditingController _searchController = TextEditingController();
  late QualityControl qualityControl;

  String date = "";
  String time = "";
  String _receive = "";
  String _scanBarcode = "0.00";
  String tracking = "";

  List<dynamic> palletUpdates = [];
  List<Pallet> palletList = [];

  List<Pallet> listScannedQc = [];

  int idTracking = 0;

  @override
  void initState() {
    super.initState();

    cubit = BlocProvider.of<ProductMenuProductDetailCubit>(context);

    if (widget.qualityControl != null) {
      qualityControl = widget.qualityControl!;
      debugPrint(qualityControl.toJson());
    }

    if (qualityControl.packageStatus
        .toString()
        .toLowerCase()
        .contains("no tracking")) {
      cubit.getInitNoTrackingListProduct();
      idTracking = 2;
      _scannedFromList();
    } else if (qualityControl.packageStatus
        .toString()
        .toLowerCase()
        .contains("lots")) {
      cubit.getInitLotsListProduct();
      idTracking = 1;
      _scannedFromList();
    } else if (qualityControl.packageStatus
        .toString()
        .toLowerCase()
        .contains("serial number")) {
      cubit.getInitListProduct();
    }

    date = qualityControl.dateTime.substring(0, 10);
    time = qualityControl.dateTime.substring(13, 18);
  }

  void _scannedFromList() {
    if (widget.scanBarcode != null) {
      _scanBarcode = widget.scanBarcode!;
      debugPrint("_scanBarcode: $_scanBarcode");
      cubit.scanFromList(_scanBarcode);

      Future.delayed(const Duration(seconds: 2), () async {
        String scannedItem = "Pallet ${cubit.state.pallets.first.palletCode}";
        onShowSuccessDialog(
          context: context,
          scannedItem: scannedItem,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
            onTap: () => Navigator.pop(context),
            title: "Quality Control Detail"),
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
                        qualityControl.name,
                        style: BaseText.blackText17
                            .copyWith(fontWeight: BaseText.medium),
                      ),
                      StatusBadge(
                        status: qualityControl.status,
                        color: qualityControl.statusColor,
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        qualityControl.packageName,
                        style: BaseText.grey1Text13
                            .copyWith(fontWeight: BaseText.light),
                      ),
                      Text(
                        qualityControl.packageStatus,
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
                  status: qualityControl.status,
                  onScan: () async {
                    String qty;
                    if (qualityControl.id == 4) {
                      qty = "11.0";
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ScanView(
                            expectedValue: qty,
                            scanType: ScanViewType.palletQc,
                            idTracking: idTracking,
                            isShowErrorPalletLots: true,
                          ),
                        ),
                      ).then((value) {
                        if (value != null) {
                          setState(() {
                            _scanBarcode = value;
                          });
                          // debugPrint("scanResultValue: $value");
                          double updateDoneQty = double.parse(_scanBarcode);
                          cubit.getDoneQuantity(
                              listPallets.first, updateDoneQty);

                          Future.delayed(const Duration(seconds: 2), () {
                            onShowSuccessDialog(
                              context: context,
                              scannedItem: listPallets.first.palletCode,
                            );
                          });
                        }
                      });
                    }
                  },
                  onUpdate: () {
                    bool hasUpdateFocus = false;
                    var palletTemp = [];

                    palletList = cubit.state.pallets;
                    palletList.map((e) {
                      if (e.isDoneQty == false || e.isDoneQty == null) {
                        palletTemp.add(e.palletCode);
                      }
                    }).toList();

                    palletUpdates = palletTemp;

                    debugPrint("pallet updates: ${palletUpdates.toString()}");

                    reusableBottomSheet(
                        context,
                        isShowDragHandle: false,
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: SingleChildScrollView(
                            child: buildDropdownMinHeight(
                              hasUpdateFocus,
                              palletUpdates,
                            ),
                          ),
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
                    status: qualityControl.status,
                    onTapReturn: () {},
                    onTapDamage: () {},
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

                          tracking = qualityControl.packageStatus.substring(10);
                          debugPrint("done: ${item.isDoneQty}");

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

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddPalletScreen(
                  index: indexToAddPallet,
                ),
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

  void _onReturnPalletAndProduct(value, BuildContext context) {
    var result = value as ReturnPallet;
    cubit.getReturnPalletAndProduct(result);
    Future.delayed(const Duration(milliseconds: 600), () {
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

  buildDropdownMaxHeight(bool hasUpdateFocus) {
    var selectedUpdatePallet;
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
            hintText: "  Select Pallet",
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

  buildDropdownMinHeight(bool hasUpdateFocus, list) {
    bool hasShowErrorRequired = false;

    var selectedUpdatePallet;
    selectedUpdatePallet = null;
    Pallet? selectedUpdatePalletValue;

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
            hintText: "  Select Pallet",
            hasSearch: false,
            maxHeight: 120.h,
            offset: const Offset(0, 121),
            controller: _searchController,
            borderColor:
                (hasUpdateFocus) ? ColorName.mainColor : ColorName.grey9Color,
            listOfItemsValue: list,
            selectedValue: selectedUpdatePallet,
            isExpand: hasUpdateFocus,
            onChange: (v) {
              updateSetState(() {
                selectedUpdatePallet =
                    list.firstWhere((element) => element == v);
                selectedUpdatePalletValue = listPallets
                    .firstWhere((element) => element.palletCode == v);
                hasShowErrorRequired = false;
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
          (hasUpdateFocus)
              ? Container(
                  height: 110.h,
                )
              : Container(height: 0),
          if (hasShowErrorRequired) reusableFieldRequired(),
          Padding(
            padding: EdgeInsets.only(
                top: (hasUpdateFocus) ? 36.h : 24.h, bottom: 24.h),
            child: PrimaryButton(
              onPressed: () {
                if (selectedUpdatePalletValue == null) {
                  updateSetState(() {
                    hasShowErrorRequired = true;
                  });

                  return;
                }
                if (selectedUpdatePalletValue != null) {
                  double updateDoneQty =
                      selectedUpdatePalletValue?.productQty ?? 0;
                  cubit.getDoneQuantity(
                      selectedUpdatePalletValue!, updateDoneQty);
                }

                // Navigator.pop(context);

                // updateSetState(() {
                // _scanBarcode = "12.00";
                // log("scanbarcode: $_scanBarcode");

                onShowSuccessDialog(
                  context: context,
                  scannedItem: selectedUpdatePalletValue?.palletCode,
                  isOnUpdate: true,
                );
                // });
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
        // product0.isDoneQty = _receive == _scanBarcode;
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
            builder: (context) => QualityControlProductDetailScreen(
              product: product0,
              tracking: tracking,
            ),
          ),
        );

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
                    (product0.palletCode.toLowerCase().contains("pallet"))
                        ? product0.palletCode
                        : "Pallet ${product0.palletCode}",
                    style: BaseText.black2Text15
                        .copyWith(fontWeight: BaseText.medium),
                  ),
                  Row(
                    children: [
                      if (product0.isDamage == true ||
                          product0.isDamagePalletAndProduct == true)
                        buildBadgeDamage(),
                      SizedBox(width: 4.w),
                      if (product0.isReturn == true ||
                          product0.isReturnPalletAndProduct == true)
                        buildBadgeReturn(),
                    ],
                  )
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
                  value: (product0.doneQty == null)
                      ? "0.0 Unit"
                      : "${product0.doneQty} Unit",
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
    void Function()? onTapDamage,
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
          child: InkWell(
            onTap: onTapDamage,
            child: buildOutlineButton(
              context,
              label: "Damage",
              labelTextStyle: labelTextStyle,
            ),
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
