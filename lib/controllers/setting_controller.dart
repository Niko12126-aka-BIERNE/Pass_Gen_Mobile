import 'package:flutter/material.dart';
import 'package:pass_gen_mobile/models/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingController {
  static double getLeftPadding() {
    return Settings.leftPadding;
  }

  static double getRightPadding() {
    return Settings.rightPadding;
  }

  static double getTopPadding() {
    return Settings.topPadding;
  }

  static double getBotPadding() {
    return Settings.botPadding;
  }

  static Color getThemeColor() {
    return Settings.themeColor;
  }

  static Color getIconColor() {
    return Settings.iconColor;
  }

  static Color getCancelColor() {
    return Settings.cancelColor;
  }

  static String getAccountLocalFilePath() {
    return Settings.accountFilePath;
  }

  static Color getDisasbledColor() {
    return Settings.disabledColor;
  }

  static Color getDisasbledIconColor() {
    return Settings.disabledIconColor;
  }

  static bool getUseCloud() {
    return Settings.useCloud;
  }

  static bool getWasCloudLoaded() {
    return Settings.wasCloudLoaded;
  }

  static void setWasCloudLoaded(bool wasCloudLoaded) {
    Settings.wasCloudLoaded = wasCloudLoaded;
  }

  static void setUseCloud(bool useCloud) {
    Settings.useCloud = useCloud;

    SharedPreferences.getInstance().then((preferences) {
      preferences.setBool("useCloud", useCloud);
    });
  }

  static void setThemeColor(Color color) {
    Settings.themeColor = color;
    Settings.cancelColor = color.withAlpha(70);

    SharedPreferences.getInstance().then((preferences) {
      preferences.setInt("themeColorR", color.red);
      preferences.setInt("themeColorG", color.green);
      preferences.setInt("themeColorB", color.blue);
    });
  }

  static void setAccountLocalFilePath(String path) {
    Settings.accountFilePath = path;
  }
}
