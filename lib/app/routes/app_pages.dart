import 'package:get/get.dart';

import '../modules/ItemsList/bindings/items_list_binding.dart';
import '../modules/ItemsList/views/items_list_view.dart';
import '../modules/galleryItem/bindings/gallery_item_binding.dart';
import '../modules/galleryItem/views/gallery_item_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/item_detail/bindings/item_detail_binding.dart';
import '../modules/item_detail/views/item_detail_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/maps/bindings/maps_binding.dart';
import '../modules/maps/views/maps_view.dart';
import '../modules/maps_campus/bindings/maps_campus_binding.dart';
import '../modules/maps_campus/views/maps_campus_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.ITEMS_LIST,
      page: () => const ItemsListView(),
      binding: ItemsListBinding(),
    ),
    GetPage(
      arguments: "vzu14XPbovaxnQTkETA3",
      name: _Paths.ITEM_DETAIL,
      page: () => const ItemDetailView(),
      binding: ItemDetailBinding(),
    ),
    GetPage(
      name: _Paths.GALLERI_ITEM,
      page: () => const GalleryItemView(),
      binding: GalleryItemBinding(),
    ),
    GetPage(
      name: _Paths.MAPS,
      page: () => const MapsView(),
      binding: MapsBinding(),
    ),
    GetPage(
      name: _Paths.MAPS_CAMPUS,
      page: () => const MapsCampusView(),
      binding: MapsCampusBinding(),
    ),
  ];
}
