import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:koskosan/app/Utils/Func.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomeController extends GetxController {
  late GetStorage box;
  late TextEditingController search;
  var panelController = PanelController();


  var locText = "Makassar".obs;
  var locTextInitial = 2.obs;

  Rx<List<Widget>> itemsCampus = Rx<List<Widget>>([]);

  Map<String, String> images = {};
  Map<String, bool> favorite = {};
  Map<String, String> dist = {};
  Map<String, String> distNameOfCampus = {};
  var imageCheck = false.obs;
  var distCheck = false.obs;
  var favoriteCheck = false.obs;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;

  @override
  void onInit() {
    super.onInit();
    search = TextEditingController();
    box = GetStorage("USER_SETTINGS");
  }

  @override
  void onClose() {
    super.onClose();
    search.dispose();
  }

  Stream<QuerySnapshot<Object?>> getAllData() {
    var get = firestore.collection("boardings");
    return get.snapshots();
  }

  void getDataImage(String docID) async {
    var ref = storage.ref().child("galery").child(docID).child("1.jpg");
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
    }
  }

  void likeSet(String key) async {
    favoriteCheck.value = false;
    var x = box.read(key) ?? false;
    await box.write(key, !x);
    favorite[key] = box.read(key);
    favoriteCheck.value = true;
  }

  void getLike(String key) async {
    favoriteCheck.value = false;
    var x = box.read(key) ?? false;
    favorite[key] = x;
    favoriteCheck.value = true;
  }

  void getDistance(String docID, LatLng pos) async {
    distCheck.value = false;

    // var d = 0.0;
    var d = await firestore.collection("campus").get().then((v) {
      double? min;
      var name = "";
      var dst = "";
      v.docs.forEach((e) {
        Map<String, dynamic> data = e.data() as Map<String, dynamic>;
        GeoPoint geo = data['location'];
        LatLng posCampus = LatLng(geo.latitude, geo.longitude);
        var x = FUNC.getDistanceOfLine(pos, posCampus);
        x = x * 100;
        x = double.parse(x.toStringAsFixed(2));
        var dis = (x < 1) ? "${(x * 1000).toInt()} m" : "$x km";

        if (min == null) {
          min = x;
          name = data['abbreviation'];
          dst = dis;
        }

        if (min! > x) {
          min = x;
          name = data['abbreviation'];
          dst = dis;
        }
      });
      return [
        dst,
        name,
      ];
    });
    dist[docID] = d[0];
    distNameOfCampus[docID] = d[1];
    distCheck.value = true;

  }
}
