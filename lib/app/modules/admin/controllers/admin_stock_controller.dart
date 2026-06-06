import 'package:get/get.dart';

// Model data untuk status stok menu
class MenuItemStock {
  final String name;
  var isAvailable = true.obs;

  MenuItemStock({required this.name, bool available = true}) {
    isAvailable.value = available;
  }
}

// Controller yang mengatur logika stok menu admin
class AdminStockController extends GetxController {
  // Data dummy sesuai menu di Figma
  var menuStocks = <MenuItemStock>[
    MenuItemStock(name: "Burger"),
    MenuItemStock(name: "Lemon Ice Tea"),
    MenuItemStock(name: "French Fries", available: false),
  ].obs;

  // Fungsi mengubah status ketersediaan secara real-time
  void toggleStock(int index) {
    menuStocks[index].isAvailable.value = !menuStocks[index].isAvailable.value;
  }
}