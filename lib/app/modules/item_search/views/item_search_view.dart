import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:koskosan/app/Utils/Menu.dart';
import 'package:koskosan/app/Utils/UI.dart';

import '../controllers/item_search_controller.dart';

class ItemSearchView extends GetView<ItemSearchController> {
  const ItemSearchView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: UI.background,
      body: SafeArea(
        child: Stack(
          children: [
            StreamBuilder(
              stream: controller.getAllData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  // print(snapshot.data!.docs);
                  var getData = snapshot.data!.docs;

                  controller.setMarkerKos(getData);
                  controller.setMarkerKampus();
                  var undipa = const LatLng(-5.1404505, 119.4898208);

                  return Obx(
                    () => GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: undipa,
                        zoom: 13.0,
                      ),
                      markers: (controller.markerLength.value > 0)
                          ? Set.from(controller.marker)
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
            Menu.menu(height, 1),
          ],
        ),
      ),
    );
  }
}
