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

class AdminKosEditController extends GetxController {
  late TextEditingController namaC;
  late TextEditingController desC;
  late TextEditingController locC;
  late TextEditingController imageC;
  late TextEditingController contactC;
  late TextEditingController categoryC;
  late TextEditingController sizesC;
  late TextEditingController roomsC;
  late TextEditingController priceC;
  late TextEditingController regulationC;
  late TextEditingController facilityC;
  late TextEditingController facilityUC;

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

  List<String> category = [];
  List<String> regulation = [];
  List<String> facility = [];
  List<String> facilityU = [];
  List<String> rooms = [];
  List<String> sizes = [];
  List<String> price = [];

  var categoryL = 0.obs;
  var regulationL = 0.obs;
  var facilityL = 0.obs;
  var facilityUL = 0.obs;
  var roomsL = 0.obs;
  var sizesL = 0.obs;
  var priceL = 0.obs;

  @override
  void onInit() {
    super.onInit();
    namaC = TextEditingController(text: "");
    desC = TextEditingController(text: "");
    locC = TextEditingController(text: "");
    imageC = TextEditingController(text: "");
    contactC = TextEditingController(text: "");
    categoryC = TextEditingController(text: "");
    sizesC = TextEditingController(text: "");
    roomsC = TextEditingController(text: "");
    priceC = TextEditingController(text: "");
    regulationC = TextEditingController(text: "");
    facilityC = TextEditingController(text: "");
    facilityUC = TextEditingController(text: "");

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
    desC.dispose();
    locC.dispose();
    imageC.dispose();
    contactC.dispose();
    categoryC.dispose();
    sizesC.dispose();
    roomsC.dispose();
    priceC.dispose();
    regulationC.dispose();
    facilityC.dispose();
    facilityUC.dispose();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getData(String docID) async {
    var get = firestore.collection("boardings").doc(docID);
    await getImageFromFirebase(docID);
    return get.get();
  }

  Future getImageFromFirebase(String docID) async {
    var ref = storage.ref().child("galery").child(docID);
    var getAll = await ref.listAll();
    image.value = [];
    getAll.items.forEach((e) async {
      var img = await e.getData();
      image.value.add(img!);
      imageLength.value = image.value.length;
    });
  }

  void deleteImage(int i) {
    imageLength.value = 0;
    image.value.removeAt(i);
    imageLength.value = image.value.length;
    if (imageLength.value == 0) {
      imageC.text = "";
    }
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
        imageC.text += e.path;
      });
    } else {
      dialog(msg: "Gagal mengambil gambar");
    }
  }

  Future<Uint8List> getBytesOfFile(File file) async {
    List<int> list = await file.readAsBytes();
    return Uint8List.fromList(list);
  }

  void save() async {
    var name = namaC.text;
    var desc = desC.text;
    var hp = contactC.text;
    var point = locC.text;

    var res = name == "" || desc == "" || hp == "" || point == "";
    var res2 = category.isEmpty ||
        sizes.isEmpty ||
        regulation.isEmpty ||
        rooms.isEmpty ||
        facility.isEmpty ||
        facilityU.isEmpty ||
        price.isEmpty;

    if (res || res2) {
      dialog(msg: "Semua harus di isi");
      return;
    }
    var kos = firestore.collection("boardings").doc(Get.arguments);

    List<LatLng> geo = marker.value.map((e) => e.position).toList();
    double lat = (geo.isNotEmpty) ? geo[0].latitude : 0.0;
    double long = (geo.isNotEmpty) ? geo[0].longitude : 0.0;
    GeoPoint pos = GeoPoint(
      lat,
      long,
    );
    await kos.update({
      "name": name,
      "description": desc,
      "position": pos,
      "categorys": category,
      "facilitys": facility,
      "prices": price.map((e) => int.parse(e)).toList(),
      "publicfacilitys": facilityU,
      "requlations": regulation,
      "rooms": rooms.map((e) => int.parse(e)).toList(),
      "sizes": sizes,
      "phone": hp,
    }).then((value) async {
      var id = Get.arguments;
      // Delete All Image
      ListResult deleted =
          await storage.ref().child("galery").child(id).listAll();

      for (var del in deleted.items) {
        await del.delete();
      }

      // Save
      var index = 1;
      await Future.wait(image.value.map(
        (e) async {
          var name = "${index}.jpg";
          index++;
          await storage.ref("galery/$id/$name").putData(e);
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
        onConfirm: () => Get.offAndToNamed(Routes.ADMIN_KOS),
      );
    }).catchError((err) => dialog(msg: "Data gagal disimpan"));
    // Future.wait()/;
    // print(id);
    // if (saves.) {
    //   dialog(msg: "Data gagal disimpan");
    // } else {
    //   var index = 1;
    //   var id = Get.arguments;
    //   // Delete All Image
    //   var ref = storage.ref().child("galery").child(id)

    //   // Save
    //   await Future.wait(image.value.map(
    //     (e) async {
    //       var name = "${index}.jpg";
    //       index++;
    //       await storage.ref("galery/$id/$name").putData(e);
    //     },
    //   ));
    //   Get.defaultDialog(
    //     title: "INFO",
    //     middleText: "Data berhasil disimpan",
    //     titleStyle: const TextStyle(
    //       fontSize: 18,
    //       color: UI.object,
    //     ),
    //     middleTextStyle: const TextStyle(
    //       fontSize: 18,
    //       color: UI.object,
    //     ),
    //     backgroundColor: UI.foreground,
    //     textConfirm: "Oke",
    //     onConfirm: () => Get.offAndToNamed(Routes.ADMIN_KOS),
    //   );
    // }
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
