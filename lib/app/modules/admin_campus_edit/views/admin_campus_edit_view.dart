import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:koskosan/app/Utils/UI.dart';

import '../controllers/admin_campus_edit_controller.dart';

class AdminCampusEditView extends GetView<AdminCampusEditController> {
  const AdminCampusEditView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Kampus'),
        centerTitle: true,
        backgroundColor: UI.foreground,
      ),
      backgroundColor: UI.background,
      body: FutureBuilder(
          future: controller.getData(Get.arguments),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              var d = snapshot.data!.data() as Map<String, dynamic>;

              GeoPoint geo = d['location'];
              LatLng location = LatLng(geo.latitude, geo.longitude);

              controller.namaC.text = d['name'];
              controller.singkatanC.text = d['abbreviation'];
              controller.locC.text =
                  "${location.latitude} | ${location.longitude}";

              controller.marker.value = {
                Marker(
                  markerId: const MarkerId("pos"),
                  position: location,
                  icon: BitmapDescriptor.defaultMarker,
                  draggable: true,
                  onDrag: (value) => controller.locC.text =
                      "${value.latitude} | ${value.longitude}",
                  onDragEnd: (value) => controller.locC.text =
                      "${value.latitude} | ${value.longitude}",
                ),
              };

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 15),
                    const SizedBox(height: 15),
                    formInput("Nama kampus", controller.namaC),
                    const SizedBox(height: 15),
                    formInput("Singkatan Kampus", controller.singkatanC),
                    const SizedBox(height: 15),
                    Container(
                      width: double.infinity,
                      height: 250,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(25),
                        ),
                        child: Obx(
                          () => GoogleMap(
                            gestureRecognizers: Set()
                              ..add(Factory<OneSequenceGestureRecognizer>(
                                  () => EagerGestureRecognizer())),
                            initialCameraPosition: CameraPosition(
                              target: location,
                              zoom: 18.0,
                            ),
                            markers: controller.marker.value,
                            onMapCreated: (GoogleMapController controllerMap) {
                              controller.mapController.complete(controllerMap);
                            },
                            onTap: (pos) {
                              controller.marker.value = {
                                Marker(
                                  markerId: const MarkerId("pos"),
                                  position: pos,
                                  icon: BitmapDescriptor.defaultMarker,
                                  draggable: true,
                                  onDrag: (value) => controller.locC.text =
                                      "${value.latitude} | ${value.longitude}",
                                  onDragEnd: (value) => controller.locC.text =
                                      "${value.latitude} | ${value.longitude}",
                                ),
                              };
                              controller.locC.text =
                                  "${pos.latitude} | ${pos.longitude}";
                            },
                            myLocationEnabled: true,
                            zoomControlsEnabled: true,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    formInput("Lokasi", controller.locC, disabled: false),
                    const SizedBox(height: 15),

                    //Image
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GestureDetector(
                        onTap: () => controller.getImage(),
                        child: AbsorbPointer(
                          absorbing: true,
                          child: TextFormField(
                            controller: controller.imageC,
                            style: TextStyle(
                              fontSize: controller.fontSize,
                              color: UI.object,
                            ),
                            enabled: false,
                            decoration: InputDecoration(
                              border: controller.borderInput,
                              errorBorder: controller.borderInputError,
                              enabledBorder: controller.borderInput,
                              focusedBorder: controller.borderInputSuccess,
                              filled: true,
                              fillColor: UI.foreground,
                              labelText: "Image",
                              labelStyle: TextStyle(
                                fontSize: controller.fontSize,
                                color: UI.action,
                              ),
                              // suffixIcon:
                              suffixIcon: const Icon(
                                Icons.file_upload,
                                color: UI.object,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 7),
                    Obx(
                      () => AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeIn,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        width: double.infinity,
                        height: (controller.imageLength.value > 0) ? 200 : 0,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: (controller.imageLength.value > 0)
                              ? List.generate(controller.image.value.length,
                                  (i) {
                                  return Row(
                                    children: [
                                      Stack(
                                alignment: AlignmentDirectional.topEnd,
                                // alignment:
                                children: [
                                  Image.memory(controller.image.value[i]),
                                  Container(
                                    padding: const EdgeInsets.only(
                                      right: 10,
                                      top: 10,
                                    ),
                                    child: GestureDetector(
                                      onTap: () => controller.deleteImage(i),
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.red,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                    ],
                                  );
                                })
                              : [],
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      width: double.infinity,
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ElevatedButton(
                        onPressed: () => controller.save(),
                        style: const ButtonStyle(
                          shape: MaterialStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(25),
                              ),
                            ),
                          ),
                        ),
                        child: const Text(
                          "Simpan",
                          style: TextStyle(
                            fontSize: 18,
                            color: UI.object,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }

  Padding formInput(String title, TextEditingController c, {disabled = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        controller: c,
        enabled: disabled,
        style: TextStyle(
          fontSize: controller.fontSize,
          color: UI.object,
        ),
        decoration: InputDecoration(
          border: controller.borderInput,
          errorBorder: controller.borderInputError,
          enabledBorder: controller.borderInput,
          focusedBorder: controller.borderInputSuccess,
          filled: true,
          fillColor: UI.foreground,
          labelText: title,
          labelStyle: TextStyle(
            fontSize: controller.fontSize,
            color: UI.action,
          ),
        ),
      ),
    );
  }
}
