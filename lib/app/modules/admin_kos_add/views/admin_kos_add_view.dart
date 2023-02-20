import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:koskosan/app/Utils/UI.dart';

import '../controllers/admin_kos_add_controller.dart';

class AdminKosAddView extends GetView<AdminKosAddController> {
  const AdminKosAddView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Kos'),
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
            formInput("Nama Kos", controller.namaC),
            const SizedBox(height: 15),
            formInput("Deskripsi Kos", controller.desC),
            const SizedBox(height: 15),
            formInput("Nomor HP", controller.contactC),
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

            //Category
            formInputWith(controller.categoryC, controller.categoryL,
                controller.category, "Kategori"),
            const SizedBox(height: 7),
            formInputWithChild(controller.categoryL, controller.category),
            const SizedBox(height: 15),

            //Fasilitas
            formInputWith(controller.facilityC, controller.facilityL,
                controller.facility, "Fasilitas"),
            const SizedBox(height: 7),
            formInputWithChild(controller.facilityL, controller.facility),
            const SizedBox(height: 15),

            //Fasilitas Umum
            formInputWith(controller.facilityUC, controller.facilityUL,
                controller.facilityU, "Fasilitas Umum"),
            const SizedBox(height: 7),
            formInputWithChild(controller.facilityUL, controller.facilityU),
            const SizedBox(height: 15),

            //Ruangan
            formInputWith(controller.roomsC, controller.roomsL,
                controller.rooms, "Jumlah Kamar"),
            const SizedBox(height: 7),
            formInputWithChild(controller.roomsL, controller.rooms),
            const SizedBox(height: 15),

            //Harga / Ruangan
            formInputWith(controller.priceC, controller.priceL,
                controller.price, "Harga/Kamar"),
            const SizedBox(height: 7),
            formInputWithChild(controller.priceL, controller.price),
            const SizedBox(height: 15),

            //Ukuran
            formInputWith(controller.sizesC, controller.sizesL,
                controller.sizes, "Ukuran/Kamar"),
            const SizedBox(height: 7),
            formInputWithChild(controller.sizesL, controller.sizes),
            const SizedBox(height: 15),

            //Peraturan
            formInputWith(controller.regulationC, controller.regulationL,
                controller.regulation, "Peraturan"),
            const SizedBox(height: 7),
            formInputWithChild(controller.regulationL, controller.regulation),
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
                              const SizedBox(width: 5),
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
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Padding formInputWithChild(RxInt lengthC, List<String> list) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Obx(
        () => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: (lengthC.value >= 0 || lengthC.value != list.length)
                ? List.generate(
                    list.length,
                    (index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            height: 25,
                            decoration: BoxDecoration(
                              border: Border.all(color: UI.object),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  list[index],
                                  style: const TextStyle(
                                    color: UI.object,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(width: 3),
                                GestureDetector(
                                  onTap: () {
                                    Get.defaultDialog(
                                      title: "Warning!!!",
                                      middleText: "Delete '${list[index]}' ?",
                                      textConfirm: "Delete",
                                      textCancel: "Cancel",
                                      onConfirm: () {
                                        list.removeAt(index);
                                        lengthC.value = list.length;
                                        Get.back();
                                        print("List : $list");
                                      },
                                      onCancel: () => Get.back(),
                                    );
                                  },
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.red,
                                    size: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 5),
                        ],
                      );
                    },
                  )
                : [],
          ),
        ),
      ),
    );
  }

  Padding formInputWith(
      TextEditingController control, RxInt lengthC, List<String> list, title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextFormField(
              controller: control,
              style: TextStyle(
                fontSize: controller.fontSize,
                color: UI.object,
              ),
              keyboardType: TextInputType.multiline,
              maxLines: null,
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
          ),
          const SizedBox(width: 5),
          IconButton(
            onPressed: () {
              var cat = control.text;
              if (cat == "") return;
              list.add(cat);
              lengthC.value = list.length;
              control.text = "";
            },
            icon: const Icon(
              Icons.add,
              color: UI.action,
            ),
          ),
        ],
      ),
    );
  }

  // Padding formInputWithChild() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 20),
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //       children: [
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Expanded(
  //               child: TextFormField(
  //                 controller: controller.categoryC,
  //                 style: TextStyle(
  //                   fontSize: controller.fontSize,
  //                   color: UI.object,
  //                 ),
  //                 keyboardType: TextInputType.multiline,
  //                 maxLines: null,
  //                 decoration: InputDecoration(
  //                   border: controller.borderInput,
  //                   errorBorder: controller.borderInputError,
  //                   enabledBorder: controller.borderInput,
  //                   focusedBorder: controller.borderInputSuccess,
  //                   filled: true,
  //                   fillColor: UI.foreground,
  //                   labelText: "Image",
  //                   labelStyle: TextStyle(
  //                     fontSize: controller.fontSize,
  //                     color: UI.action,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(width: 5),
  //             IconButton(
  //               onPressed: () {
  //                 var cat = controller.categoryC.text;
  //                 controller.category.add(cat);
  //                 controller.categoryL.value = controller.category.length;
  //                 controller.categoryC.text = "";
  //               },
  //               icon: const Icon(
  //                 Icons.add,
  //                 color: UI.action,
  //               ),
  //             ),
  //           ],
  //         ),
  //         Obx(
  //           () => ListView(
  //             scrollDirection: Axis.horizontal,
  //             children: (controller.categoryL.value > 0)
  //                 ? List.generate(
  //                     controller.category.length,
  //                     (index) {
  //                       return Row(
  //                         children: [
  //                           Text(controller.category[index]),
  //                           const SizedBox(width: 5),
  //                         ],
  //                       );
  //                     },
  //                   )
  //                 : [],
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

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