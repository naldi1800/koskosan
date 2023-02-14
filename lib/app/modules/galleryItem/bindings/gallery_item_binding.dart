import 'package:get/get.dart';

import '../controllers/gallery_item_controller.dart';

class GalleryItemBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GalleryItemController>(
      () => GalleryItemController(),
    );
  }
}
