import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:koskosan/app/Utils/UI.dart';

class AdminKosController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> getData() {
    var get = firestore.collection("boardings");
    return get.snapshots();
  }

  void delete(String docID) async {
    var get = firestore.collection("boardings").doc(docID);
    var img = storage.ref().child("galery").child(docID);
    ListResult res = await img.listAll();

    for (var r in res.items) {
      // print(r);
      await r.delete();
    }
    try {
      await img.delete();
    } catch (e) {
      print("ERROR : $e");
    }

    Get.back();
    await get.delete();
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
