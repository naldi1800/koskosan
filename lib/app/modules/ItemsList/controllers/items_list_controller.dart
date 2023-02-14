import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ItemsListController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Stream<QuerySnapshot<Object?>> getAllData() {
    var get = firestore.collection("boardings");
    return get.snapshots();
  }
}
