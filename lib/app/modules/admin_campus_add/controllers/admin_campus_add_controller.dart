import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:koskosan/app/Utils/UI.dart';
import 'package:koskosan/app/routes/app_pages.dart';

class AdminCampusAddController extends GetxController {
  late TextEditingController namaC;
  late TextEditingController singkatanC;
  late TextEditingController locC;
  late TextEditingController imageC;
  late Completer<GoogleMapController> mapController;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;

  Rx<List<Uint8List>> image = Rx<List<Uint8List>>([]);
  Rx<Set<Marker>> marker = Rx<Set<Marker>>(
    {
      const Marker(
        markerId: MarkerId('pos'),
        visible: false,
      ),
    },
  );

  var imageLength = 0.obs;

  var fontSize = 15.0;
  var borderRadius = 25.0;
  var borderInput;
  var borderInputError;
  var borderInputSuccess;

  @override
  void onInit() {
    super.onInit();
    namaC = TextEditingController(text: "");
    singkatanC = TextEditingController(text: "");
    locC = TextEditingController(text: "");
    imageC = TextEditingController(text: "");
    mapController = Completer();

    borderInput = OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: const BorderSide(color: UI.action),
    );
    borderInputError = OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: const BorderSide(color: UI.borderInputColorError),
    );
    borderInputSuccess = OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: const BorderSide(color: UI.action),
    );
  }

  @override
  void onClose() {
    super.onClose();
    namaC.dispose();
    singkatanC.dispose();
    locC.dispose();
    imageC.dispose();
  }

  void getImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg'],
    );
    if (result != null) {
      List<File> files = result.paths.map((p) => File("$p")).toList();
      List<Uint8List> bytes = [];
      imageC.text = "";
      files.forEach((e) async {
        var byte = await getBytesOfFile(e);
        bytes.add(byte);
        image.value.add(byte);
        imageLength.value = image.value.length;
        // print("ada");
      });
      imageC.text = "Image loaded";
      // await Future.delayed(Duration(seconds: 2));
      // print("Cek gambar : $bytes");
    } else {
      dialog(msg: "Gagal mengambil gambar");
    }
  }

  void deleteImage(int i) {
    imageLength.value = 0;
    image.value.removeAt(i);
    imageLength.value = image.value.length;
    if (imageLength.value == 0) {
      imageC.text = "";
    }
  }

  Future<Uint8List> getBytesOfFile(File file) async {
    List<int> list = await file.readAsBytes();
    return Uint8List.fromList(list);
  }

  void save() async {
    var name = namaC.text;
    var skt = singkatanC.text;
    var point = locC.text;

    if (name == "") {
      dialog(msg: "Nama kampus harus diisi");
    } else if (skt == "") {
      dialog(msg: "Nama Singkatan kampus harus diisi");
    } else if (point == "") {
      dialog(msg: "Lokasi kampus harus dipilih");
    }
    var campus = firestore.collection("campus");
    // GeoPoint g = GeoPoint();

    List<LatLng> geo = marker.value.map((e) => e.position).toList();
    double lat = (geo.isNotEmpty) ? geo[0].latitude : 0.0;
    double long = (geo.isNotEmpty) ? geo[0].longitude : 0.0;
    GeoPoint pos = GeoPoint(
      lat,
      long,
    );
    var saves =
        await campus.add({"name": name, "abbreviation": skt, "location": pos});
    // print(id);
    if (saves.id == "") {
      dialog(msg: "Data gagal disimpan");
    } else {
      var index = 1;
      var id = saves.id;
      await Future.wait(image.value.map(
        (e) async {
          var name = "${index}.jpg";
          index++;
          await storage.ref("campus/$id/$name").putData(e);
        },
      ));
      Get.defaultDialog(
        title: "INFO",
        middleText: "Data berhasil disimpan",
        titleStyle: const TextStyle(
          fontSize: 18,
          color: UI.object,
        ),
        middleTextStyle: const TextStyle(
          fontSize: 18,
          color: UI.object,
        ),
        backgroundColor: UI.foreground,
        textConfirm: "Oke",
        onConfirm: () {
          Get.back();
          Get.offAndToNamed(Routes.ADMIN_CAMPUS);
        },
      );
    }
  }

  void dialog({required String msg}) {
    Get.defaultDialog(
      title: "INFO",
      middleText: msg,
      titleStyle: const TextStyle(
        fontSize: 18,
        color: UI.object,
      ),
      middleTextStyle: const TextStyle(
        fontSize: 18,
        color: UI.object,
      ),
      backgroundColor: UI.foreground,
      textConfirm: "Oke",
      onConfirm: () => Get.back(),
    );
  }
}
