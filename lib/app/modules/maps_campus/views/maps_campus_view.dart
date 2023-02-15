import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:koskosan/app/Utils/UI.dart';
import 'package:koskosan/app/routes/app_pages.dart';

import '../controllers/maps_campus_controller.dart';

class MapsCampusView extends GetView<MapsCampusController> {
  const MapsCampusView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UI.foreground,
      body: StreamBuilder(
        stream: controller.getCampus(Get.arguments),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            var getData = snapshot.data;
            var data = getData!.data() as Map<String, dynamic>;
            GeoPoint geo = data['location'];
            LatLng location = LatLng(geo.latitude, geo.longitude);

            controller.getAllKos(getData.id, location, data['name']);
            return Obx(
              () => GoogleMap(

                initialCameraPosition: CameraPosition(
                  target: (controller.markerLength.value > 0)
                      ? controller.marker.value[0].position
                      : location,
                  zoom: 14.0,
                ),
                circles: Set<Circle>.from({controller.circle.value}),
                // polylines: (polylineLength.value > 0) ? Set.from(polyline) : {},
                markers: (controller.markerLength.value > 0)
                    ? Set.from(controller.marker.value)
                    : {},
                onMapCreated: (GoogleMapController controllerMap) {
                  controller.mapController.complete(controllerMap);
                },
                myLocationEnabled: true,
                zoomControlsEnabled: false,
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
