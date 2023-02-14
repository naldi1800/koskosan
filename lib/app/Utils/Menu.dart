import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:koskosan/app/Utils/UI.dart';

class Menu {
  static Widget menu(height, int menuActive) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        height: height * 0.12,
        decoration: BoxDecoration(
          color: UI.background,
          border: Border.all(color: UI.foreground, width: 1),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            menuItem(
              active: (menuActive == 1),
              icon: Icons.search,
            ),
            menuItem(
              active: (menuActive == 2),
              icon: Icons.home,
            ),
            menuItem(
              active: (menuActive == 3),
              icon: Icons.favorite,
            ),
          ],
        ),
      ),
    );
  }

  static Container menuItem({
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
}
