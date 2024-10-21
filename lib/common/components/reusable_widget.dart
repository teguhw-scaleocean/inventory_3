import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inventory_v3/common/components/primary_button.dart';

import '../constants/local_images.dart';
import '../theme/color/color_name.dart';
import '../theme/text/base_text.dart';

RichText buildRequiredLabel(String label) {
  return RichText(
    text: TextSpan(
        text: label,
        style: BaseText.grey1Text14.copyWith(fontWeight: BaseText.regular),
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

Column buildDisableField({
  required String label,
  required String value,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: BaseText.grey1Text14.copyWith(fontWeight: BaseText.regular),
      ),
      SizedBox(height: 4.h),
      Container(
        height: 40.h,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: ColorName.grey16Color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.w),
            side: const BorderSide(
              color: ColorName.grey9Color,
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              value,
              style: BaseText.grey1Text14.copyWith(
                color: ColorName.grey17Color,
                fontWeight: BaseText.regular,
              ),
            )
          ],
        ),
      ),
      SizedBox(height: 14.h),
    ],
  );
}

GestureDetector buildScanButton({required Function()? onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: 36.h,
      width: 82.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: ColorName.mainColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            LocalImages.scanIcons,
            height: 16.w,
            width: 16.w,
          ),
          SizedBox(width: 8.w),
          LimitedBox(
            maxHeight: 16.h,
            child: Text(
              "Scan",
              style: BaseText.mainText14.copyWith(
                color: ColorName.mainColor,
                fontWeight: BaseText.medium,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Row buildScanAndUpdateSection(
    {required String status,
    Function()? onScan,
    Function()? onUpdate,
    String? updateLabel}) {
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
            title: updateLabel ?? "Update Pallet",
            color: updateButtonColor,
          ),
        ),
      ),
    ],
  );
}

onShowSuccessDialog({
  required BuildContext context,
  String? scannedItem,
  bool? isOnUpdate,
  bool? isOnReturn,
  bool? isDamage,
  bool? isBoth,
  Function()? onBothPressed,
}) {
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
            (isOnReturn == true)
                ? "Return Successful!"
                : (isOnUpdate == true)
                    ? 'Update Successful!'
                    : (isDamage == true)
                        ? "Damage Successful!"
                        : 'Scan Successful!',
            style: BaseText.black2TextStyle.copyWith(
              fontSize: 16.sp,
              fontWeight: BaseText.semiBold,
            ),
          ),
          Container(height: 4.h),
          Text(
              'Great job! You successfully ${(isOnReturn == true) ? 'returned' : (isOnUpdate == true) ? 'updated' : (isDamage == true) ? "damaged" : 'scanned'}',
              style: BaseText.grey2Text14.copyWith(fontWeight: BaseText.light)),
          Container(height: 1.h),
          Text(scannedItem ?? "",
              textAlign: TextAlign.center,
              style:
                  BaseText.mainText14.copyWith(fontWeight: BaseText.semiBold)),
          Container(height: 1.h),
          if (isBoth == true)
            Text(
              "Next, scan or update product.",
              style: BaseText.grey2Text14.copyWith(fontWeight: BaseText.light),
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
      onPressed: onBothPressed ??
          () {
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

onShowSuccessNewDialog({
  required BuildContext context,
  required Widget body,
  void Function()? onPressed,
  Widget? button,
  // String? scannedItem,
  // bool? isOnUpdate,
  // bool? isOnReturn,
  // bool? isBoth,
}) {
  return AwesomeDialog(
    context: context,
    animType: AnimType.bottomSlide,
    headerAnimationLoop: false,
    dialogType: DialogType.success,
    // showCloseIcon: true,
    // padding: EdgeInsets.symmetric(horizontal: 16.w),
    isDense: true,
    body: body,
    btnOkOnPress: () {
      debugPrint('OnClcik');
    },
    // btnOkIcon: Icons.check_circle,
    btnOk: button ??
        PrimaryButton(
          onPressed: onPressed,
          height: 40.h,
          title: "OK",
        ),
    onDismissCallback: (type) {
      debugPrint('Dialog Dissmiss from callback $type');
    },
  ).show();
}

Container buildExpDateButton({required String label, required Color eColor}) {
  return Container(
    width: 226.w,
    padding: EdgeInsets.symmetric(vertical: 8.h),
    decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: eColor)),
    child: Text(
      label,
      textAlign: TextAlign.center,
      style: BaseText.mainText12.copyWith(
        color: eColor,
        fontWeight: BaseText.medium,
      ),
    ),
  );
}

Container buildBadgeReturn() {
  return Container(
      // width: 60.w,
      // height: 21.h,
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 7.h),
      decoration: ShapeDecoration(
        color: ColorName.yellowReturnColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.fiber_manual_record,
              color: ColorName.whiteColor, size: 8.w),
          SizedBox(width: 4.w),
          Text(
            "Return",
            style: BaseText.whiteTextStyle.copyWith(
              fontSize: 10.sp,
              fontWeight: BaseText.medium,
            ),
          ),
        ],
      ));
}

Container buildBadgeDamage() {
  return Container(
      // width: 60.w,
      // height: 21.h,
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 7.h),
      decoration: ShapeDecoration(
        color: ColorName.damageColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.fiber_manual_record,
              color: ColorName.whiteColor, size: 8.w),
          SizedBox(width: 4.w),
          Text(
            "Damage",
            style: BaseText.whiteTextStyle.copyWith(
              fontSize: 10.sp,
              fontWeight: BaseText.medium,
            ),
          ),
        ],
      ));
}

Container buildBottomNavbar({required Widget child}) {
  return Container(
      width: double.infinity,
      height: 72.h,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 16.h),
      decoration: const BoxDecoration(
        color: ColorName.whiteColor,
        boxShadow: [
          BoxShadow(
            color: Color(0x33333A51),
            blurRadius: 16,
            offset: Offset(0, 4),
            spreadRadius: 0,
          )
        ],
      ),
      child: child);
}

Row buildProductDescPerRow({
  required String label,
  required String value,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: BaseText.grey2Text12),
      Text(value,
          style: BaseText.grey2Text12.copyWith(color: const Color(0xFF797979))),
    ],
  );
}
