import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class GalleryItemController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  List<Rx<Uint8List>> galery = [];
  var galeryLenght = 0.obs;
  void getDataImage(String docID) async {
    var ref = storage.ref().child("galery").child(docID);

    var getAll = await ref.listAll();
    galery.clear();
    getAll.items.forEach((e) async {
      var dt = await e.getData();
      galery.add(dt!.obs);
      galeryLenght.value = galery.length;
    });
  }
}
