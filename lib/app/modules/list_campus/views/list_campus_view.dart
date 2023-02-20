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
                      // GestureDetector(
                      //   // color: UI.foreground,
                      //   child: Container(
                      //     height: 45,
                      //     width: 45,
                      //     decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(13),
                      //       color: UI.foreground,
                      //     ),
                      //     child: const Icon(
                      //       Icons.search,
                      //       color: UI.action,
                      //     ),
                      //   ),
                      //   onTap: () {},
                      // ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: StreamBuilder(
                    stream: controller.getAllData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.active) {
                        var getData = snapshot.data!.docs;
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: height * 0.12,
                          ),
                          child: ListView.builder(
                            itemCount: getData.length,
                            itemBuilder: (context, index) {
                              var d =
                                  getData[index].data() as Map<String, dynamic>;
                              controller.getDataImage(getData[index].id);
                              return GestureDetector(
                                onTap: () => Get.toNamed(Routes.MAPS_CAMPUS,
                                    arguments: getData[index].id),
                                child: Column(
                                  children: [
                                    index == 0
                                        ? const SizedBox(height: 10)
                                        : const SizedBox(),
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
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          color: UI.foreground,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  topLeft: Radius.circular(25),
                                                  topRight: Radius.circular(25),
                                                ),
                                                child: Obx(
                                                  () => (controller.imageLength
                                                              .value >
                                                          0)
                                                      ? Image.memory(
                                                          controller
                                                              .imageMain
                                                              .values
                                                              .first
                                                              .value,
                                                          fit: BoxFit.fill,
                                                        )
                                                      : Container(
                                                          color: Colors.grey,
                                                        ),
                                                ),
                                              ),
                                            ),
                                            // const SizedBox(height: 5),
                                            Expanded(
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 15,
                                                    vertical: 5,
                                                  ),
                                                  child: Text(
                                                    d['name'],
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                                            // Padding(
                                            //   padding: const EdgeInsets.symmetric(
                                            //     horizontal: 15,
                                            //     vertical: 5,
                                            //   ),
                                            //   child: Row(
                                            //     mainAxisAlignment:
                                            //         MainAxisAlignment.spaceEvenly,
                                            //     mainAxisSize: MainAxisSize.max,
                                            //     children: const [
                                            //       Icon(
                                            //         Icons.location_on,
                                            //         size: 20,
                                            //         color: UI.action,
                                            //       ),
                                            //       SizedBox(width: 10),
                                            //       Text(
                                            //         "Undipa",
                                            //         style: TextStyle(
                                            //             fontSize: 15,
                                            //             color: UI.object),
                                            //       ),
                                            //       Expanded(
                                            //         child: Align(
                                            //           alignment:
                                            //               Alignment.centerRight,
                                            //           child: Icon(
                                            //             Icons.favorite_outline,
                                            //             color: UI.action,
                                            //           ),
                                            //         ),
                                            //       )
                                            //     ],
                                            //   ),
                                            // )
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                  ],
                                ),
                              );
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
}
