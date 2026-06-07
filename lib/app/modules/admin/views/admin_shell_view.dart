import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/admin_shell_controller.dart';

class AdminShellView extends GetView<AdminShellController> {
  // Perbaikan: mengubah {Key? key} : super(key: key) menjadi format ringkas super.key
  const AdminShellView({super.key});

  @override
  Widget build(BuildContext context) {
    final AdminShellController c = Get.put(AdminShellController());

    return Scaffold(
      body: Obx(() => c.pages[c.selectedIndex.value]),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: c.selectedIndex.value,
          onTap: c.changeTab,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF3A5A40),
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
            BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Orders'),
            BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Stock'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
          ],
        ),
      ),
    );
  }
}