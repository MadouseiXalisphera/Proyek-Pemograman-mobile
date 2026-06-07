import '../dummy_data.dart';
import '../models/menu_item_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/config/api_config.dart';

class MenuService {
  List<MenuItem> _menu = [];

  List<MenuItem> getAllMenu() {
    return _menu;
  }

  Future fetchMenu() async {
    final response = await http.get(
      Uri.parse(
        '${ApiConfig.baseUrl}/menu/get_all.php',
      ),
    );

    final data = jsonDecode(response.body);

    _menu = [];

    for (final item in data['data']) {
      _menu.add(
        MenuItem.fromJson(item),
      );
    }
  }

  List<MenuItem> getTopPicks() {
    return _menu.where((item) => item.isTopPick).toList();
  }

  MenuItem? getById(String id) {
    for (final item in _menu) {
      if (item.id == id) {
        return item;
      }
    }

    return null;
  }

  List<MenuItem> search(String query) {
    final q = query.toLowerCase();

    return _menu
        .where(
          (item) => item.nama.toLowerCase().contains(q),
        )
        .toList();
  }
}
