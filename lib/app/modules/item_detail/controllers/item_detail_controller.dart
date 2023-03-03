import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:koskosan/app/Utils/Func.dart';

class ItemDetailController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;

  late Completer<GoogleMapController> mapController;
  var spec = 0.obs;
  final imageMain = Rx<Uint8List>(Uint8List(0));
  final galeryLenght = 0.obs;

  List<Rx<Map<String, dynamic>>> nearest = [];
  var nearestLength = 0.obs;

  List<Rx<Uint8List>> galery = [];
  var box = GetStorage('USER_SETTINGS');
  var favorite = false.obs;

  Future<DocumentSnapshot<Map<String, dynamic>>> getDataWithID(String docID) {
    var get = firestore.collection("boardings").doc(docID);
    return get.get();
  }

  void getDataImage(String docID) async {
    var ref = storage.ref().child("galery").child(docID);

    var getAll = await ref.listAll();
    galery.clear();
    getAll.items.forEach(
      (e) async {
        var dt = await e.getData();
        galery.add(dt!.obs);
        // print("Galeri Add");
        galeryLenght.value = galery.length;
      },
    );

    var imageFileMain = await ref.child("1.jpg").getData(10000000);
    imageMain.value = imageFileMain!;
  }

  void setFeature(int x) {
    spec.value = x;
  }

  void setFavorite(context, String key) async {
    var x = box.read(key);
    await box.write(key, !x);
    favorite.value = box.read(key);
    // var msg = (favorite.value) ? "Adding to favorite" : "Removing to favorite";
  }

  void toast(context, {required String msg, int seconds = 2}) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(
          msg,
          textAlign: TextAlign.center,
        ),
        duration: Duration(seconds: seconds),
        // action: SnackBarAction(label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  void getCampusDistance(LatLng location) async {
    nearest = [];
    nearestLength.value = 0;

    await firestore.collection("campus").get().then(
          (v) => v.docs.forEach(
            (e) {
              var d = e.data();
              GeoPoint geo = d['location'];
              LatLng locCampus = LatLng(geo.latitude, geo.longitude);
              var dis = FUNC.getDistanceOfLine(location, locCampus);
              dis *= 100;
              dis = double.parse(dis.toStringAsFixed(2));
              var va = dis < 1 ? "${(dis * 1000).toInt()} m" : "$dis km";
              // print(va);
              if (dis <= 3) {
                nearest.add(
                  Rx<Map<String, dynamic>>(
                    {
                      "title": d['abbreviation'],
                      "value": va,
                      "distance": dis,
                    },
                  ),
                );
              }
            },
          ),
        );
    nearest.sort((a, b) => a.value["distance"].compareTo(b.value["distance"]));
    nearestLength.value = nearest.length;
    // print("data cek : ${nearest}");
  }

  @override
  void onInit() async {
    mapController = Completer();
    if (box.read('vzu14XPbovaxnQTkETA3') == null) {
      await box.write('vzu14XPbovaxnQTkETA3', false);
    }
    favorite.value = box.read('vzu14XPbovaxnQTkETA3');
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
