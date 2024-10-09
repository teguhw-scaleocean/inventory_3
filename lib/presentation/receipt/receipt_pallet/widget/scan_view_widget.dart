import 'dart:developer';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inventory_v3/common/constants/text_constants.dart';
import 'package:inventory_v3/data/model/pallet.dart';
import 'package:inventory_v3/data/model/quality_control.dart';
import 'package:inventory_v3/data/model/scan_view.dart';
import 'package:inventory_v3/presentation/quality-control/pallet/screens/quality_control_detail_screen.dart';
import 'package:inventory_v3/presentation/receipt/receipt_product/cubit/scan/scan_cubit.dart';
import 'package:inventory_v3/presentation/receipt/receipt_product/cubit/scan/scan_state.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../../../common/components/primary_button.dart';
import '../../../../common/constants/local_images.dart';
import '../../../../common/theme/color/color_name.dart';
import '../../../../common/theme/text/base_text.dart';

class ScanView extends StatefulWidget {
  final String expectedValue;
  final ScanViewType scanType;
  final int? idTracking;
  final bool? isShowErrorPalletLots;

  const ScanView({
    Key? key,
    required this.expectedValue,
    required this.scanType,
    this.idTracking,
    this.isShowErrorPalletLots,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScanViewState();
}

class _ScanViewState extends State<ScanView> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Color bgColor = Colors.transparent;
  bool isFlashOn = false;

  late ScanViewType scanViewType;

  String expectedValue = "";
  int idTracking = 0;

  String appBarTitle = "";
  String labelOfScan = "";

  List<SerialNumber> serialNumberList = [];
  SerialNumber? serialNumber;
  bool isItemInputDate = false;
  bool isError = false;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  void initState() {
    super.initState();

    scanViewType = widget.scanType;
    idTracking = widget.idTracking ?? 0;
    expectedValue = widget.expectedValue;

    switch (scanViewType) {
      case ScanViewType.pallet:
        appBarTitle = "Scan Pallet";
        labelOfScan = TextConstants.scanPalletTittle;
        break;
      case ScanViewType.listProduct:
        appBarTitle = "Scan Product";
        labelOfScan = TextConstants.scanFromListTitle;
        break;
      case ScanViewType.product:
        appBarTitle = "Scan Product";
        labelOfScan = TextConstants.scanProductTittle;
        break;
      case ScanViewType.listPalletQC:
        appBarTitle = "Scan Pallet";
        labelOfScan = TextConstants.scanFromListPalletTitle;
      default:
    }

    isError = widget.isShowErrorPalletLots ?? false;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    //TODO: Check if scan serial number or lots
    if (idTracking == 0) {
      checkScanSerialNumber();
    } else if (idTracking == 1) {
      checkScanErrorLots();
    }
  }

  checkScanErrorLots() {
    if (isError) {
      controller?.pauseCamera();
      debugPrint("isError $isError");

      Future.delayed(const Duration(seconds: 1), () {
        onShowErrorDialog(
          context,
          isInputDate: false,
          body: _buildBodyErrorExceptionDialog(isShowPallet: false),
        );
      });
    }
  }

  Future getFlashStatus() async {
    await controller!.getFlashStatus().then((value) => setState(() {
          isFlashOn = value!;
          log("isFlashOn $isFlashOn");
        }));
  }

  checkScanSerialNumber() {
    serialNumberList =
        BlocProvider.of<ScanCubit>(context).getListOfSerialNumber();

    debugPrint(
        "serialNumberList: ${serialNumberList.map((e) => e.label).toList().toString()}");
    serialNumber = serialNumberList
        .firstWhere((element) => element.label == expectedValue);
    debugPrint("serialNumber: $serialNumber");

    if (serialNumber?.isInputDate == true) {
      Future.delayed(const Duration(seconds: 1), () {
        onShowErrorDialog(
          context,
          isInputDate: true,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(height: 10.h),
              Text(
                'Scan Error',
                style: BaseText.black2TextStyle.copyWith(
                  fontSize: 16.sp,
                  fontWeight: BaseText.semiBold,
                ),
              ),
              Container(height: 4.h),
              Text(
                "Cannot scan.\nPlease input expiration date.",
                textAlign: TextAlign.center,
                style: BaseText.grey2Text14.copyWith(
                  fontWeight: BaseText.light,
                ),
              )
            ],
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocListener<ScanCubit, ScanState>(
        listener: (context, state) {},
        child: Scaffold(
          backgroundColor: bgColor,
          body: Stack(
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: (isItemInputDate)
                      ? const SizedBox()
                      : _buildQrView(context)),
              Expanded(
                child: Container(
                  padding:
                      EdgeInsets.only(left: 16.w, right: 16.w, top: 18.5.h),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  if (serialNumber?.isInputDate == true) {
                                    Navigator.of(context)
                                        .pop("inputExpirationDate");
                                  } else {
                                    Navigator.of(context).pop();
                                  }
                                },
                                child: SvgPicture.asset(
                                  LocalImages.backIcon,
                                  color: ColorName.whiteColor,
                                  height: 24.w,
                                  width: 24.w,
                                  fit: BoxFit.scaleDown,
                                ),
                              ),
                              Text(
                                appBarTitle,
                                style: BaseText.whiteTextStyle.copyWith(
                                    fontSize: 16.sp,
                                    fontWeight: BaseText.medium),
                              )
                            ],
                          ),
                          GestureDetector(
                            onTap: () async {
                              await controller!.toggleFlash();
                              setState(() {});
                            },
                            child: FutureBuilder(
                                future: controller?.getFlashStatus(),
                                builder: (context, snapshot) {
                                  isFlashOn = snapshot.data ?? false;

                                  return Icon(
                                      (isFlashOn)
                                          ? Icons.flash_on
                                          : Icons.flash_off,
                                      size: 20.h,
                                      color: ColorName.whiteColor);
                                }),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              await controller!.flipCamera();
                              setState(() {});

                              // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              //     content: Text(isCameraFlip.toString())));
                            },
                            child: FutureBuilder(
                                future: controller?.getCameraInfo(),
                                builder: (context, snapshot) {
                                  debugPrint("snapshot.data: ${snapshot.data}");

                                  return Icon(
                                    Icons.flip_camera_android,
                                    size: 20.h,
                                    color: ColorName.whiteColor,
                                  );
                                }),
                          )
                        ],
                      ),
                      SizedBox(height: 62.h),
                      GestureDetector(
                        onTap: () async => await controller!.pauseCamera(),
                        child: Text(
                          labelOfScan,
                          textAlign: TextAlign.center,
                          style: BaseText.whiteTextStyle.copyWith(
                            fontSize: 18.sp,
                            fontWeight: BaseText.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),

              // Expanded(
              //   flex: 1,
              //   child: FittedBox(
              //     fit: BoxFit.contain,
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //       children: <Widget>[
              //         if (result != null)
              //           Text(
              //               'Barcode Type: ${result!.format}   Data: ${result!.code}')
              //         else
              //           const Text('Scan a code'),
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           crossAxisAlignment: CrossAxisAlignment.center,
              //           children: <Widget>[
              //             Container(
              //               margin: const EdgeInsets.all(8),
              //               child: ElevatedButton(
              //                   onPressed: () async {
              //                     await controller?.toggleFlash();
              //                     setState(() {});
              //                   },
              //                   child: FutureBuilder(
              //                     future: controller?.getFlashStatus(),
              //                     builder: (context, snapshot) {
              //                       return Text('Flash: ${snapshot.data}');
              //                     },
              //                   )),
              //             ),
              //             Container(
              //               margin: const EdgeInsets.all(8),
              //               child: ElevatedButton(
              //                   onPressed: () async {
              //                     await controller?.flipCamera();
              //                     setState(() {});
              //                   },
              //                   child: FutureBuilder(
              //                     future: controller?.getCameraInfo(),
              //                     builder: (context, snapshot) {
              //                       if (snapshot.data != null) {
              //                         return Text(
              //                             'Camera facing ${snapshot.data!}');
              //                       } else {
              //                         return const Text('loading');
              //                       }
              //                     },
              //                   )),
              //             )
              //           ],
              //         ),
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           crossAxisAlignment: CrossAxisAlignment.center,
              //           children: <Widget>[
              //             Container(
              //               margin: const EdgeInsets.all(8),
              //               child: ElevatedButton(
              //                 onPressed: () async {
              //                   await controller?.pauseCamera();
              //                 },
              //                 child: const Text('pause',
              //                     style: TextStyle(fontSize: 20)),
              //               ),
              //             ),
              //             Container(
              //               margin: const EdgeInsets.all(8),
              //               child: ElevatedButton(
              //                 onPressed: () async {
              //                   await controller?.resumeCamera();
              //                 },
              //                 child: const Text('resume',
              //                     style: TextStyle(fontSize: 20)),
              //               ),
              //             )
              //           ],
              //         ),
              //       ],
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: ColorName.whiteColor,
        borderRadius: 0,
        borderLength: 30,
        borderWidth: 3,
        cutOutSize: scanArea,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });

      //TODO Filter list

      // if (result?.format == BarcodeFormat.qrcode) {
      //   try {
      //     controller.stopCamera();
      //     Navigator.of(context).pop("18.00");
      //   } on FormatException {
      //     Future.delayed(const Duration(seconds: 2), () async {
      //       await controller.pauseCamera();
      //       onShowErrorDialog();
      //     });
      //   } on Exception {
      //     Future.delayed(const Duration(seconds: 2), () async {
      //       await controller.pauseCamera();
      // onShowErrorDialog(
      //   context,
      //   body: _buildBodyErrorExceptionDialog(),
      // );
      //     });
      //   }
      // }
    });

