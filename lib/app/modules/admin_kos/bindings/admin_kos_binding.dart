import 'package:get/get.dart';

import '../controllers/admin_kos_controller.dart';

class AdminKosBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminKosController>(
      () => AdminKosController(),
    );
  }
}
