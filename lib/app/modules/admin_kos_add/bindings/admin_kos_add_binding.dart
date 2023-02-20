import 'package:get/get.dart';

import '../controllers/admin_kos_add_controller.dart';

class AdminKosAddBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminKosAddController>(
      () => AdminKosAddController(),
    );
  }
}
