import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:koskosan/app/Utils/Func.dart';
import 'package:koskosan/app/routes/app_pages.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:get/get.dart';
import 'package:koskosan/app/Utils/UI.dart';

import '../controllers/item_detail_controller.dart';

class ItemDetailView extends GetView<ItemDetailController> {
  const ItemDetailView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var padding = const EdgeInsets.symmetric(horizontal: 20);

    return Scaffold(
      backgroundColor: UI.background,
      body: Stack(
        children: [
          FutureBuilder(
            future: controller.getDataWithID(Get.arguments),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // print(snapshot.hasData);
                var getData = snapshot.data!.docs;
                // if (getData.isEmpty) {
                //   return const Center(child: CircularProgressIndicator());
                // }
                var data = getData[0].data() as Map<String, dynamic>;
                // print(data['categorys']);
                var rooms = data['rooms'].reduce((v, e) => v + e);
                var publicFacility = data['publicfacilitys'];
                var facility = data['facilitys'];
                var nearests = data['nearests'];
                var sizes = data['sizes'];
                var prices = data['prices'];
                var tRooms = data['rooms'];

                var parking = "Not Available";
                var wifi = "Not Available";
                GeoPoint geo = data['position'];
                LatLng location = LatLng(geo.latitude, geo.longitude);
                for (var e in publicFacility) {
                  if (e.toString().toLowerCase().contains("parkir")) {
                    if (e
                        .toString()
                        .toLowerCase()
                        .contains("mobil dan motor")) {
                      parking = "All Available";
                    } else if (e.toString().toLowerCase().contains("mobil")) {
                      parking = "Cars";
                    } else if (e.toString().toLowerCase().contains("motor")) {
                      parking = "Motorcycle ";
                    }
                  }
                  if (e.toString().toLowerCase().contains("wifi")) {
                    wifi = "Available";
                  }
                }

                var regulation = data['requlations'];

                controller.getDataImage(Get.arguments);

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Picture
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.width * 0.8,
                        color: Colors.grey,
                        child: Obx(
                          () => (controller.imageMain.value.isNotEmpty)
                              ? Image.memory(
                                  controller.imageMain.value,
                                  fit: BoxFit.fill,
                                )
                              : Container(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Category
                      Container(
                        padding: padding,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(
                              data["categorys"].length,
                              (index) => category(data["categorys"][index]),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // name
                      Container(
                        padding: padding,
                        child: Text(
                          data['name'],
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style:
                              const TextStyle(color: UI.object, fontSize: 25),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Address
                      Container(
                        padding: padding,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 20,
                              color: UI.action,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              (data['address'] != null)
                                  ? data['address']
                                  : "Makassar",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13,
                                color: UI.object,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Spec
                      Container(
                        padding: padding,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              specificationsItem(Icons.bed, "$rooms Roomsa"),
                              const SizedBox(width: 10),
                              specificationsItem(Icons.local_parking, parking),
                              const SizedBox(width: 10),
                              specificationsItem(
                                (wifi == "Available")
                                    ? Icons.wifi
                                    : Icons.wifi_off,
                                wifi,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: padding,
                        child: const Divider(
                          color: UI.foreground,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Owner
                      Container(
                        padding: padding,
                        child: Row(
                          children: [
                            Obx(
                              () => CircleAvatar(
                                radius: 30,
                                backgroundColor:
                                    (controller.imageMain.value.isEmpty)
                                        ? Colors.white
                                        : Colors.transparent,
                                backgroundImage: MemoryImage(
                                  (controller.imageMain.value.isNotEmpty)
                                      ? controller.imageMain.value
                                      : Uint8List(0),
                                ),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    (data['owner'] != null)
                                        ? data['owner']
                                        : "Unknown Name",
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: UI.object,
                                    ),
                                  ),
                                  const Text(
                                    "Owner",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: UI.object,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 65,
                              height: 65,
                              decoration: const BoxDecoration(
                                color: UI.foreground,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(35),
                                ),
                              ),
                              child: IconButton(
                                color: UI.action,
                                icon: const Icon(
                                  Icons.whatsapp,
                                  size: 30,
                                ),
                                onPressed: () async {
                                  final phoneNumber = (data['phone'] != null)
                                      ? data['phone']
                                      : false;
                                  if (!phoneNumber) {
                                    Get.defaultDialog(
                                      title: "Terjadi Kesalahan",
                                      middleText:
                                          "Phone Number is not available",
                                      backgroundColor: UI.foreground,
                                      titleStyle:
                                          const TextStyle(color: UI.object),
                                      middleTextStyle:
                                          const TextStyle(color: UI.object),
                                    );
                                  } else {
                                    final url = "https://wa.me/$phoneNumber";
                                    if (await canLaunch(url)) {
                                      await launch(url);
                                    } else {
                                      throw 'Could not launch $url';
                                    }
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Description
                      Container(
                        padding: padding,
                        child: const Text(
                          "Overview",
                          style: TextStyle(color: UI.object, fontSize: 17),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: padding,
                        child: Text(
                          (data['description'] == null)
                              ? "No Description"
                              : data['description'],
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: const TextStyle(
                            color: UI.object,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Gallery
                      Container(
                        padding: padding,
                        child: const Text(
                          "Gallery",
                          style: TextStyle(color: UI.object, fontSize: 17),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: padding,
                        child: Obx(
                          () => (controller.galeryLenght.value != 0)
                              ? GestureDetector(
                                  onTap: () {
                                    Get.toNamed(Routes.GALLERI_ITEM,
                                        arguments: "vzu14XPbovaxnQTkETA3");
                                  },
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: List.generate(
                                        (controller.galery.length != 0)
                                            ? controller.galery.length
                                            : 0,
                                        (index) => gallerys(
                                          controller.galery[index].value,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : const Text(
                                  "No Image",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: UI.object,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      //MAP
                      Container(
                        padding: padding,
                        child: const Text(
                          "Location",
                          style: TextStyle(
                            color: UI.object,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: padding,
                        height: 200.0,
                        width: double.infinity,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(25),
                          ),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            heightFactor: 0.3,
                            widthFactor: 2.5,
                            child: GoogleMap(
                              initialCameraPosition: CameraPosition(
                                target: location,
                                zoom: 14.0,
                              ),
                              markers: {
                                Marker(
                                  markerId: const MarkerId("this location"),
                                  position: location,
                                  icon: BitmapDescriptor.defaultMarkerWithHue(
                                      BitmapDescriptor.hueRed),
                                ),
                              },
                              onMapCreated:
                                  (GoogleMapController controllerMap) {
                                controller.mapController
                                    .complete(controllerMap);
                              },
                              myLocationEnabled: true,
                              zoomControlsEnabled: false,
                              zoomGesturesEnabled: false,
                              onTap: (argument) => Get.toNamed(
                                Routes.MAPS,
                                arguments: Get.arguments,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Nearest
                      Container(
                        padding: padding,
                        child: const Text(
                          "Dekat dengan",
                          style: TextStyle(
                            color: UI.object,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: padding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                              nearests.length, (i) => info(nearests[i])),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Prices
                      Container(
                        padding: padding,
                        child: const Text(
                          "Harga kamar",
                          style: TextStyle(
                            color: UI.object,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: padding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(prices.length, (i) {
                            return infoRooms(
                              sizes[i],
                              FUNC.convertToIdr(prices[i]),
                            );
                          }),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Futures, Facilities and Regulation
                      Container(
                        padding: padding,
                        child: const Text(
                          "Features, Facilities and Regulation",
                          style: TextStyle(
                            color: UI.object,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: padding,
                        child: Obx(
                          () => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  controller.setFeature(0);
                                },
                                style: ButtonStyle(
                                  backgroundColor: (controller.spec.value == 0)
                                      ? const MaterialStatePropertyAll(
                                          UI.action)
                                      : const MaterialStatePropertyAll(
                                          UI.background),
                                  shape: const MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(25),
                                      ),
                                    ),
                                  ),
                                  side: const MaterialStatePropertyAll(
                                    BorderSide(color: UI.action, width: 1),
                                  ),
                                ),
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  child: const Text(
                                    "Facility",
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  controller.setFeature(1);
                                },
                                style: ButtonStyle(
                                  backgroundColor: (controller.spec.value == 1)
                                      ? const MaterialStatePropertyAll(
                                          UI.action)
                                      : const MaterialStatePropertyAll(
                                          UI.background),
                                  shape: const MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(25),
                                      ),
                                    ),
                                  ),
                                  side: const MaterialStatePropertyAll(
                                    BorderSide(color: UI.action, width: 1),
                                  ),
                                ),
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  child: const Text(
                                    "Public Facility",
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  controller.setFeature(2);
                                },
                                style: ButtonStyle(
                                  backgroundColor: (controller.spec.value == 2)
                                      ? const MaterialStatePropertyAll(
                                          UI.action)
                                      : const MaterialStatePropertyAll(
                                          UI.background),
                                  shape: const MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(25),
                                      ),
                                    ),
                                  ),
                                  side: const MaterialStatePropertyAll(
                                    BorderSide(color: UI.action, width: 1),
                                  ),
                                ),
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  child: const Text(
                                    "Regulation",
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: padding,
                        child: Obx(
                          () => (controller.spec.value == 0)
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: List.generate(
                                    facility.length,
                                    (i) => info(facility[i]),
                                  ),
                                )
                              : (controller.spec.value == 1)
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: List.generate(
                                        publicFacility.length,
                                        (i) => info(publicFacility[i]),
                                      ),
                                    )
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: List.generate(
                                        regulation.length,
                                        (i) => info(regulation[i]),
                                      ),
                                    ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
          // Action Button
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(
                      Icons.arrow_back_sharp,
                      color: UI.action,
                    ),
                  ),
                  Obx(
                    () => GestureDetector(
                      onTap: () => controller.setFavorite(
                        context,
                        "vzu14XPbovaxnQTkETA3",
                      ),
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                          color: UI.foreground2,
                        ),
                        width: 50,
                        height: 50,
                        child: (!controller.favorite.value)
                            ? const Icon(
                                Icons.favorite_outline,
                                color: UI.action,
                              )
                            : const Icon(
                                Icons.favorite,
                                color: UI.borderInputColorError,
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget infoRooms(String info, String price) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Size: $info",
              style: const TextStyle(color: Colors.grey, fontSize: 17),
            ),
            Text(
              "$price /bln",
              style: const TextStyle(color: UI.action, fontSize: 18),
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget info(String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "- $value",
          style: const TextStyle(color: UI.object, fontSize: 15),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          textAlign: TextAlign.start,
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget gallerys(Uint8List image) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          height: 75,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
            child: Image.memory(
              image,
              fit: BoxFit.fill,
            ),
          ),
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  Row specificationsItem(IconData icon, String title) {
    return Row(
      children: [
        CircleAvatar(
          minRadius: 17,
          backgroundColor: UI.foreground,
          child: Icon(
            icon,
            size: 20,
            color: UI.action,
          ),
        ),
        const SizedBox(width: 7),
        Text(
          title,
          style: const TextStyle(fontSize: 13, color: UI.object),
        )
      ],
    );
  }

  Row near(String title, String value) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 17, color: UI.object),
        ),
        const SizedBox(width: 7),
        Text(
          title,
          style: const TextStyle(fontSize: 15, color: Colors.grey),
        )
      ],
    );
  }

  Widget category(String value) {
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: UI.action,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(7),
          child: Text(
            value,
            style: const TextStyle(color: UI.action),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
