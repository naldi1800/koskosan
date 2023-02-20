import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:koskosan/app/Utils/UI.dart';

class AdminCampusController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> getData() {
    var get = firestore.collection("campus");
    return get.snapshots();
  }

  void delete(String docID) async {
    var get = firestore.collection("campus").doc(docID);
    print("tes");
    Get.back();
    var x = await get.delete();
    Get.defaultDialog(
      title: "Info",
      middleText: "Delete success",
      titleStyle: TextStyle(color: UI.object),
      middleTextStyle: TextStyle(color: UI.object),
      backgroundColor: UI.foreground,
      textConfirm: "Oke",
      onConfirm: () => Get.back(),
    );
  }
}
