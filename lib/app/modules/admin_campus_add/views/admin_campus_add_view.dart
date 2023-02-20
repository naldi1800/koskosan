import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:koskosan/app/Utils/UI.dart';

import '../controllers/admin_campus_add_controller.dart';

class AdminCampusAddView extends GetView<AdminCampusAddController> {
  const AdminCampusAddView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Kampus'),
        centerTitle: true,
        backgroundColor: UI.foreground,
      ),
      backgroundColor: UI.background,
      body: SingleChildScrollView(
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
              height: 150,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(25),
                ),
                child: Obx(
                  () => GoogleMap(
                    initialCameraPosition: const CameraPosition(
                      target: LatLng(-5.1404082, 119.4832254),
                      zoom: 10.0,
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
                    zoomControlsEnabled: false,
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
                      ? List.generate(controller.image.value.length, (i) {
                          return Row(
                            children: [
                              Image.memory(controller.image.value[i]),
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
      ),
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
