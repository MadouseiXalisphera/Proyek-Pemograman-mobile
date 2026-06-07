import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../views/admin_dashboard_view.dart';
import '../views/admin_order_list_view.dart';
import '../views/admin_menu_stock_view.dart';

class AdminShellController extends GetxController {
  var selectedIndex = 0.obs;

  final List<Widget> pages = [
    AdminDashboardView(),
    AdminOrderListView(),
    AdminMenuStockView(),
    // Halaman Settings bisa ditambahkan di sini
    const Center(child: Text("Settings Admin")), 
  ];

  void changeTab(int index) {
    selectedIndex.value = index;
  }
}