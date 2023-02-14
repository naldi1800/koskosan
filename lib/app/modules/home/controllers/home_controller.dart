import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:koskosan/app/Utils/Func.dart';

class HomeController extends GetxController {
  late GetStorage box;
  late TextEditingController search;
  Map<String, Rx<Uint8List>> imageMain = {};
  Map<String, Rx<bool>> favorite = {};
  Map<String, Rx<String>> dist = {};
  Map<String, Rx<String>> distNameOfCampus = {};
  var favoriteLength = 0.obs;
  var imageLength = 0.obs;
  var distLength = 0.obs;
  var distNameOfCampusLength = 0.obs;
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
    imageLength.value = 0;
    var ref = storage.ref().child("galery").child(docID);
    var imageFileMain = await ref.child("1.jpg").getData(10000000);
    imageMain[docID] = Rx<Uint8List>(imageFileMain!);
    imageLength.value = imageMain.length;
  }

  void likeSet(String key) async {
    favoriteLength.value = 0;
    var x = box.read(key);
    await box.write(key, !x);
    favorite[key] = Rx<bool>(box.read(key));
    favoriteLength.value = favorite.length;
    print("Tes $x");
  }

  void getLike(String key) async {
    favoriteLength.value = 0;
    var x = box.read(key);
    favorite[key] = Rx<bool>(x);
    favoriteLength.value = favorite.length;
  }

  void getDistance(String docID, LatLng pos) async {
    distLength.value = 0;
    distNameOfCampusLength.value = 0;

    // var d = 0.0;
    var d = await firestore.collection("campus").get().then((v) {
      double? min;
      var name;
      var dst;
      v.docs.forEach((e) {
        Map<String, dynamic> data = e.data() as Map<String, dynamic>;
        GeoPoint geo = data['location'];
        LatLng posCampus = LatLng(geo.latitude, geo.longitude);
        var x = FUNC.getDistanceOfLine(pos, posCampus);
        x = x * 100;
        x = double.parse(x.toStringAsFixed(2));
        print("data : $x");
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

        // print(data);
      });
      return [
        dst,
        name,
      ];
    });
    dist[docID] = Rx<String>(d[0]);
    distNameOfCampus[docID] = Rx<String>(d[1]);
    distLength.value = dist.length;
    distNameOfCampusLength.value = distNameOfCampus.length;

    // print(d);
  }
}
