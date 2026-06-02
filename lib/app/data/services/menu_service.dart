import '../dummy_data.dart';
import '../models/menu_item_model.dart';

class MenuService {
  List<MenuItem> getAllMenu() {
    return DummyData.menu;
  }

  List<MenuItem> getTopPicks() {
    final result = <MenuItem>[];
    for (int i = 0; i < DummyData.menu.length; i++) {
      if (DummyData.menu[i].isTopPick) {
        result.add(DummyData.menu[i]);
      }
    }
    return result;
  }

  MenuItem? getById(String id) {
    for (int i = 0; i < DummyData.menu.length; i++) {
      if (DummyData.menu[i].id == id) return DummyData.menu[i];
    }
    return null;
  }

  List<MenuItem> search(String query) {
    final q = query.toLowerCase();
    final result = <MenuItem>[];
    for (int i = 0; i < DummyData.menu.length; i++) {
      if (DummyData.menu[i].nama.toLowerCase().contains(q)) {
        result.add(DummyData.menu[i]);
      }
    }
    return result;
  }
}
