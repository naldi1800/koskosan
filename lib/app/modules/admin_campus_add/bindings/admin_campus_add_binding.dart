import 'package:get/get.dart';

import '../controllers/admin_campus_add_controller.dart';

class AdminCampusAddBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminCampusAddController>(
      () => AdminCampusAddController(),
    );
  }
}