    if (isError) {
      Future.delayed(const Duration(seconds: 10), () {
        Navigator.of(context).pop(expectedValue);

        log("expectedValue after error: $expectedValue");
      });
    } else if (serialNumber?.isInputDate == true) {
      Future.delayed(const Duration(seconds: 10), () {
        Navigator.of(context).pop(expectedValue);

        log("expectedValue: $expectedValue");
      });
    } else if (scanViewType == ScanViewType.listPalletQC) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QualityControlDetailScreen(
            qualityControl: qualityControls.first,
          ),
        ),
      );
    } else {
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.of(context).pop(expectedValue);

        log("expectedValue: $expectedValue");
      });
    }
  }

  SizedBox _buildBodyErrorExceptionDialog({required bool isShowPallet}) {
    return SizedBox(
      // width: MediaQuery.sizeOf(context).width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(height: 10.h),
          Text(
            'Scan Error',
            style: BaseText.black2TextStyle.copyWith(
              fontSize: 16.sp,
              fontWeight: BaseText.semiBold,
            ),
          ),
          Container(height: 4.h),
          Text('Scan incorrect, please try again.',
              style: BaseText.grey2Text14.copyWith(fontWeight: BaseText.light)),
          Container(height: 1.h),
          (isShowPallet == true)
              ? Text("Pallet B654",
                  textAlign: TextAlign.center,
                  style: BaseText.mainText14
                      .copyWith(fontWeight: BaseText.semiBold))
              : const SizedBox(),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  onShowErrorDialog(BuildContext context,
      {required Widget body, required bool isInputDate}) {
    return AwesomeDialog(
      context: context,
      animType: AnimType.bottomSlide,
      headerAnimationLoop: false,
      dialogType: DialogType.error,
      showCloseIcon: true,
      width: double.infinity,
      // padding: EdgeInsets.symmetric(horizontal: 16.w),
      body: body,
      btnOkOnPress: () {
        debugPrint('OnClcik');
      },
      // btnOkIcon: Icons.check_circle,
      btnOk: (isInputDate)
          ? PrimaryButton(
              onPressed: () async {
                Navigator.of(context).pop();
              },
              height: 40.h,
              title: "OK",
            )
          : PrimaryButton(
              onPressed: () async {
                debugPrint('OnClcik OK');
                await controller?.resumeCamera();
                Navigator.of(context).pop();
              },
              height: 40.h,
              icon: SvgPicture.asset(
                LocalImages.scanIcons,
                width: 16.w,
                height: 16.w,
                color: ColorName.whiteColor,
              ),
              title: "Rescan",
            ),
      onDismissCallback: (type) {
        debugPrint('Dialog Dissmiss from callback $type');
      },
    ).show();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
