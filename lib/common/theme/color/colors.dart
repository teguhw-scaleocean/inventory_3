import 'package:flutter/material.dart';

const MaterialColor maincolors =
    MaterialColor(_maincolorsPrimaryValue, <int, Color>{
  50: Color(0xFFE0E6EC),
  100: Color(0xFFB3C1CE),
  200: Color(0xFF8097AE),
  300: Color(0xFF4D6D8E),
  400: Color(0xFF264E75),
  500: Color(_maincolorsPrimaryValue),
  600: Color(0xFF002A55),
  700: Color(0xFF00234B),
  800: Color(0xFF001D41),
  900: Color(0xFF001230),
});
const int _maincolorsPrimaryValue = 0xFF002F5D;

const MaterialColor maincolorsAccent =
    MaterialColor(_maincolorsAccentValue, <int, Color>{
  100: Color(0xFF698DFF),
  200: Color(_maincolorsAccentValue),
  400: Color(0xFF0340FF),
  700: Color(0xFF0038E8),
});
const int _maincolorsAccentValue = 0xFF3666FF;
