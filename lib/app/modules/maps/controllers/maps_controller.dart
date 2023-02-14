import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  late Completer<GoogleMapController> mapController;
  Stream<DocumentSnapshot<Object?>> getAllData(String docID) {
    var get = firestore.collection("boardings").doc(docID).snapshots();
    return get;
  }
  Future<QuerySnapshot<Object?>> getAllCampus() {
    var get = firestore.collection("campus");
    return get.get();
  }

  @override
  void onInit() {
    mapController = Completer();
    super.onInit();
  }
}
