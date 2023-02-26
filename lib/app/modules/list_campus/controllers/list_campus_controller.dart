import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

class ListCampusController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  Map<String, String> images = {};
  var imageCheck = false.obs;

  Future<QuerySnapshot<Object?>> getAllData() {
    var get = firestore.collection("campus");
    return get.get();
  }

  void getDataImage(String docID) async {
    var ref = storage.ref().child("campus").child(docID).child("1.jpg");
    bool get = await ref
        .getDownloadURL()
        .then(
          (value) => true,
        )
        .catchError(
          (tes) => false,
        );

    if (get) {
      imageCheck.value = false;
      images[docID] = await ref.getDownloadURL();
      imageCheck.value = true;
      // print("CEK $docID: ${images.containsKey(docID)}");
    }
  }
}
