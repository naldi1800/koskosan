import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/maps_campus_controller.dart';

class MapsCampusView extends GetView<MapsCampusController> {
  const MapsCampusView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MapsCampusView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'MapsCampusView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
