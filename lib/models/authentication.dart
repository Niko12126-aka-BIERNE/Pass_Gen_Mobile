import 'package:local_auth/local_auth.dart';

class Authentication {
  static Future<bool> authenticateWithBiometrics() async {
   final LocalAuthentication localAuthentication = LocalAuthentication();
   bool isBiometricSupported = await localAuthentication.isDeviceSupported();
   bool canCheckBiometrics = await localAuthentication.canCheckBiometrics;

   bool isAuthenticated = false;

   if (isBiometricSupported && canCheckBiometrics) {
     isAuthenticated = await localAuthentication.authenticate(
       localizedReason: 'Authenticate access to PassGen Mobile.',
       options: const AuthenticationOptions(
        stickyAuth: true,
       ),
     );
   }

   return isAuthenticated;
 }
}
