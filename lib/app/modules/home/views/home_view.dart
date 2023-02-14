import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:koskosan/app/Utils/Func.dart';
import 'package:koskosan/app/Utils/Menu.dart';
import 'package:koskosan/app/Utils/UI.dart';
import 'package:koskosan/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: UI.background,
      body: SafeArea(
        child: Stack(
          children: [
            StreamBuilder<QuerySnapshot<Object?>>(
                stream: controller.getAllData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    // print(snapshot.data!.docs);
                    var data = snapshot.data!.docs;
                    return Padding(
                      padding: EdgeInsets.only(bottom: height * 0.12),
                      child: ListView(
                        children: [
                          //Header Location
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Row(
                              children: [
                                Expanded(
                                  // flex: 1,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Row(
                                          children: const [
                                            Text(
                                              "Location",
                                              style: TextStyle(
                                                  color: UI.object,
                                                  fontSize: 12),
                                            ),
                                            Icon(
                                              Icons.keyboard_arrow_down,
                                              color: UI.object,
                                              size: 20,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: const [
                                          Icon(
                                            Icons.location_on,
                                            size: 30,
                                            color: UI.action,
                                          ),
                                          Text(
                                            "Makassar, Indonesia",
                                            style: TextStyle(
                                                color: UI.object, fontSize: 15),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(17),
                                      color: UI.foreground2),
                                  child: const Icon(
                                    CupertinoIcons.bell_fill,
                                    size: 25,
                                    color: UI.action,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 25),
                          //Search & Filter
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: controller.search,
                                    decoration: InputDecoration(
                                      fillColor: UI.foreground,
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide.none,
                                      ),
                                      suffixIcon: const Icon(
                                        Icons.search,
                                        color: UI.object,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(17),
                                      color: UI.foreground2),
                                  child: const Icon(
                                    CupertinoIcons.bell_fill,
                                    size: 25,
                                    color: UI.action,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 25),
                          // Category
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                itemCategory(
                                  context,
                                  "Kampus",
                                  CupertinoIcons.building_2_fill,
                                  () {},
                                ),
                                itemCategory(
                                  context,
                                  "Favorite",
                                  Icons.favorite,
                                  () {},
                                ),
                                itemCategory(
                                  context,
                                  "Terdekat",
                                  Icons.near_me,
                                  () {},
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 250,
                            child: itemHead("Undipa", data),
                          ),
                          const SizedBox(height: 15),
                        ],
                      ),
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                }),
            Menu.menu(height, 2),
          ],
        ),
      ),
    );
  }

  Widget itemHead(
    String headName,
    List<QueryDocumentSnapshot<Object?>> dataItems,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Head
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                headName,
                style: const TextStyle(
                  fontSize: 20,
                  color: UI.object,
                ),
              ),
              TextButton(
                onPressed: () {}, // Lihat semua
                child: const Text(
                  "See All",
                  style: TextStyle(color: UI.action, fontSize: 17),
                ),
              )
            ],
          ),
        ),
        //Items
        Expanded(
          child: ListView.separated(
            separatorBuilder: (context, index) {
              return const SizedBox(width: 20);
            },
            itemCount: dataItems.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              var data = dataItems[index].data() as Map<String, dynamic>;
              // print(data);
              var id = dataItems[index].id;

              return GestureDetector(
                onTap: () => Get.toNamed(Routes.ITEM_DETAIL, arguments: id),
                onDoubleTap: () => controller.likeSet(id),
                child: items(
                  context,
                  id: dataItems[index].id,
                  data: data,
                  index: index,
                  itemLength: dataItems.length,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget itemCategory(
      BuildContext context, String title, IconData icon, Function() onTap) {
    var width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width * 0.26,
        height: 125,
        decoration: BoxDecoration(
          color: UI.foreground,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircleAvatar(
              backgroundColor: UI.foreground3,
              minRadius: 35,
              child: Icon(
                icon,
                size: 35,
                color: UI.action,
              ),
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 17, color: UI.object),
            ),
          ],
        ),
      ),
    );
  }

  Widget items(
    BuildContext context, {
    required String id,
    required Map<String, dynamic> data,
    required index,
    required itemLength,
  }) {
    var size = MediaQuery.of(context).size;

    var like = false;
    if (index == 0) {
      return Row(
        children: [
          const SizedBox(width: 20),
          item(
            size,
            id,
            data,
          ),
        ],
      );
    } else if (index + 1 == itemLength) {
      return Row(
        children: [
          item(
            size,
            id,
            data,
          ),
          const SizedBox(width: 20),
        ],
      );
    }
    return item(
      size,
      id,
      data,
    );
  }

  Widget item(
    Size size,
    String id,
    Map<String, dynamic> data,
  ) {
    var radius = const Radius.circular(25);

    // Get min price
    List prices = data['prices'];
    var priceMin = prices[0];
    for (var e in prices) {
      if (e < priceMin) priceMin = e;
    }

    // Get Category
    var cat = data['categorys'];

    // Get Location
    GeoPoint geo = data['position'];
    LatLng pos = LatLng(geo.latitude, geo.longitude);

    // Function
    controller.getDataImage(id);
    controller.getLike(id);
    controller.getDistance(id, pos);

    return Container(
      width: size.width * 0.55,
      decoration: BoxDecoration(
        color: UI.foreground3,
        borderRadius: BorderRadius.circular(radius.x),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //Item Picture
          Container(
            height: size.height * 0.17,
            width: double.infinity,
            decoration: BoxDecoration(
              color: UI.foreground,
              borderRadius: BorderRadius.only(
                topLeft: radius,
                topRight: radius,
              ),
            ),
            child: Obx(
              () => (controller.imageLength.value > 0)
                  ? ((controller.imageMain.containsKey(id))
                      ? ((controller.imageMain[id]!.value.isNotEmpty)
                          ? ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: radius,
                                topRight: radius,
                              ),
                              child: Image.memory(
                                controller.imageMain[id]!.value,
                                fit: BoxFit.fill,
                              ),
                            )
                          : Container())
                      : Container())
                  : Container(),
            ),
          ),
          //Item Information
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
                top: 5,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Item Category and Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          // child: Container(),
                          child: Row(
                            children: List.generate(
                              cat.length,
                              (index) => Container(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: category(cat[index])),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              FUNC.convertToK(priceMin),
                              style: const TextStyle(
                                  fontSize: 15, color: UI.action),
                            ),
                            const Text(
                              " /bln",
                              style: TextStyle(fontSize: 15, color: UI.object),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 5),
                  //Item Name
                  Text(
                    data['name'].toString(),
                    style: const TextStyle(
                      color: UI.object,
                      fontSize: 17,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 17,
                              color: UI.action,
                            ),
                            Obx(
                              () {
                                if (controller.distNameOfCampusLength > 0) {
                                  if (controller.distNameOfCampus
                                      .containsKey(id)) {
                                    return Text(
                                      "${controller.distNameOfCampus[id]}, Jarak: ${controller.dist[id]}",
                                      style: const TextStyle(
                                          fontSize: 15, color: UI.object),
                                    );
                                  }
                                }

                                return const Text(
                                  "Not Found",
                                  style:
                                      TextStyle(fontSize: 15, color: UI.object),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => controller.likeSet(id),
                        child: Obx(
                          () => Icon(
                            (controller.favoriteLength.value > 0)
                                ? (controller.favorite.containsKey(id))
                                    ? (controller.favorite[id]!.value == true)
                                        ? Icons.favorite
                                        : Icons.favorite_outline
                                    : Icons.favorite_outline
                                : Icons.favorite_outline,
                            size: 23,
                            color: (controller.favoriteLength.value > 0)
                                ? (controller.favorite.containsKey(id))
                                    ? (controller.favorite[id]!.value == true)
                                        ? Colors.red
                                        : UI.action
                                    : UI.action
                                : UI.action,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container category(title) {
    return Container(
      // width: ,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          border: Border.all(width: 1, color: UI.action)),
      child: Text(
        title,
        style: const TextStyle(fontSize: 15, color: UI.action),
      ),
    );
  }
}
