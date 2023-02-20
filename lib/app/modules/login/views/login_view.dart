import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:koskosan/app/Utils/UI.dart';
import 'package:koskosan/app/controller/Auth_Controller.dart';
import 'package:koskosan/app/routes/app_pages.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  LoginView({Key? key}) : super(key: key);
  var authC = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    var fontSize = 15.0;
    var borderRadius = 25.0;
    var borderInput = OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: const BorderSide(color: UI.borderInputColor),
    );
    var borderInputError = OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: const BorderSide(color: UI.borderInputColorError),
    );
    var borderInputSuccess = OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: const BorderSide(color: UI.borderInputColorSuccess),
    );
    return Scaffold(
      backgroundColor: UI.background,
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                    // color: UI.action,
                    height: 200,
                    width: 200,
                    child: Image.asset("assets/images/Icon.png")
                    // const Icon(
                    //   Icons.house,
                    //   size: 50,
                    // ),
                    ),
                const SizedBox(height: 25),
                const Text(
                  "Sign in to your account",
                  style: TextStyle(color: UI.object, fontSize: 20),
                ),
                const SizedBox(height: 25),
                SizedBox(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Email",
                              style: TextStyle(
                                  color: UI.object, fontSize: fontSize),
                            ),
                            Text(
                              "*",
                              style: TextStyle(
                                  color: Colors.red, fontSize: fontSize),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: controller.emailC,
                        style: const TextStyle(fontSize: 12, color: UI.object),
                        decoration: InputDecoration(
                          border: borderInput,
                          errorBorder: borderInputError,
                          focusedBorder: borderInputSuccess,
                          filled: true,
                          fillColor: UI.foreground,
                          prefixIcon: const Icon(
                            CupertinoIcons.person_fill,
                            color: UI.object,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                SizedBox(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Password",
                              style: TextStyle(
                                  color: UI.object, fontSize: fontSize),
                            ),
                            Text(
                              "*",
                              style: TextStyle(
                                  color: Colors.red, fontSize: fontSize),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      Obx(
                        () => TextFormField(
                          controller: controller.passC,
                          obscureText: controller.showPass.value,
                          style:
                              const TextStyle(fontSize: 12, color: UI.object),
                          decoration: InputDecoration(
                            border: borderInput,
                            errorBorder: borderInputError,
                            focusedBorder: borderInputSuccess,
                            filled: true,
                            fillColor: UI.foreground,
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: UI.object,
                            ),
                            suffix: GestureDetector(
                              onTap: () => controller.showPass.value =
                                  !controller.showPass.value,
                              child: Icon(
                                controller.showPass.value
                                    ? CupertinoIcons.eye_slash_fill
                                    : CupertinoIcons.eye_fill,
                                color: UI.object,
                              ),
                            ),
                          ),
                          // focusNode: FocusNode(),
                          // onChanged: ,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () => authC.login(
                    controller.emailC.text,
                    controller.passC.text,
                  ),
                  child: const Text("Sign In"),
                ),
                const SizedBox(height: 15),
                TextButton(
                  onPressed: () => Get.toNamed(Routes.HOME),
                  child: const Text(
                    "Kembali ke home",
                    style: TextStyle(
                      color: UI.action,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
