import 'dart:convert';
import 'dart:io';
import 'package:pass_gen_mobile/controllers/firebase_controller.dart';
import 'package:pass_gen_mobile/models/account.dart';
import 'package:pass_gen_mobile/controllers/setting_controller.dart';

class JsonController {
  static List<Account> accounts = [];

  static List<Account> getAccounts() {
    return accounts;
  }

  static Future<void> loadAccountsFromLocal() async {
    String accountFilePath = SettingController.getAccountLocalFilePath();
    File file = File(accountFilePath);

    if (await file.exists()) {
      String fileContent = await file.readAsString();
      
      setAccounts(fileContent);
    }
    else {
      file.writeAsString('{}');
    }
  }

  static Future<void> loadAccountsFromCloud() async {
    setAccounts(await FireBaseController.getCloudData());
  }

  static Future<void> setAccounts(String fileContent) async {
    List<Account> loadedAccounts = [];

    Map<dynamic, dynamic> jData = await json.decode(fileContent);
    for (var account in jData.keys) {
      String name = account;
      String id = jData[account]["id"];
      int passwordIndex = jData[account]["passIndex"];
      int passwordLength = jData[account]["passLength"];

      loadedAccounts.add(Account(name, id, passwordIndex, passwordLength));
    }

    accounts = loadedAccounts;
  }

  static Future<void> updateAccountsInLocal(List<Account> accounts) async {
    String accountFilePath = SettingController.getAccountLocalFilePath();
    File file = File(accountFilePath);
    file.writeAsString(accountsToJson(accounts));
  }

  static Future<void> updateAccountsInCloud(List<Account> accounts) async {
    FireBaseController.updateCloudData(accountsToJson(accounts));
    JsonController.accounts = accounts;
  }

  static String accountsToJson(List<Account> accounts) {
    String jsonString = "{";

    for (int i = 0; i < accounts.length; i++) {
      jsonString += accounts[i].toJsonObjectString();

      if (i < accounts.length - 1) {
        jsonString += ", ";
      }
    }
    jsonString += "}";

    return jsonString;
  }

  static Future<void> loadCloudToLocal() async {
    updateAccountsInLocal(accounts);
  }
}
