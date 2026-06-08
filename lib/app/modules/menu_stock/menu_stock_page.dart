import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/responsive_wrapper.dart';
import 'menu_stock_controller.dart';
import 'widgets/menu_stock_card.dart';

class MenuStockPage extends GetView<MenuStockController> {
  const MenuStockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ResponsiveWrapper(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(context.r(AppSizes.lg)),
              child: Text(
                'Menu Stock',
                style: TextStyle(
                  fontSize: context.rf(AppSizes.fontDisplay),
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Expanded(
              child: Obx(() {
                final menu = controller.menu;
                return ListView.builder(
                  padding: EdgeInsets.fromLTRB(context.r(AppSizes.lg), 0,
                      context.r(AppSizes.lg), context.r(AppSizes.lg)),
                  itemCount: menu.length,
                  itemBuilder: (_, i) {
                    final item = menu[i];
                    return MenuStockCard(
                      item: item,
                      stock: item.stock,
                      onAdd: () {
                        final qtyController = TextEditingController();

                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Tambah Stok'),
                            content: TextField(
                              controller: qtyController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: 'Masukkan jumlah stok',
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Batal'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  final qty =
                                      int.tryParse(qtyController.text) ?? 0;
                                  if (qty > 0) {
                                    controller.add(item.id, qty);
                                  }
                                  Navigator.pop(context);
                                },
                                child: const Text('Tambah'),
                              ),
                            ],
                          ),
                        );
                      },
                      onEmpty: () => controller.empty(item.id),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
