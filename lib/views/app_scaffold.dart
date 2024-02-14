import 'package:flutter/material.dart';
import 'package:pass_gen_mobile/controllers/setting_controller.dart';

class AppScaffold extends StatelessWidget {
  final String? title;
  final List<Widget>? actions;
  final Widget? body;
  const AppScaffold({Key? key, this.title, this.actions, this.body}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? ''),
        backgroundColor: SettingController.getThemeColor(),
        actions: actions,
      ),
      body: body,
    );
  }
}
