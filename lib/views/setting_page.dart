import 'package:flutter/material.dart';
import 'package:pass_gen_mobile/controllers/connectivity_controller.dart';
import 'package:pass_gen_mobile/controllers/json_controller.dart';
import 'package:pass_gen_mobile/controllers/setting_controller.dart';
import 'package:pass_gen_mobile/controllers/snack_bar_controller.dart';
import 'package:pass_gen_mobile/models/custom_dialog.dart';
import 'package:pass_gen_mobile/views/app_scaffold.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:restart_app/restart_app.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => SettingPageState();
}

class SettingPageState extends State<SettingPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(title: "Settings", body: settingPageBody());
  }

  final MaterialStateProperty<Icon?> thumbIcon =
      MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.close);
    },
  );

  Widget settingPageBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: SettingController.getTopPadding()),
            child: const Text(
              "Theme color",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: SettingController.getLeftPadding(),
              right: SettingController.getRightPadding()
            ),
            child: const Divider(),
          ),
          ColorPicker(
            color: SettingController.getThemeColor(),
            pickersEnabled: const <ColorPickerType, bool>{
              ColorPickerType.both: false,
              ColorPickerType.primary: false,
              ColorPickerType.accent: false,
              ColorPickerType.bw: false,
              ColorPickerType.custom: false,
              ColorPickerType.wheel: true,
            },
            onColorChanged: (color) {
              setState(() {
                SettingController.setThemeColor(color);
              });
            }
          ),
          Padding(
            padding: EdgeInsets.only(top: SettingController.getTopPadding()),
            child: const Text(
              "Sync with cloud",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: SettingController.getLeftPadding(),
              right: SettingController.getRightPadding()
            ),
            child: const Divider(),
          ),
          Switch(
            activeTrackColor: SettingController.getThemeColor(),
            inactiveTrackColor: SettingController.getCancelColor(),
            thumbIcon: thumbIcon,
            value: SettingController.getUseCloud(),
            onChanged: (bool value) async {
              setState(() {
                SettingController.setUseCloud(value);
              });

              if (await CustomDialog.confirmDialog(context, 'Restart app to change this setting')) {
                Restart.restartApp();
              }
              else {
                setState(() {
                  SettingController.setUseCloud(!value);
                });
              }
              //ScaffoldMessenger.of(context).showSnackBar(SnackBarController.restartApp());
            },
          ),
          Padding(
            padding: EdgeInsets.only(top: SettingController.getTopPadding()),
            child: const Text(
              "Load cloud to local",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: SettingController.getLeftPadding(),
              right: SettingController.getRightPadding()
            ),
            child: const Divider(),
          ),
          SizedBox(
            width: 120,
            child: FloatingActionButton(
              backgroundColor: SettingController.getWasCloudLoaded() ? SettingController.getThemeColor() : SettingController.getDisasbledColor(),
              onPressed: SettingController.getWasCloudLoaded() ? () => loadCloudToLocal(context) : null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.save_alt_rounded, color: SettingController.getWasCloudLoaded() ? SettingController.getIconColor() : SettingController.getDisasbledIconColor()),
                  Text(
                    "Load to local",
                    style: TextStyle(
                      color: SettingController.getWasCloudLoaded() ? SettingController.getIconColor() : SettingController.getDisasbledIconColor(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      )
    );
  }

  Future<void> loadCloudToLocal(context) async {
    if (await CustomDialog.confirmDialog(context, "Load to local", message: "This will overwrite existing local data.\nAre you sure?")) {
      if (await ConnectivityController.hasInternetConnection()) {
        await JsonController.loadCloudToLocal();
        ScaffoldMessenger.of(context).showSnackBar(SnackBarController.loadedCloudToLocal());
      }
      else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBarController.noInternetConnection());
      }
    }
  }
}
