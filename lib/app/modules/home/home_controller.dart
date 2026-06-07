import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/menu_item_model.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/menu_service.dart';
import '../../routes/app_routes.dart';

class HomeController extends GetxController {
  // 1. TextEditingController
  final TextEditingController searchC = TextEditingController();

  // 2. Dependencies
  final AuthService _auth = Get.find<AuthService>();
  final MenuService _menuService = Get.find<MenuService>();

  // 3. State observable
  final RxList<MenuItem> topPicks = <MenuItem>[].obs;
  final RxList<MenuItem> allMenu = <MenuItem>[].obs;
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;
  final RxString kategori = 'all'.obs; // 'all' | 'food' | 'drink'
  final RxString sortBy =
      'default'.obs; // 'default' | 'price_asc' | 'price_desc' | 'name_asc'

  // 3. Getter dari AuthService
  String get username => _auth.currentUser?.username ?? '-';
  String get namaMeja => _auth.currentUser?.namaMeja ?? '-';

  Future loadMenu() async {
    try {
      isLoading.value = true;

      await _menuService.fetchMenu();

      print("TOTAL MENU = ${_menuService.getAllMenu().length}");

      print("TOP PICK = ${_menuService.getTopPicks().length}");

      topPicks.assignAll(
        _menuService.getTopPicks(),
      );

      allMenu.assignAll(
        _menuService.getAllMenu(),
      );

      topPicks.assignAll(
        _menuService.getTopPicks(),
      );
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  // 4. Getter filteredMenu — 4 step manual
  List<MenuItem> get filteredMenu {
    // Step 1: filter kategori
    final List<MenuItem> afterKategori = <MenuItem>[];
    for (int i = 0; i < allMenu.length; i++) {
      if (kategori.value == 'all' || allMenu[i].kategori == kategori.value) {
        afterKategori.add(allMenu[i]);
      }
    }

    // Step 2: filter searchQuery
    final q = searchQuery.value.toLowerCase();
    final List<MenuItem> afterSearch = <MenuItem>[];
    for (int i = 0; i < afterKategori.length; i++) {
      if (q.isEmpty || afterKategori[i].nama.toLowerCase().contains(q)) {
        afterSearch.add(afterKategori[i]);
      }
    }

    // Step 3: sort
    if (sortBy.value != 'default') {
      afterSearch.sort((a, b) {
        if (sortBy.value == 'price_asc') return a.harga.compareTo(b.harga);
        if (sortBy.value == 'price_desc') return b.harga.compareTo(a.harga);
        if (sortBy.value == 'name_asc') return a.nama.compareTo(b.nama);
        return 0;
      });
    }

    return afterSearch;
  }

  // 5. Lifecycle
  @override
  @override
  void onInit() {
    super.onInit();
    loadMenu();
  }

  // 6. Methods
  void applyFilter(String kategoriBaru, String sortByBaru) {
    kategori.value = kategoriBaru;
    sortBy.value = sortByBaru;
  }

  void resetFilter() {
    kategori.value = 'all';
    sortBy.value = 'default';
  }

  void clearSearch() {
    searchQuery.value = '';
    searchC.clear();
  }

  Future<void> logout() async {
    await _auth.logout();
    Get.offAllNamed(AppRoutes.login);
  }

  @override
  void onClose() {
    searchC.dispose();
    super.onClose();
  }
}
