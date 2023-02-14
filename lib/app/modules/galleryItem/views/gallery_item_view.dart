import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:koskosan/app/Utils/UI.dart';

import '../controllers/gallery_item_controller.dart';

class GalleryItemView extends GetView<GalleryItemController> {
  const GalleryItemView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    controller.getDataImage(Get.arguments);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        shadowColor: Colors.transparent,
        title: const Text(
          'Gallery',
          style: TextStyle(
            fontSize: 20,
            color: UI.object,
          ),
        ),
        centerTitle: false,
        backgroundColor: UI.background,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: UI.action,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      backgroundColor: UI.background,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: Obx(
            () => Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: (controller.galeryLenght.value > 0)
                      ? GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          children: List.generate(
                            controller.galery.length,
                            (index) =>
                                galleryView(controller.galery[index].value),
                          ),)
                      : const Text(
                          "No Image",
                          style: TextStyle(
                            color: UI.object,
                            fontSize: 15,
                          ),
                        ),
                ),
                ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ButtonStyle(
                    shape: MaterialStatePropertyAll(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: const BorderSide(
                            color: UI.action,
                            width: 2.0,
                          )),
                    ),
                    backgroundColor: const MaterialStatePropertyAll(
                      UI.background,
                    ),
                  ),
                  child: Container(
                    height: 53,
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.arrow_back,
                          color: UI.action,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          "Back",
                          style: TextStyle(
                            fontSize: 20,
                            color: UI.action,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget galleryView(Uint8List image) {
    return Container(
      height: 40,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
        color: UI.foreground,
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
        child: Image.memory(
          image,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
