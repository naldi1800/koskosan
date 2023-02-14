import 'package:get/get.dart';

import '../controllers/maps_campus_controller.dart';

class MapsCampusBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MapsCampusController>(
      () => MapsCampusController(),
    );
  }
}
