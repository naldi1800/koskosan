import 'package:get/get.dart';

import '../controllers/admin_campus_edit_controller.dart';

class AdminCampusEditBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminCampusEditController>(
      () => AdminCampusEditController(),
    );
  }
}
