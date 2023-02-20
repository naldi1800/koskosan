import 'package:get/get.dart';

import '../controllers/item_favorite_controller.dart';

class ItemFavoriteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ItemFavoriteController>(
      () => ItemFavoriteController(),
    );
  }
}
