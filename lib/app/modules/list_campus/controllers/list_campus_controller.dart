import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class ListCampusController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  var imageLength = 0.obs;
  Map<String, Rx<Uint8List>> imageMain = {};

  Stream<QuerySnapshot<Object?>> getAllData() {
    var get = firestore.collection("campus");
    return get.snapshots();
  }

  void getDataImage(String docID) async {
    imageLength = 0.obs;
    var ref = storage.ref().child("campus").child(docID);
    var imageFileMain = await ref.child("1.jpg").getData(10000000);
    imageMain[docID] = Rx<Uint8List>(imageFileMain!);
    imageLength.value = imageMain.length;
  }
}
