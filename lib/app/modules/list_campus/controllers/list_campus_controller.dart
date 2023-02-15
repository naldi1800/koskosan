import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ListCampusController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Stream<QuerySnapshot<Object?>> getAllData() {
    var get = firestore.collection("campus");
    return get.snapshots();
  }
}
