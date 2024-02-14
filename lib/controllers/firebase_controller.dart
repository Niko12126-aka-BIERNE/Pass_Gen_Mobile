import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';

class FireBaseController {
  static Future<String> getCloudData() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference storageRef = storage.ref("AccMem.json");
    Uint8List? data = await storageRef.getData();

    String res = "{}";
    if (data != null) {
      res = String.fromCharCodes(data);
    }

    return res;
  }

  static Future<void> updateCloudData(String jData) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference storageRef = storage.ref("AccMem.json");

    List<int> codeUnits = jData.codeUnits;
    await storageRef.putData(Uint8List.fromList(codeUnits));
  }
}
