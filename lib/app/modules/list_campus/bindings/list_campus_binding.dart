import 'package:get/get.dart';

import '../controllers/list_campus_controller.dart';

class ListCampusBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ListCampusController>(
      () => ListCampusController(),
    );
  }
}
