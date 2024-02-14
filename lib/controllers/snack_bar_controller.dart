import 'package:flutter/material.dart';
//import 'package:restart_app/restart_app.dart';

class SnackBarController {
  static SnackBar cloudNotLoaded() {
    return const SnackBar(
      backgroundColor: Color.fromARGB(255, 157, 10, 0),
      content: Text("ERROR: Not able to load cloud accounts"),
    );
  }

  static SnackBar noAccountSelected() {
    return const SnackBar(
      backgroundColor: Color.fromARGB(255, 157, 10, 0),
      content: Text("ERROR: No account selected"),
    );
  }

  /*
  static SnackBar restartApp() {
    return SnackBar(
      backgroundColor: const Color.fromARGB(255, 255, 212, 20),
      content: const Text(
        "INFO: Restart app for this to take effect",
        style: TextStyle(color: Colors.black),
      ),
      action: SnackBarAction(
        textColor: const Color.fromARGB(255, 0, 61, 111),
        label: 'Restart',
        onPressed: () {
          Restart.restartApp();
        }
      ),
    );
  }
  */

  static SnackBar passwordChanged() {
    return const SnackBar(
      backgroundColor: Color.fromARGB(255, 9, 185, 0),
      content: Text("SUCCESS: Password changed"),
    );
  }

  static SnackBar loadedCloudToLocal() {
    return const SnackBar(
      backgroundColor: Color.fromARGB(255, 9, 185, 0),
      content: Text("SUCCESS: Loaded cloud to local"),
    );
  }

  static SnackBar accountDeleted() {
    return const SnackBar(
      backgroundColor: Color.fromARGB(255, 9, 185, 0),
      content: Text("SUCCESS: Account deleted"),
    );
  }

  static SnackBar accountEdited() {
    return const SnackBar(
      backgroundColor: Color.fromARGB(255, 9, 185, 0),
      content: Text("SUCCESS: Account edited"),
    );
  }

  static SnackBar accountCreated() {
    return const SnackBar(
      backgroundColor: Color.fromARGB(255, 9, 185, 0),
      content: Text("SUCCESS: Account created"),
    );
  }

  static SnackBar noInternetConnection() {
    return const SnackBar(
      backgroundColor: Color.fromARGB(255, 157, 10, 0),
      content: Text("ERROR: No internet connection"),
    );
  }
}
