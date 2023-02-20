import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:koskosan/app/Utils/UI.dart';
import 'package:koskosan/app/routes/app_pages.dart';

import '../controllers/admin_campus_controller.dart';

class AdminCampusView extends GetView<AdminCampusController> {
  const AdminCampusView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kampus'),
        centerTitle: true,
        backgroundColor: UI.foreground,
      ),
      backgroundColor: UI.background,
      body: StreamBuilder(
        stream: controller.getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            var datas = snapshot.data!.docs;
            return ListView.builder(
              itemCount: datas.length,
              itemBuilder: (BuildContext context, int index) {
                var d = datas[index].data();
                var id = datas[index].id;
                return Padding(
                  padding: EdgeInsets.only(
                      left: 10, right: 10, top: (index == 0) ? 10 : 0),
                  child: Card(
                    color: UI.foreground,
                    child: ListTile(
                      title: Text(
                        d["name"],
                        style: TextStyle(
                          color: UI.object,
                          fontSize: 15,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          Get.defaultDialog(
                            backgroundColor: UI.foreground,
                            title: "Warning!!!",
                            middleText: "Delete this item?",
                            titleStyle: TextStyle(color: UI.object),
                            middleTextStyle: TextStyle(color: UI.object),
                            confirm: ElevatedButton(
                              onPressed: () => controller.delete(id),
                              style: const ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                  UI.action,
                                ),
                                shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                      // side: BorderSide(color: UI.action),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                ),
                              ),
                              child: const Text(
                                "Delete",
                                style: TextStyle(color: UI.object),
                              ),
                            ),
                            cancel: ElevatedButton(
                              onPressed: () => Get.back(),
                              style: const ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                  UI.foreground,
                                ),
                                shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                      side: BorderSide(color: UI.action),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                ),
                              ),
                              child: const Text(
                                "Cancel",
                                style: TextStyle(color: UI.object),
                              ),
                            ),
                          );
                        },
                      ),
                      onTap: () {},
                    ),
                  ),
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: UI.action,
        onPressed: () => Get.toNamed(Routes.ADMIN_CAMPUS_ADD),
        child: const Icon(
          Icons.add,
          color: UI.object,
          size: 35,
        ),
      ),
    );
  }

}
