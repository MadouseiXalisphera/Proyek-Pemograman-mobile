import 'package:get/get.dart';

import '../../data/models/menu_item_model.dart';
import '../../data/services/menu_service.dart';
import '../../data/services/menu_stock_service.dart';

/// Controller layar Menu Stock (kitchen). Logika +100 / →0 ada di
/// MenuStockService; controller hanya menyalurkan aksi & menyiapkan data.
class MenuStockController extends GetxController {
  final MenuStockService _stock = Get.find<MenuStockService>();
  final MenuService _menu = Get.find<MenuService>();

  List<MenuItem> get menu => _menu.getAllMenu();
  RxMap<String, int> get stockMap => _stock.stock;

  int stockOf(String id) => _stock.stockOf(id);
  bool isAvailable(String id) => _stock.isAvailable(id);

  void add(String id) => _stock.addStock(id);
  void empty(String id) => _stock.emptyStock(id);
}
