import 'package:flutter/material.dart';

class Settings {
  static const double leftPadding = 20;
  static const double rightPadding = 20;
  static const double topPadding = 20;
  static const double botPadding = 20;

  static Color themeColor = Colors.blue;
  static const Color iconColor = Colors.black;
  static Color cancelColor = themeColor.withAlpha(70);
  static const Color disabledColor = Color.fromARGB(255, 205, 205, 205);
  static const Color disabledIconColor = Color.fromARGB(255, 161, 161, 161);

  static bool useCloud = false;
  static bool wasCloudLoaded = false;

  static String accountFilePath = "";
}
