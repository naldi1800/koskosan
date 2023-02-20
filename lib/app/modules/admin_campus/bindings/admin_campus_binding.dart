import 'package:get/get.dart';

import '../controllers/admin_campus_controller.dart';

class AdminCampusBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminCampusController>(
      () => AdminCampusController(),
    );
  }
}
