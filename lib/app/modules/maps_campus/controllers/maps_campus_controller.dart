import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:koskosan/app/Utils/Func.dart';
import 'package:koskosan/app/Utils/UI.dart';
import 'package:koskosan/app/routes/app_pages.dart';

class MapsCampusController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late Completer<GoogleMapController> mapController;

  Rx<List<Marker>> marker = Rx<List<Marker>>([]);
  var markerLength = 0.obs;

  Rx<Circle> circle = Rx<Circle>(
    const Circle(
      circleId: CircleId(""),
    ),
  );

  Stream<DocumentSnapshot<Object?>> getCampus(String docID) {
    var get = firestore.collection("campus").doc(docID).snapshots();
    return get;
  }

  void getAllKos(id, location, name) async {
    marker = Rx<List<Marker>>([]);
    circle = Rx<Circle>(
      Circle(
        circleId: CircleId(id),
        center: location,
        radius: 1500,
        fillColor: UI.foreground.withOpacity(0.1),
        strokeColor: UI.foreground,
        strokeWidth: 1,
      ),
    );

    // Marker
    var m = Marker(
      markerId: MarkerId(id),
      position: location,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
      infoWindow: InfoWindow(
        title: name,
      ),
    );
    marker.value.add(m);

    await firestore.collection("boardings").get().then(
          (v) => v.docs.forEach(
            (e) {
              var d = e.data();
              GeoPoint geo = d['position'];
              LatLng loc = LatLng(geo.latitude, geo.longitude);

              var dis = FUNC.getDistanceOfLine(location, loc);
              dis *= 100;
              dis = double.parse(dis.toStringAsFixed(2));

              var mar = Marker(
                markerId: MarkerId(e.id),
                position: loc,
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueRed),
                infoWindow: InfoWindow(
                  title: d['name'].toString(),
                  onTap: () => Get.offNamed(
                    Routes.ITEM_DETAIL,
                    arguments: e.id,
                    parameters: {
                      "in": "Maps",
                      "id": Get.arguments,
                    },
                  ),
                ),
              );
              if (dis < 1.5) {
                marker.value.add(mar);
              }
            },
          ),
        );
    markerLength.value = marker.value.length;
  }

  // Future<QuerySnapshot<Object?>> getAllCampus() {
  //   var get = firestore.collection("campus");
  //   return get.get();
  // }

  @override
  void onInit() {
    mapController = Completer();
    super.onInit();
  }
}
