import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:koskosan/app/Utils/UI.dart';
import 'package:koskosan/app/routes/app_pages.dart';

import '../controllers/admin_kos_controller.dart';

class AdminKosView extends GetView<AdminKosController> {
  const AdminKosView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Kos Kosan'),
      //   centerTitle: true,
      //   backgroundColor: UI.foreground,
      // ),
      backgroundColor: UI.background,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20 - 10,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: UI.action,
                    ),
                    onPressed: () {
                      Get.offAllNamed(Routes.ADMIN_HOME);
                    },
                  ),
                  const Expanded(
                    child: Text(
                      "Kos Kosan",
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
              child: StreamBuilder(
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
                                    middleTextStyle:
                                        TextStyle(color: UI.object),
                                    confirm: ElevatedButton(
                                      onPressed: () => controller.delete(id),
                                      style: const ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll(
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
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                          UI.foreground,
                                        ),
                                        shape: MaterialStatePropertyAll(
                                          RoundedRectangleBorder(
                                              side:
                                                  BorderSide(color: UI.action),
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
                              onTap: () => Get.toNamed(
                                Routes.ADMIN_KOS_EDIT,
                                arguments: id,
                              ),
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
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: UI.action,
        onPressed: () => Get.toNamed(Routes.ADMIN_KOS_ADD),
        child: const Icon(
          Icons.add,
          color: UI.object,
          size: 35,
        ),
      ),
    );
  }
}
