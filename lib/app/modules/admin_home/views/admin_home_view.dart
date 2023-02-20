import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:koskosan/app/Utils/UI.dart';
import 'package:koskosan/app/controller/Auth_Controller.dart';
import 'package:koskosan/app/routes/app_pages.dart';

import '../controllers/admin_home_controller.dart';

class AdminHomeView extends GetView<AdminHomeController> {
  AdminHomeView({Key? key}) : super(key: key);

  var authC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Admin'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () => authC.logout(),
            )
          ],
          backgroundColor: UI.foreground,
        ),
        backgroundColor: UI.background,
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                height: 250,
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(25),
                  ),
                  color: UI.foreground,
                  boxShadow: [BoxShadow(color: UI.action)],
                ),
                child: Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          height: 150,
                          width: 150,
                          child: Image.asset(
                            "assets/images/Icon.png",
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Text(
                        "Total Kampus : ${controller.campus.value}",
                        style: const TextStyle(
                          color: UI.object,
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Total Kos kosan : ${controller.kos.value}",
                        style: const TextStyle(
                          color: UI.object,
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Manage",
                style: TextStyle(
                  color: UI.object,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Get.toNamed(
                        Routes.ADMIN_CAMPUS,
                      ),
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                          UI.action,
                        ),
                      ),
                      child: const SizedBox(
                        height: 50,
                        child: Center(
                          child: Text(
                            "Data Kampus",
                            style: TextStyle(
                              color: UI.object,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () =>Get.toNamed(Routes.ADMIN_KOS),
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                          UI.action,
                        ),
                      ),
                      child: const SizedBox(
                        height: 50,
                        child: Center(
                          child: Text(
                            "Data Kos Kosan",
                            style: TextStyle(
                              color: UI.object,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                  color: UI.foreground,
                  boxShadow: [BoxShadow(color: UI.action)],
                ),
                height: 50,
                width: double.infinity,
                child: const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "181143 | Rezky Zulfiana Thalya",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: UI.object,
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
