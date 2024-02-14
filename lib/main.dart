import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pass_gen_mobile/controllers/connectivity_controller.dart';
import 'package:pass_gen_mobile/controllers/json_controller.dart';
import 'package:pass_gen_mobile/controllers/setting_controller.dart';
import 'package:pass_gen_mobile/models/authentication.dart';
import 'package:pass_gen_mobile/views/app.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  bool isAuthenticated = await Authentication.authenticateWithBiometrics();
  if (isAuthenticated) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await initPrefs();
    runApp(const App());
  }
  else {
    main();
  }
}

Future<void> initPrefs() async {
  await SharedPreferences.getInstance().then((preferences) async {
    int? themeColorR = preferences.getInt("themeColorR");
    int? themeColorG = preferences.getInt("themeColorG");
    int? themeColorB = preferences.getInt("themeColorB");

    if (themeColorR != null && themeColorG != null && themeColorB != null) {
      SettingController.setThemeColor(Color.fromARGB(255, themeColorR, themeColorG, themeColorB));
    }

    Directory appDocDir = await getApplicationDocumentsDirectory();
    SettingController.setAccountLocalFilePath("${appDocDir.path}/AccMem.json");

    bool? useCloud = preferences.getBool("useCloud");

    if (useCloud == null || !useCloud) {
      await JsonController.loadAccountsFromLocal();
    }
    else {
      SettingController.setUseCloud(useCloud);

      if (await ConnectivityController.hasInternetConnection()) {
        await JsonController.loadAccountsFromCloud();

        SettingController.setWasCloudLoaded(true);
      }
      else {
        await JsonController.loadAccountsFromLocal();

        SettingController.setWasCloudLoaded(false);
      }
    }
  });
}
