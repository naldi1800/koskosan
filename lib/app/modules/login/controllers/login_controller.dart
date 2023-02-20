import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  late TextEditingController emailC;
  late TextEditingController passC;
  var showPass = true.obs;

  @override
  void onInit() {
    super.onInit();
    emailC = TextEditingController(text: "koskosan.go@gmail.com");
    passC = TextEditingController(text: "12345678");
  }

  @override
  void onClose() {
    super.onClose();
    emailC.dispose();
    passC.dispose();
  }
}
