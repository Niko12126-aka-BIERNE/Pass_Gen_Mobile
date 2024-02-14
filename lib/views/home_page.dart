import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pass_gen_mobile/controllers/connectivity_controller.dart';
import 'package:pass_gen_mobile/controllers/snack_bar_controller.dart';
import 'package:pass_gen_mobile/models/account.dart';
import 'package:pass_gen_mobile/models/custom_dialog.dart';
import 'package:pass_gen_mobile/controllers/json_controller.dart';
import 'package:pass_gen_mobile/controllers/password_generator_controller.dart';
import 'package:pass_gen_mobile/controllers/setting_controller.dart';
import 'package:pass_gen_mobile/views/account_page.dart';
import 'package:pass_gen_mobile/views/app_scaffold.dart';
import 'package:pass_gen_mobile/views/setting_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  bool hidePassword = true;
  TextEditingController masterKeyTEC = TextEditingController();
  TextEditingController generatePasswordTEC = TextEditingController();
  TextEditingController accountDropdownTEC = TextEditingController();
  List<Account> accounts = [];
  Account? selectedAccount;

  @override
  void initState() {
    super.initState();
    accounts = JsonController.getAccounts();
    selectedAccount = accounts.isEmpty ? null : accounts.first;
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
      body: homePageBody()
    );
  }

  Widget homePageBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: SettingController.getLeftPadding(),
              right: SettingController.getRightPadding(),
              top: SettingController.getTopPadding(),
            ),
            child: Row(
              children: [
                Expanded(
                  child: DropdownMenu( 
                    expandedInsets: EdgeInsets.zero,
                    initialSelection: selectedAccount,
                    requestFocusOnTap: false,
                    label: const Text("Accounts"),
                    controller: accountDropdownTEC,
                    onSelected: (selectedAccount) => {
                      this.selectedAccount = selectedAccount
                    },
                    dropdownMenuEntries: accounts.map<DropdownMenuEntry<Account>>((Account account) {
                      return DropdownMenuEntry(value: account, label: account.name);
                    }).toList(),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: SettingController.getLeftPadding()),
                  child: Material(
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                    color: SettingController.getThemeColor(),
                    elevation: 5,
                    child: PopupMenuButton<String>(
                      iconSize: 40,
                      elevation: 10,
                      color: SettingController.getThemeColor(),
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                        PopupMenuItem(
                          onTap: () => editClicked(context, selectedAccount),
                          child: const Row(
                            children: [
                              Icon(Icons.edit),
                              Text("Edit account"),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          onTap: () => deleteClicked(context),
                          child: const Row(
                            children: [
                              Icon(Icons.delete),
                              Text("Delete account"),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          onTap: () {
                            createClicked(context);
                          },
                          child: const Row(
                            children: [
                              Icon(Icons.add),
                              Text("Create new"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: SettingController.getLeftPadding(),
              right: SettingController.getRightPadding(),
              top: SettingController.getTopPadding(),
            ),
            child: TextFormField(
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Master key',
              ),
              controller: masterKeyTEC,
            )
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                  left: SettingController.getLeftPadding(),
                  right: SettingController.getRightPadding(),
                  top: SettingController.getTopPadding(),
                  ),
                  child: FloatingActionButton(
                    heroTag: "getPasswordBTN",
                    onPressed: () => generatePassword(),
                    backgroundColor: SettingController.getThemeColor(),
                    child: Text(
                      "Get password",
                      style: TextStyle(
                        color: SettingController.getIconColor(),
                      ),  
                    ),
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
              left: SettingController.getLeftPadding(),
              right: SettingController.getRightPadding(),
              top: SettingController.getTopPadding(),
              bottom: SettingController.getBotPadding(),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    obscureText: hidePassword,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Generated password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          hidePassword ? Icons.visibility : Icons.visibility_off,
                          color: SettingController.getIconColor(),
                        ),
                        onPressed: () {
                          setState(() {
                            hidePassword = !hidePassword;
                          });
                        },
                      ),
                    ),
                    readOnly: true,
                    controller: generatePasswordTEC,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: SettingController.getLeftPadding()),
                  child: FloatingActionButton(
                    heroTag: "copyPasswordBTN",
                    onPressed: () => copyPassword(),
                    backgroundColor: SettingController.getThemeColor(),
                    child: Icon(
                      Icons.copy,
                      color: SettingController.getIconColor(),
                    ),
                  ),
                ),
              ],
            )
          ),
        ]
      )
    );
  }

  void createClicked(context) async {
    if (!SettingController.getUseCloud() || SettingController.getWasCloudLoaded()) {
      Account account = await Navigator.push(context, MaterialPageRoute(builder: (context) => const AccountPage(account: null)));
      setState(() {
        accounts.add(account);
        selectedAccount = account;
      });

      if (SettingController.getUseCloud()) {
        if (await ConnectivityController.hasInternetConnection()) {
            JsonController.updateAccountsInCloud(accounts);
            ScaffoldMessenger.of(context).showSnackBar(SnackBarController.accountCreated());
          }
          else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBarController.noInternetConnection());
          }
      }
      else {
        JsonController.updateAccountsInLocal(accounts);
        ScaffoldMessenger.of(context).showSnackBar(SnackBarController.accountCreated());
      }
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBarController.cloudNotLoaded());
    }
  }

  void deleteClicked(context) async {
    if (selectedAccount != null) {
      if (await CustomDialog.confirmDialog(context, 'Delete account')) {
        setState((){
          accounts.remove(selectedAccount);
          if (accounts.isEmpty) {
            accountDropdownTEC.clear();
            selectedAccount = null;
          }
          else {
            selectedAccount = accounts.first;
            accountDropdownTEC.text = accounts.first.name;
          }
        });

        if (SettingController.getUseCloud()) {
          if (await ConnectivityController.hasInternetConnection()) {
            JsonController.updateAccountsInCloud(accounts);
            ScaffoldMessenger.of(context).showSnackBar(SnackBarController.accountDeleted());
          }
          else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBarController.noInternetConnection());
          }
        }
        else {
          JsonController.updateAccountsInLocal(accounts);
          ScaffoldMessenger.of(context).showSnackBar(SnackBarController.accountDeleted());
        }
      }
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBarController.noAccountSelected());
    }
  }

  void editClicked(context, Account? account) async {
    if (account != null) {
      Account? editedAccount = await Navigator.push(context, MaterialPageRoute(builder: (context) => AccountPage(account: account)));
      if (editedAccount != null) {
        setState(() {
          account = editedAccount;
          selectedAccount = editedAccount;
          accountDropdownTEC.text = editedAccount.name;
        });

        if (SettingController.getUseCloud()) {
          if (await ConnectivityController.hasInternetConnection()) {
            JsonController.updateAccountsInCloud(accounts);
            ScaffoldMessenger.of(context).showSnackBar(SnackBarController.accountEdited());
          }
          else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBarController.noInternetConnection());
          }
        }
        else {
          JsonController.updateAccountsInLocal(accounts);
          ScaffoldMessenger.of(context).showSnackBar(SnackBarController.accountEdited());
        }
      }
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBarController.noAccountSelected());
    }
  }

  void generatePassword() {
    if (selectedAccount != null) {
      setState(() {
        generatePasswordTEC.text = PasswordGeneratorController.generatePassword(selectedAccount!.id, masterKeyTEC.text, selectedAccount!.passwordIndex, selectedAccount!.passwordLength);
      });
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBarController.noAccountSelected());
    }
  }

  void copyPassword() {
    String generatePassword = generatePasswordTEC.text;
    Clipboard.setData(ClipboardData(text: generatePassword));
  }
}
