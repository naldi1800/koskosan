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
import 'package:sliding_up_panel/sliding_up_panel.dart';

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
                    var dataItems = snapshot.data!.docs;
                    var padding = const EdgeInsets.only(left: 20, right: 20);
                    var size = MediaQuery.of(context).size;

                    // controller.getDataCampus(data);

                    return SlidingUpPanel(
                      controller: controller.panelController,
                      minHeight: size.height * 0.67,
                      maxHeight: size.height,
                      color: UI.background,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(25)),
                      body: Padding(
                        padding: EdgeInsets.only(bottom: height * 0),
                        child: Column(
                          // scrollDirection: Axis.vertical,
                          children: [
                            //Header Location
                            Padding(
                              padding: padding,
                              child: Row(
                                children: [
                                  Expanded(
                                    // flex: 1,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: const [
                                            Icon(
                                              Icons.location_on,
                                              size: 30,
                                              color: UI.action,
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Text(
                                              "Makassar",
                                              style: TextStyle(
                                                color: UI.object,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  PopupMenuButton(
                                    icon: const Icon(
                                      Icons.more_vert,
                                      color: UI.object,
                                    ),
                                    color: UI.foreground,
                                    itemBuilder: (context) {
                                      return [
                                        PopupMenuItem(
                                          value: 1,
                                          child: popItem("Login", Icons.login),
                                        ),
                                        PopupMenuItem(
                                          value: 2,
                                          child: popItem(
                                              "About", Icons.info_outline),
                                        ),
                                        PopupMenuItem(
                                          value: 3,
                                          child: popItem(
                                              "Exit", Icons.exit_to_app),
                                        ),
                                      ];
                                    },
                                    onSelected: (v) {
                                      switch (v) {
                                        case 1:
                                          Get.toNamed(Routes.LOGIN);
                                          break;
                                        case 3:
                                          Get.back();
                                          break;
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: padding,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  itemCategory(
                                    context,
                                    "Kampus",
                                    CupertinoIcons.building_2_fill,
                                    () => Get.toNamed(Routes.LIST_CAMPUS),
                                  ),
                                  const SizedBox(width: 20),
                                ],
                              ),
                            ),
                            const SizedBox(height: 15),
                          ],
                        ),
                      ),
                      panelBuilder: (c) {
                        return Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: size.width * 0.45),
                              child: GestureDetector(
                                onTap: () =>
                                    controller.panelController.isPanelOpen
                                        ? controller.panelController.close()
                                        : controller.panelController.open(),
                                child: const Divider(
                                  color: Colors.grey,
                                  thickness: 3,
                                  height: 20,
                                ),
                              ),
                            ),
                            const SizedBox(height: 7),
                            Expanded(
                              child: GridView.builder(
                                controller: c,
                                // physics: NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                  mainAxisExtent: 200,
                                ),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 13),
                                itemCount: dataItems.length,
                                // itemCount: 10,
                                itemBuilder: (BuildContext context, int index) {
                                  var data = dataItems[index].data()
                                      as Map<String, dynamic>;
                                  // print(data);
                                  var id = dataItems[index].id;
                                  var size = MediaQuery.of(context).size;
                                  return GestureDetector(
                                    onTap: () {
                                      print("CEK : ${dataItems[index].id}");
                                      // return;
                                      Get.toNamed(
                                        Routes.ITEM_DETAIL,
                                        arguments: dataItems[index].id,
                                      );
                                    },
                                    onDoubleTap: () => controller.likeSet(id),
                                    onLongPress: () =>
                                        controller.getDataImage(id),
                                    child: item(
                                      size,
                                      id,
                                      data,
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: height * 0.165),
                          ],
                        );
                      },
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

  Row popItem(String title, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: UI.object,
        ),
        const SizedBox(
          width: 7,
        ),
        Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            color: UI.object,
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
    if (!controller.images.containsKey(id)) {
      controller.getDataImage(id);
    }
    if (!controller.favorite.containsKey(id)) {
      controller.getLike(id);
    }
    if (!controller.dist.containsKey(id)) {
      controller.getDistance(id, pos);
    }

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
            height: (250 - 20) / 2,
            width: double.infinity,
            decoration: BoxDecoration(
              color: UI.foreground,
              borderRadius: BorderRadius.only(
                topLeft: radius,
                topRight: radius,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: radius,
                topRight: radius,
              ),
              child: Obx(
                () => (controller.imageCheck.value)
                    ? (controller.images.containsKey(id))
                        ? Image.network(
                            controller.images[id]!,
                            fit: BoxFit.fill,
                          )
                        : Container(
                            color: Colors.grey,
                            child: const Center(
                              child: Padding(
                                padding: EdgeInsets.all(15),
                                child: Text(
                                  "Image not found or not loaded long press to reload",
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 12, color: UI.foreground),
                                ),
                              ),
                            ),
                          )
                    : Container(
                        color: Colors.grey,
                        child: const Center(
                          child: Text(
                            "Loading Image",
                            style:
                                TextStyle(fontSize: 12, color: UI.foreground),
                          ),
                        ),
                      ),
              ),
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
                mainAxisAlignment: MainAxisAlignment.center,
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
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                FUNC.convertToK(priceMin),
                                style: const TextStyle(
                                    fontSize: 12, color: UI.action),
                              ),
                              const Text(
                                " /bln",
                                style:
                                    TextStyle(fontSize: 12, color: UI.object),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 5),
                  //Item Name
                  Text(
                    data['name'].toString(),
                    maxLines: 2,
                    overflow: TextOverflow.visible,
                    style: const TextStyle(
                      color: UI.object,
                      fontSize: 15,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 13,
                                color: UI.action,
                              ),
                              Obx(
                                () {
                                  if (controller.distCheck.value) {
                                    if (controller.dist.containsKey(id)) {
                                      return Text(
                                        "${controller.distNameOfCampus[id]}, Jarak: ${controller.dist[id]}",
                                        style: const TextStyle(
                                            fontSize: 11, color: UI.object),
                                      );
                                    }
                                    return const Text(
                                      "Not found or not loaded",
                                      style: TextStyle(
                                          fontSize: 11, color: UI.object),
                                    );
                                  } else {
                                    return const Text(
                                      "Loading..",
                                      style: TextStyle(
                                          fontSize: 11, color: UI.object),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => controller.likeSet(id),
                        child: Obx(
                          () => Icon(
                            (controller.favoriteCheck.value)
                                ? (controller.favorite.containsKey(id))
                                    ? (controller.favorite[id]! == true)
                                        ? Icons.favorite
                                        : Icons.favorite_outline
                                    : Icons.favorite_outline
                                : Icons.favorite_outline,
                            size: 23,
                            color: (controller.favoriteCheck.value)
                                ? (controller.favorite.containsKey(id))
                                    ? (controller.favorite[id]! == true)
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          border: Border.all(width: 1, color: UI.action)),
      child: Text(
        title,
        style: const TextStyle(fontSize: 8, color: UI.action),
      ),
    );
  }
}
