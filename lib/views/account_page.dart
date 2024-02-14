import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pass_gen_mobile/controllers/snack_bar_controller.dart';
import 'package:pass_gen_mobile/models/account.dart';
import 'package:pass_gen_mobile/models/custom_dialog.dart';
import 'package:pass_gen_mobile/controllers/setting_controller.dart';
import 'package:pass_gen_mobile/views/app_scaffold.dart';
import 'package:pass_gen_mobile/views/setting_page.dart';

class AccountPage extends StatefulWidget {
  final Account? account;
  const AccountPage({Key? key, this.account}) : super(key: key);

  @override
  State<StatefulWidget> createState() => AccountPageState(account: account);
}

class AccountPageState extends State<AccountPage> {
  Account? account;
  bool? changeLengthEnabled;
  String? modeText;
  bool? changePasswordEnabled;
  TextEditingController accountNameTEC = TextEditingController();
  TextEditingController passwordLengthTEC = TextEditingController();

  AccountPageState({this.account}){    
    if (account != null) {
      accountNameTEC.text = account!.name;
      passwordLengthTEC.text = account!.passwordLength.toString();
      changeLengthEnabled = false;
      modeText = "Edit account";
      changePasswordEnabled = true;
    }
    else {
      changeLengthEnabled = true;
      passwordLengthTEC.text = "10";
      modeText = "Create account";
      changePasswordEnabled = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "PassGen Mobile",
      actions: [
        IconButton(
          icon: Icon(
            Icons.settings, 
            size: 35, 
            color: SettingController.getIconColor(),
          ),
          onPressed: () async {
            await Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingPage()));
            setState((){});
          },
        )
      ],
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: SettingController.getLeftPadding(),
                    right: SettingController.getRightPadding(),
                    top: SettingController.getTopPadding(),
                  ),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter account name',
                    ),
                    controller: accountNameTEC,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: SettingController.getLeftPadding(),
                    right: SettingController.getRightPadding(),
                    top: SettingController.getTopPadding(),
                  ),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter password lenght',
                    ),
                    controller: passwordLengthTEC,
                    enabled: changeLengthEnabled,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: SettingController.getLeftPadding(),
                    right: SettingController.getRightPadding(),
                    top: SettingController.getTopPadding(),
                    bottom: 100,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: FloatingActionButton(
                          heroTag: "createBTN",
                          onPressed: () => confirmClicked(),
                          backgroundColor: SettingController.getThemeColor(),
                          child: Text(
                            modeText!,
                            style: TextStyle(
                              color: SettingController.getIconColor(),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: SettingController.getLeftPadding()),
                        child: SizedBox(
                          width: 70,
                          child: FloatingActionButton(
                            heroTag: "cancelBTN",
                            onPressed: () => cancelClicked(context),
                            backgroundColor: SettingController.getCancelColor(),
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                color: SettingController.getIconColor(),
                              ),
                            ),
                          )
                        ),
                      )
                    ],
                  ),
                ),
              ],
            )
          ),
          Padding(
            padding: EdgeInsets.only(
              right: SettingController.getRightPadding(),
              bottom: SettingController.getBotPadding(),
            ),
            child: Align(
              alignment: Alignment.bottomRight,
              child: SizedBox(
                width: 150,
                child: FloatingActionButton(
                  heroTag: "changePasswordBTN",
                  onPressed: changePasswordEnabled! ? () => changePasswordClicked(context) : null,
                  backgroundColor: changePasswordEnabled! ? SettingController.getThemeColor() : SettingController.getDisasbledColor(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.refresh, color: changePasswordEnabled! ? SettingController.getIconColor() : SettingController.getDisasbledIconColor()),
                      Text(
                        "Change password",
                        style: TextStyle(
                          color: changePasswordEnabled! ? SettingController.getIconColor() : SettingController.getDisasbledIconColor(),
                        ),
                      ),
                    ],
                  )
                ),
              )
            )
          )
        ],
      )
    );
  }

  void confirmClicked() {
    if (account != null) {
      editClicked();
    }
    else {
      createClicked();
    }
  }

  void createClicked(){
    if (accountNameTEC.text.isNotEmpty && passwordLengthTEC.text.isNotEmpty && int.parse(passwordLengthTEC.text) > 0) {
      String accountName = accountNameTEC.text;
      int passwordLength = int.parse(passwordLengthTEC.text);

      Account account = Account(accountName, accountName, 0, passwordLength);

      Navigator.pop(context, account);
    }
  }

  void editClicked() {
    account!.name = accountNameTEC.text;
    Navigator.pop(context, account);
  }

  void cancelClicked(context){
    Navigator.pop(context, null);
  }

  Future<void> changePasswordClicked(context) async {
    if (await CustomDialog.confirmDialog(context, 'Change password')) {
      account!.passwordIndex = account!.passwordIndex + 1;
      Navigator.pop(context, account);
      ScaffoldMessenger.of(context).showSnackBar(SnackBarController.passwordChanged());
    }
  }
}
