import 'package:device_preview/device_preview.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inventory_v3/presentation/receipt/screens/receipt_screen.dart';

import '../common/theme/color/color_name.dart';
import '../common/theme/color/colors.dart';
import '../presentation/onboarding/screens/onboarding_screen.dart';
import '../presentation/receipt/screens/receipt_detail_screen.dart';
import '../presentation/receipt/screens/receipt_list_screen.dart';
import '../presentation/receipt/screens/receipt_product_detail.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ));
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          // locale: DevicePreview.locale(context),
          // builder: DevicePreview.appBuilder,
          theme: _getThemeData(),
          darkTheme: _getThemeData(),
          scrollBehavior: const MaterialScrollBehavior().copyWith(dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
          }),
          home: const OnboardingScreen(),
        );
      },
    );
  }

  _getThemeData() {
    return ThemeData.light().copyWith(
        appBarTheme: const AppBarTheme(
            scrolledUnderElevation: 0,
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.white,
              statusBarIconBrightness: Brightness.light,
            )),
        bottomSheetTheme:
            const BottomSheetThemeData(surfaceTintColor: Colors.white),
        canvasColor: Colors.white,
        colorScheme: ColorScheme.fromSwatch(
                cardColor: Colors.white,
                primarySwatch: maincolors,
                backgroundColor: Colors.white,
                brightness: Brightness.light)
            .copyWith(background: Colors.white),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: ColorName.mainColor,
        ),
        textTheme: const TextTheme(
            // bodyLarge: BaseText.greyText12.copyWith(
            //   fontWeight: BaseText.light,
            //   color: ColorName.newGreyColor,
            // ),
            ),
        radioTheme: RadioThemeData(
          fillColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return ColorName.mainColor;
            }
            return ColorName.grey1Color;
          }),
          splashRadius: 0,
        ),
        dialogTheme: const DialogTheme(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
        ),
        // timePickerTheme: TimePickerThemeData(
        //   hourMinuteColor: MaterialStateColor.resolveWith((states) =>
        //       states.contains(MaterialState.selected)
        //           ? ColorName.selectedHourMinuteColor
        //           : ColorName.dotHistoryPipelineColor),
        //   dayPeriodBorderSide: const BorderSide(color: ColorName.mainColor),
        //   hourMinuteTextColor: MaterialStateColor.resolveWith(
        //     (states) => states.contains(MaterialState.selected)
        //         ? ColorName.mainColor
        //         : ColorName.blackColor,
        //   ),
        //   dialBackgroundColor: ColorName.dotHistoryPipelineColor,
        //   helpTextStyle: BaseText.blackText14.copyWith(
        //     fontWeight: BaseText.medium,
        //   ),
        // ),
        listTileTheme: const ListTileThemeData(
          tileColor: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.white,
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        cardColor: Colors.white,
        cardTheme: const CardTheme(surfaceTintColor: Colors.white));
  }
}
