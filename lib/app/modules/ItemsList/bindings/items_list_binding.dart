import 'package:get/get.dart';

import '../controllers/items_list_controller.dart';

class ItemsListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ItemsListController>(
      () => ItemsListController(),
    );
  }
}
