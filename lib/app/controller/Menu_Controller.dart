import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:koskosan/app/Utils/UI.dart';

class Menu_Controller extends GetxController {
  Widget menu(height, int menuActive) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        height: height * 0.12,
        decoration: BoxDecoration(
          color: UI.background,
          border: Border.all(color: UI.foreground, width: 1),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              // onTap: to(1),
              child: menuItem(
                active: (menuActive == 1),
                icon: Icons.search,
              ),
            ),
            GestureDetector(
              // onTap: to(2),
              child: menuItem(
                active: (menuActive == 2),
                icon: Icons.home,
              ),
            ),
            GestureDetector(
              // onTap: to(3),
              child: menuItem(
                active: (menuActive == 3),
                icon: Icons.favorite,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container menuItem({
    required bool active,
    required IconData icon,
  }) {
    return Container(
      width: 55,
      height: 50,
      decoration: BoxDecoration(
        color: (active) ? UI.action : UI.foreground2,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Icon(
        icon,
        color: (active) ? UI.object : UI.action,
        size: 30,
      ),
    );
  }

  void to(int to) {
    print("Tombol: $to");

    // return;
    // switch (to) {
    //   case 1:
    //     Get.toNamed(Routes.ITEM_SEARCH);
    //     break;
    //   case 2:
    //     Get.toNamed(Routes.HOME);
    //     break;
    //   case 3:
    //     Get.toNamed(Routes.ITEM_FAVORITE);
    //     break;
    // }
  }
}
