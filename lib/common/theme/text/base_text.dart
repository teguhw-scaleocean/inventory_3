import 'package:flutter/material.dart';

import '../color/color_name.dart';

class BaseText {
  const BaseText();

  static TextStyle mainTextStyle = const TextStyle(
    fontFamily: "Lexend",
    color: ColorName.mainColor,
  );

  static TextStyle subTextStyle = const TextStyle(
    fontFamily: "Lexend",
    color: ColorName.subColor,
  );

  static TextStyle blackTextStyle = const TextStyle(
    fontFamily: "Lexend",
    color: ColorName.blackNewColor,
  );

  static TextStyle black2TextStyle = const TextStyle(
    fontFamily: "Lexend",
    color: ColorName.black2Color,
  );

  static TextStyle redTextStyle = const TextStyle(
    fontFamily: "Lexend",
    color: ColorName.redColor,
  );

  static TextStyle whiteTextStyle = const TextStyle(
    fontFamily: "Lexend",
    color: ColorName.whiteColor,
  );

  static TextStyle grey1TextStyle = const TextStyle(
    fontFamily: "Lexend",
    color: ColorName.grey1Color,
  );

  static TextStyle grey2TextStyle = const TextStyle(
    fontFamily: "Lexend",
    color: ColorName.grey2Color,
  );

  // Main Text
  static TextStyle mainText12 = mainTextStyle.copyWith(fontSize: 12);
  static TextStyle mainText13 = mainTextStyle.copyWith(fontSize: 13);
  static TextStyle mainText14 = mainTextStyle.copyWith(fontSize: 14);
  static TextStyle mainText16 = mainTextStyle.copyWith(fontSize: 16);
  static TextStyle mainText20 = mainTextStyle.copyWith(fontSize: 20);

  // Sub Text
  static TextStyle subText14 = subTextStyle.copyWith(fontSize: 14);

  // Grey Text 1
  static TextStyle grey1Text12 = grey1TextStyle.copyWith(fontSize: 12);
  static TextStyle grey1Text13 = grey1TextStyle.copyWith(fontSize: 13);
  static TextStyle grey1Text14 = grey1TextStyle.copyWith(fontSize: 14);

  // Grey Text 2
  static TextStyle grey2Text10 = grey2TextStyle.copyWith(fontSize: 10);
  static TextStyle grey2Text14 = grey2TextStyle.copyWith(fontSize: 14);

  static TextStyle blackText12 = blackTextStyle.copyWith(fontSize: 12);
  static TextStyle blackText14 = blackTextStyle.copyWith(fontSize: 14);
  static TextStyle blackText16 = black2TextStyle.copyWith(fontSize: 16);

  static TextStyle whiteText12 = whiteTextStyle.copyWith(fontSize: 12);
  static TextStyle whiteText14 = whiteTextStyle.copyWith(fontSize: 14);

  static TextStyle redText14 = redTextStyle.copyWith(fontSize: 14);

  // Font Weight
  static FontWeight light = FontWeight.w300;
  static FontWeight regular = FontWeight.w400;
  static FontWeight medium = FontWeight.w500;
  static FontWeight semiBold = FontWeight.w600;
  static FontWeight bold = FontWeight.w700;
  static FontWeight extraBold = FontWeight.w800;
  static FontWeight black = FontWeight.w900;
}
