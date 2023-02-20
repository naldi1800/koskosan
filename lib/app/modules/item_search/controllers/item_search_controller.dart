import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:koskosan/app/routes/app_pages.dart';

class ItemSearchController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  late GetStorage box;

  List<Marker> marker = [];
  var markerLength = 0.obs;
  late Completer<GoogleMapController> mapController;
  Stream<QuerySnapshot<Object?>> getAllData() {
    var get = firestore.collection("boardings");
    return get.snapshots();
  }

  void setMarkerKos(List<QueryDocumentSnapshot<Object?>> getData) {
    marker = [];
    getData.forEach((e) {
      var data = e.data() as Map<String, dynamic>;
      GeoPoint geo = data['position'];
      LatLng location = LatLng(geo.latitude, geo.longitude);
      var mar = Marker(
        markerId: MarkerId(e.id),
        position: location,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(
          title: data['name'].toString(),
          onTap: () => Get.offNamed(
            Routes.ITEM_DETAIL,
            arguments: e.id,
          ),
        ),
      );
      marker.add(mar);
      markerLength.value = marker.length;
    });
  }

  void setMarkerKampus() {
    var get = firestore.collection("campus").get();
    get.then(
      (v) => v.docs.forEach(
        (e) {
          var data = e.data();
          GeoPoint geo = data['location'];
          LatLng location = LatLng(geo.latitude, geo.longitude);
          var mar = Marker(
            markerId: MarkerId(e.id),
            position: location,
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueAzure),
            infoWindow: InfoWindow(
              title: data['name'].toString(),
              onTap: () => Get.offNamed(
                Routes.ITEM_DETAIL,
                arguments: e.id,
              ),
            ),
          );
          marker.add(mar);
          markerLength.value = marker.length;
        },
      ),
    );
  }

  @override
  void onInit() {
    super.onInit();
    box = GetStorage("USER_SETTINGS");
    mapController = Completer();
  }
}
