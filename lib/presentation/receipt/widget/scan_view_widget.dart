import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inventory_v3/common/constants/text_constants.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../../common/constants/local_images.dart';
import '../../../common/theme/color/color_name.dart';
import '../../../common/theme/text/base_text.dart';

class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

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
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            Expanded(flex: 1, child: _buildQrView(context)),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 18.5.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () => Navigator.pop(context),
                              child: SvgPicture.asset(
                                LocalImages.backIcon,
                                color: ColorName.whiteColor,
                                height: 24.w,
                                width: 24.w,
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                            Text(
                              "Scan Pallet",
                              style: BaseText.whiteTextStyle.copyWith(
                                  fontSize: 16.sp, fontWeight: BaseText.medium),
                            )
                          ],
                        ),
                        GestureDetector(
                          onTap: () async {
                            await controller!.toggleFlash();
                            var isFlashOn = await controller!.getFlashStatus();

                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(isFlashOn.toString())));
                          },
                          child: Icon(Icons.flash_off,
                              size: 20.h, color: ColorName.whiteColor),
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
                            var isCameraFlip =
                                await controller!.getCameraInfo();

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(isCameraFlip.toString())));
                          },
                          child: Icon(
                            Icons.flip_camera_android,
                            size: 20.h,
                            color: ColorName.whiteColor,
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 62.h),
                    GestureDetector(
                      onTap: () async => await controller!.pauseCamera(),
                      child: Text(
                        TextConstants.scanPalletTittle,
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
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
