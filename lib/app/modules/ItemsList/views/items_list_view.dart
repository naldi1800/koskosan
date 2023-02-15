import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:koskosan/app/Utils/Menu.dart';
import 'package:koskosan/app/Utils/UI.dart';

import '../controllers/items_list_controller.dart';

class ItemsListView extends GetView<ItemsListController> {
  const ItemsListView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var sizePadding = 20.0;
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('House'),
      //   backgroundColor: Colors.transparent,
      //   actions: [
      //     IconButton(
      //       icon: Icon(Icons.search),
      //       onPressed: () {},
      //     ),
      //   ],
      // ),
      backgroundColor: UI.background,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: sizePadding,
                right: sizePadding,
                top: sizePadding - 10,
                bottom: height * 0.12,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: UI.action,
                        ),
                        onPressed: () {
                          // Get.back();
                        },
                      ),
                      const Expanded(
                        child: Text(
                          "House",
                          style: TextStyle(
                            fontSize: 20,
                            color: UI.object,
                          ),
                        ),
                      ),
                      GestureDetector(
                        // color: UI.foreground,
                        child: Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(13),
                            color: UI.foreground,
                          ),
                          child: const Icon(
                            Icons.search,
                            color: UI.action,
                          ),
                        ),
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: StreamBuilder(
                      stream: controller.getAllData(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.active) {
                          var getData = snapshot.data!.docs;
                          return ListView.builder(
                            itemCount: getData.length,
                            itemBuilder: (context, index) {
                              var d =
                                  getData[index].data() as Map<String, dynamic>;
                              return GestureDetector(
                                onTap: () {},
                                child: Column(
                                  children: [
                                    index == 0
                                        ? const SizedBox(height: 10)
                                        : const SizedBox(),
                                    Container(
                                      height: 275,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        // border: Border.all(),
                                        borderRadius: BorderRadius.circular(25),
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
                                              child: Image.network(
                                                "https://picsum.photos/id/${index}/200",
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 15,
                                              vertical: 5,
                                            ),
                                            child: Text(
                                              d['name'],
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  color: UI.object),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 15,
                                              vertical: 5,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              mainAxisSize: MainAxisSize.max,
                                              children: const [
                                                Icon(
                                                  Icons.location_on,
                                                  size: 20,
                                                  color: UI.action,
                                                ),
                                                SizedBox(width: 10),
                                                Text(
                                                  "Undipa",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: UI.object),
                                                ),
                                                Expanded(
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Icon(
                                                      Icons.favorite_outline,
                                                      color: UI.action,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                  ],
                                ),
                              );
                            },
                          );
                        }
                        return const Center(child: CircularProgressIndicator());
                      },
                    ),
                  ),
                ],
              ),
            ),
            Menu.menu(height, 2)
          ],
        ),
      ),
    );
  }
}
