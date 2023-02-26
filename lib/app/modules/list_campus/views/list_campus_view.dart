import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:koskosan/app/Utils/Menu.dart';
import 'package:koskosan/app/Utils/UI.dart';
import 'package:koskosan/app/routes/app_pages.dart';

import '../controllers/list_campus_controller.dart';

class ListCampusView extends GetView<ListCampusController> {
  const ListCampusView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var sizePadding = 20.0;
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: UI.background,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  padding: EdgeInsets.only(
                    left: sizePadding,
                    right: sizePadding,
                    top: sizePadding - 10,
                  ),
                  color: UI.foreground,
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: UI.action,
                        ),
                        onPressed: () {
                          Get.back();
                        },
                      ),
                      const Expanded(
                        child: Text(
                          "Kampus",
                          style: TextStyle(
                            fontSize: 20,
                            color: UI.object,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: FutureBuilder(
                    future: controller.getAllData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        var getData = snapshot.data!.docs;
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: height * 0.12,
                          ),
                          child: ListView.builder(
                            itemCount: getData.length,
                            // addAutomaticKeepAlives: true,
                            // addRepaintBoundaries: true,
                            itemBuilder: (context, index) {
                              var d =
                                  getData[index].data() as Map<String, dynamic>;
                              var id = getData[index].id;
                              if(!controller.images.containsKey(id)){
                                controller.getDataImage(id);
                              }
                              return item(id, index, sizePadding, d);
                            },
                          ),
                        );
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
              ],
            ),
            Menu.menu(height, 2)
          ],
        ),
      ),
    );
  }

  Widget item(
      String id, int index, double sizePadding, Map<String, dynamic> d) {
    return GestureDetector(
      onTap: () => Get.toNamed(
        Routes.MAPS_CAMPUS,
        arguments: id,
      ),
      onDoubleTap: () => controller.getDataImage(id),
      child: Column(
        children: [
          index == 0 ? const SizedBox(height: 10) : const SizedBox(),
          Padding(
            padding: EdgeInsets.only(
              left: sizePadding,
              right: sizePadding,
            ),
            child: Container(
              height: 255,
              width: double.infinity,
              decoration: BoxDecoration(
                // border: Border.all(),
                borderRadius: BorderRadius.circular(25),
                color: UI.foreground,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 275 * 0.7,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                      color: UI.object,
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
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
                                          "Image not found or not loaded double tap to reload",
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: UI.foreground),
                                        ),
                                      ),
                                    ),
                                  )
                            : Container(
                                color: Colors.grey,
                                child: const Center(
                                  child: Text(
                                    "Loading Image",
                                    style: TextStyle(
                                        fontSize: 20, color: UI.foreground),
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ),
                  // const SizedBox(height: 5),
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 5,
                        ),
                        child: Text(
                          d['name'],
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                            color: UI.object,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
