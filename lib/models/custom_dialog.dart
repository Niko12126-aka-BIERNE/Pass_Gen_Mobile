import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:pass_gen_mobile/controllers/setting_controller.dart';

class CustomDialog {
  static Future<bool> confirmDialog(context, String title, {String message = "Are you sure?"}) async {
    return !await confirm(
      context,
      title: Text(title),
      content: Text(message),
      textOK: Material(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
        color: SettingController.getCancelColor(),
        elevation: 5,
        child: const Padding(
          padding: EdgeInsets.all(10),
          child: Text('No', style: TextStyle(fontWeight: FontWeight.bold),),
        )
      ),
      textCancel: Material(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
        color: SettingController.getThemeColor(),
        elevation: 5,
        child: const Padding(
          padding: EdgeInsets.all(10),
          child: Text('Yes', style: TextStyle(fontWeight: FontWeight.bold),),
        )
      ),
    );
  }
}
