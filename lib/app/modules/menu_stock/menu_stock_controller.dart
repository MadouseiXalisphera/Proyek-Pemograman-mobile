import 'package:get/get.dart';

import '../../data/models/menu_item_model.dart';
import '../../data/services/menu_service.dart';
import '../../data/services/menu_stock_service.dart';

/// Controller layar Menu Stock (kitchen). Logika +100 / →0 ada di
/// MenuStockService; controller hanya menyalurkan aksi & menyiapkan data.
class MenuStockController extends GetxController {
  final MenuStockService _stock = Get.find<MenuStockService>();

  final MenuService _menu = Get.find<MenuService>();

  final RxList<MenuItem> menu = <MenuItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadMenu();
  }

  Future<void> loadMenu() async {
    await _menu.fetchMenu();

    menu.assignAll(
      _menu.getAllMenu(),
    );
  }

  Future<void> add(String id, int qty) async {
    await _stock.addStock(id, qty);

    await loadMenu();
  }

  Future<void> empty(String id) async {
    await _stock.emptyStock(id);

    await loadMenu();
  }
}
