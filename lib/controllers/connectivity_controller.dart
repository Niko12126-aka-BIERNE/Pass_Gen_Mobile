import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityController {
  static Future<bool> hasInternetConnection() async {
    ConnectivityResult connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi || connectivityResult == ConnectivityResult.ethernet) {
      return true;
    }
    return false;
  }
}
