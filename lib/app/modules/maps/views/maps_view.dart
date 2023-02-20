import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:koskosan/app/Utils/Func.dart';
import 'package:koskosan/app/Utils/UI.dart';
import 'package:koskosan/app/routes/app_pages.dart';

import '../controllers/maps_controller.dart';

class MapsView extends GetView<MapsController> {
  const MapsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UI.background,
      body: Stack(
        children: [
          StreamBuilder(
            stream: controller.getAllData(Get.arguments),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                // var undipa = const LatLng(-5.1404505, 119.4898208);
                List<Marker> marker = [];
                var markerLength = 0.obs;
                var getData = snapshot.data;
                var data = getData!.data() as Map<String, dynamic>;
                GeoPoint geo = data['position'];
                LatLng location = LatLng(geo.latitude, geo.longitude);
                var mar = Marker(
                  markerId: MarkerId(getData.id),
                  position: location,
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueAzure),
                  infoWindow: InfoWindow(
                    title: data['name'].toString(),
                    onTap: () => Get.offNamed(
                      Routes.ITEM_DETAIL,
                      arguments: getData.id,
                    ),
                  ),
                );
                marker.add(mar);

                // });

                return FutureBuilder(
                  future: controller.getAllCampus(),
                  builder: (context, snapF) {
                    if (snapF.connectionState == ConnectionState.done) {
                      var getData = snapF.data!.docs;
                      List<Polyline> polyline = [];
                      Map<String, double> distance = {};
                      var polylineLength = 0.obs;
                      getData.forEach(
                        (e) {
                          var datas = e.data() as Map<String, dynamic>;
                          GeoPoint geo = datas['location'];
                          LatLng locCampus =
                              LatLng(geo.latitude, geo.longitude);
                          var d = FUNC.getDistanceOfLine(
                              marker[0].position, locCampus);
                          d = d * 100;
                          d = double.parse(
                            d.toStringAsFixed(2),
                          );
                          distance[datas['name'].toString()] = d;
                          var dis = d < 1 ? "${(d * 1000).toInt()} m" : "$d km";

                          var ma = Marker(
                            markerId: MarkerId(e.id),
                            position: locCampus,
                            icon: BitmapDescriptor.defaultMarker,
                            infoWindow: InfoWindow(
                              title: datas['name'].toString(),
                              snippet: "Jarak: $dis",
                            ),
                          );

                          var p = Polyline(
                            polylineId: PolylineId(e.id),
                            visible: true,
                            // points: FUNC.bresenhamLine(
                            //   marker[0].position,
                            //   locCampus,
                            // ),
                            points: [
                              marker[0].position,
                              locCampus,
                            ],
                            width: 1,
                            startCap: Cap.roundCap,
                            endCap: Cap.buttCap,
                            geodesic: true,
                            onTap: () => print("Cekking ${datas['name']}"),
                            // options: PolylineOptions(
                            //   title: "My Polyline",
                            // ),
                          );

                          marker.add(ma);
                          markerLength.value = marker.length;
                          polyline.add(p);
                          polylineLength.value = polyline.length;
                        },
                      );
                      // var data = getData[0].data() as Map<String, dynamic>;
                      return Obx(
                        () => GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: (markerLength.value > 0)
                                ? marker[0].position
                                : location,
                            zoom: 18.0,
                          ),
                          polylines: (polylineLength.value > 0)
                              ? Set.from(polyline)
                              : {},
                          markers:
                              (markerLength.value > 0) ? Set.from(marker) : {},
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
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
          // Padding(
          //   padding: const EdgeInsets.all(20),
          //   child: Align(
          //     alignment: Alignment.bottomCenter,
          //     child: Container(
          //       width: double.infinity,
          //       height: 50,
          //       decoration: BoxDecoration(
          //         borderRadius: const BorderRadius.all(
          //           Radius.circular(25),
          //         ),
          //         border: Border.all(color: UI.action),
          //         color: UI.background,
          //       ),
          //       child: ,
          //     ),
          //   ),
          // ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ButtonStyle(
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: const BorderSide(
                          color: UI.action,
                          width: 2.0,
                        )),
                  ),
                  backgroundColor: const MaterialStatePropertyAll(
                    UI.background,
                  ),
                ),
                child: Container(
                  height: 53,
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.arrow_back,
                        color: UI.action,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        "Back",
                        style: TextStyle(
                          fontSize: 20,
                          color: UI.action,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        
        ],
      ),
    );
  }

}
