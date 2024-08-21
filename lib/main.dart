import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:inventory_v3/app/main_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    // DevicePreview(
    //   enabled: !kReleaseMode,
    //   builder: (context) => const MainApp(),
    // ),

    const MainApp(),
  );
}
