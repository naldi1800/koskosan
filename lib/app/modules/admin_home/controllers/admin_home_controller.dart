import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

class AdminHomeController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  var campus = 0.obs;
  var kos = 0.obs;

  @override
  void onInit()  async{
    super.onInit();
    campus.value =  await firestore.collection("campus").get().then((value) => value.docs.length);
    kos.value =  await firestore.collection("boardings").get().then((value) => value.docs.length);
  }
}
