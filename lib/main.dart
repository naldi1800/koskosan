// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init('USER_SETTINGS');
  runApp(
    GetMaterialApp(
      title: "Application",
      getPages: AppPages.routes,
      initialRoute: Routes.HOME,
      debugShowCheckedModeBanner: false,
      // routes: Routes.ITEMS_LIST,
    ),
  );
}
