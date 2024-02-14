import 'package:pass_gen_mobile/models/password_generator.dart';

class PasswordGeneratorController {
  static String generatePassword(String accountID, String masterKey, int passwordIndex, int passLength) {
    return PasswordGenerator.generatePassword(accountID, masterKey, passwordIndex, passLength);
  }
}
