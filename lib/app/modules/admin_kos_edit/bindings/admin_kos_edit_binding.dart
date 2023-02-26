import 'package:get/get.dart';

import '../controllers/admin_kos_edit_controller.dart';

class AdminKosEditBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminKosEditController>(
      () => AdminKosEditController(),
    );
  }
}
