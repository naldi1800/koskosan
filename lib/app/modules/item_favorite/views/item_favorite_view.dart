import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:koskosan/app/Utils/Func.dart';
import 'package:koskosan/app/Utils/Menu.dart';
import 'package:koskosan/app/Utils/UI.dart';
import 'package:koskosan/app/routes/app_pages.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../controllers/item_favorite_controller.dart';

class ItemFavoriteView extends GetView<ItemFavoriteController> {
  const ItemFavoriteView({Key? key}) : super(key: key);
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
                  var dataItems = snapshot.data!.docs;
                  var padding = const EdgeInsets.only(left: 20, right: 20);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 20, top: 20),
                        child: Text(
                          "Favorite",
                          style: TextStyle(color: UI.object, fontSize: 20),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Expanded(
                        child: getFavorite(dataItems, context),
                      ),
                    ],
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
            Menu.menu(height, 3),
            Obx(
              () => Visibility(
                visible: controller.viewItem.value,
                child: GestureDetector(
                  onTap: () => controller.cancelRemoveFromFavorite(),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: UI.foreground.withOpacity(0.4),
                  ),
                ),
              ),
            ),
            Obx(
              () => Align(
                alignment: Alignment.bottomCenter,
                child: Visibility(
                  // visible: controller.viewItem.value,
                  visible: true,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.ease,
                    width: double.infinity,
                    height: controller.viewItem.value ? 400 : 0,
                    decoration: const BoxDecoration(
                      color: UI.foreground,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            (controller.itemRemoveView.value.length
                                    .isGreaterThan(0))
                                ? itemViewWhereOffFavorite(
                                    controller.itemRemoveView.value["id"],
                                    controller.itemRemoveView.value["data"],
                                    controller.itemRemoveView.value["price"],
                                    controller.itemRemoveView.value["cat"],
                                    controller.itemRemoveView.value["radius"],
                                  )
                                : Container(),
                            const SizedBox(height: 15),
                            const Text(
                              "Remove from favorite?",
                              style: TextStyle(fontSize: 20, color: UI.action),
                            ),
                            const SizedBox(height: 15),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () =>
                                        controller.viewItem.value = false,
                                    style: const ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(
                                        UI.foreground,
                                      ),
                                      shape: MaterialStatePropertyAll(
                                        RoundedRectangleBorder(
                                          side: BorderSide(color: UI.action),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(25),
                                          ),
                                        ),
                                      ),
                                    ),
                                    child: const Text(
                                      "Cancel",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () => controller.likeSet(),
                                    style: const ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(
                                        UI.action,
                                      ),
                                      shape: MaterialStatePropertyAll(
                                        RoundedRectangleBorder(
                                          side: BorderSide(color: UI.action),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(25),
                                          ),
                                        ),
                                      ),
                                    ),
                                    child: const Text(
                                      "Yes, Remove",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    // child: itemValue(id, data, priceMin, cat, radius),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget notFavorite() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      // crossAxisAligment: CrossAxisAligment.center,
      children: const [
        Icon(
          Icons.search_off,
          size: 70,
          color: UI.action,
        ),
        SizedBox(height: 30),
        Text(
          "You don't have favorite",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: UI.object,
          ),
        ),
      ],
    );
  }

  Widget getFavorite(List<QueryDocumentSnapshot<Object?>> dataItems, context) {
    var radius = const Radius.circular(25);
    var pB = MediaQuery.of(context).size.height * 0.12;

    dataItems.forEach(
      (e) {
        var d = e.data() as Map<String, dynamic>;
        var id = e.id;

        // Get Location
        GeoPoint geo = d['position'];
        LatLng pos = LatLng(geo.latitude, geo.longitude);

        // Function
        controller.getDataImage(id);
        controller.getLike(id);
        controller.getDistance(id, pos);
      },
    );
    return Padding(
      padding: EdgeInsets.only(
        bottom: pB,
      ),
      child: Obx(
        () => (controller.favorite.values
                .where((e) => e.value == true)
                .isNotEmpty)
            ? ListView(
                children: List<Widget>.generate(dataItems.length, (index) {
                  var data = dataItems[index].data() as Map<String, dynamic>;
                  var id = dataItems[index].id;

                  if (controller.favorite[id]!.value == false) {
                    return Container();
                  }
                  // Get min price
                  List prices = data['prices'];
                  var priceMin = prices[0];
                  for (var e in prices) {
                    if (e < priceMin) priceMin = e;
                  }

                  // Get Category
                  var cat = data['categorys'];

                  return Column(
                    children: [
                      GestureDetector(
                          onTap: () => Get.toNamed(
                                Routes.ITEM_DETAIL,
                                arguments: id,
                                parameters: {
                                  'in': 'favorite',
                                },
                              ),
                          child: itemValue(id, data, priceMin, cat, radius)),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  );
                }).takeWhile((value) => value != Container()).toList(),
              )
            : notFavorite(),
      ),
    );

    // return Container();
  }

  Widget itemValue(id, data, priceMin, cat, radius) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
      ),
      child: Container(
        width: double.infinity,
        height: 250,
        decoration: BoxDecoration(
          color: UI.foreground3,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //Item Picture
            Container(
              height: (350) / 2,
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
                                    child: controller.category(cat[index])),
                              ),
                            ),
                          ),
                        ),
                        SingleChildScrollView(
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
                        )
                      ],
                    ),
                    const SizedBox(height: 5),
                    //Item Name
                    Text(
                      data['name'].toString(),
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
                                    if (controller.distNameOfCampusLength > 0) {
                                      if (controller.distNameOfCampus
                                          .containsKey(id)) {
                                        return Text(
                                          "${controller.distNameOfCampus[id]}, Jarak: ${controller.dist[id]}",
                                          style: const TextStyle(
                                              fontSize: 11, color: UI.object),
                                        );
                                      }
                                    }

                                    return const Text(
                                      "Not Found",
                                      style: TextStyle(
                                          fontSize: 11, color: UI.object),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          // onTap: () => controller.likeSet(id),
                          // onTap: () => controller.viewItem.value =
                          // !controller.viewItem.value,
                          onTap: () => controller.removeFromFavorite(
                              id, data, priceMin, cat, radius),
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
      ),
    );
  }

  Widget itemViewWhereOffFavorite(id, data, priceMin, cat, radius) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
      ),
      child: Container(
        width: double.infinity,
        height: 250,
        decoration: BoxDecoration(
          color: UI.foreground3,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //Item Picture
            Container(
              height: (350) / 2,
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
                                    child: controller.category(cat[index])),
                              ),
                            ),
                          ),
                        ),
                        SingleChildScrollView(
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
                        )
                      ],
                    ),
                    const SizedBox(height: 5),
                    //Item Name
                    Text(
                      data['name'].toString(),
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
                                    if (controller.distNameOfCampusLength > 0) {
                                      if (controller.distNameOfCampus
                                          .containsKey(id)) {
                                        return Text(
                                          "${controller.distNameOfCampus[id]}, Jarak: ${controller.dist[id]}",
                                          style: const TextStyle(
                                              fontSize: 11, color: UI.object),
                                        );
                                      }
                                    }

                                    return const Text(
                                      "Not Found",
                                      style: TextStyle(
                                          fontSize: 11, color: UI.object),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        Obx(
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
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
