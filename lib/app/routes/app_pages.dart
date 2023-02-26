import 'package:get/get.dart';

import '../modules/ItemsList/bindings/items_list_binding.dart';
import '../modules/ItemsList/views/items_list_view.dart';
import '../modules/admin_campus/bindings/admin_campus_binding.dart';
import '../modules/admin_campus/views/admin_campus_view.dart';
import '../modules/admin_campus_add/bindings/admin_campus_add_binding.dart';
import '../modules/admin_campus_add/views/admin_campus_add_view.dart';
import '../modules/admin_campus_edit/bindings/admin_campus_edit_binding.dart';
import '../modules/admin_campus_edit/views/admin_campus_edit_view.dart';
import '../modules/admin_home/bindings/admin_home_binding.dart';
import '../modules/admin_home/views/admin_home_view.dart';
import '../modules/admin_kos/bindings/admin_kos_binding.dart';
import '../modules/admin_kos/views/admin_kos_view.dart';
import '../modules/admin_kos_add/bindings/admin_kos_add_binding.dart';
import '../modules/admin_kos_add/views/admin_kos_add_view.dart';
import '../modules/admin_kos_edit/bindings/admin_kos_edit_binding.dart';
import '../modules/admin_kos_edit/views/admin_kos_edit_view.dart';
import '../modules/galleryItem/bindings/gallery_item_binding.dart';
import '../modules/galleryItem/views/gallery_item_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/item_detail/bindings/item_detail_binding.dart';
import '../modules/item_detail/views/item_detail_view.dart';
import '../modules/item_favorite/bindings/item_favorite_binding.dart';
import '../modules/item_favorite/views/item_favorite_view.dart';
import '../modules/item_search/bindings/item_search_binding.dart';
import '../modules/item_search/views/item_search_view.dart';
import '../modules/list_campus/bindings/list_campus_binding.dart';
import '../modules/list_campus/views/list_campus_view.dart';
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
      page: () => LoginView(),
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
    GetPage(
      name: _Paths.LIST_CAMPUS,
      page: () => const ListCampusView(),
      binding: ListCampusBinding(),
    ),
    GetPage(
      name: _Paths.ITEM_FAVORITE,
      page: () => const ItemFavoriteView(),
      binding: ItemFavoriteBinding(),
    ),
    GetPage(
      name: _Paths.ITEM_SEARCH,
      page: () => const ItemSearchView(),
      binding: ItemSearchBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_HOME,
      page: () => AdminHomeView(),
      binding: AdminHomeBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_CAMPUS,
      page: () => const AdminCampusView(),
      binding: AdminCampusBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_CAMPUS_ADD,
      page: () => AdminCampusAddView(),
      binding: AdminCampusAddBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_KOS,
      page: () => const AdminKosView(),
      binding: AdminKosBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_KOS_ADD,
      page: () => const AdminKosAddView(),
      binding: AdminKosAddBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_CAMPUS_EDIT,
      page: () => const AdminCampusEditView(),
      binding: AdminCampusEditBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_KOS_EDIT,
      page: () => const AdminKosEditView(),
      binding: AdminKosEditBinding(),
    ),
  ];
}
