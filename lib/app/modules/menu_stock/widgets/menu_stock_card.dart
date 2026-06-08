import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/app_menu_image.dart';
import '../../../data/models/menu_item_model.dart';

/// Kartu stok satu menu (mirip kartu menu pelanggan + tombol Add/Empty).
///  - Add   : +100 stok (hijau)
///  - Empty : set 0 (merah/danger)
///  - status: "Stock Ready (n)" bila >0, "Habis" bila 0.
class MenuStockCard extends StatelessWidget {
  final MenuItem item;
  final int stock;
  final VoidCallback onAdd;
  final VoidCallback onEmpty;

  const MenuStockCard({
    super.key,
    required this.item,
    required this.stock,
    required this.onAdd,
    required this.onEmpty,
  });

  @override
  Widget build(BuildContext context) {
    final available = stock > 0;
    final radius = BorderRadius.circular(context.r(AppSizes.radiusLg));

    print("MENU = ${item.nama}");
    print("IMAGE = ${item.fotoPath}");
    print("STOCK = $stock");

    return Container(
      margin: EdgeInsets.only(bottom: context.r(AppSizes.md)),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: radius),
      child: ClipRRect(
        borderRadius: radius,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: context.r(96),
                child: AppMenuImage(path: item.fotoPath),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(context.r(AppSizes.lg)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.nama,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: context.rf(AppSizes.fontLg),
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: context.r(AppSizes.xs)),
                      Text(
                        available ? 'Stock Ready ($stock)' : 'Habis',
                        style: TextStyle(
                          fontSize: context.rf(AppSizes.fontSm),
                          fontWeight: FontWeight.w600,
                          color: available
                              ? AppColors.textSecondary
                              : AppColors.danger,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Tombol Add / Empty bertumpuk
              Padding(
                padding: EdgeInsets.all(context.r(AppSizes.md)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _btn(context,
                        label: 'Add', color: AppColors.primary, onTap: onAdd),
                    SizedBox(height: context.r(AppSizes.sm)),
                    _btn(context,
                        label: 'Empty',
                        color: AppColors.danger,
                        onTap: onEmpty),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _btn(BuildContext context,
      {required String label,
      required Color color,
      required VoidCallback onTap}) {
    return SizedBox(
      width: context.r(120),
      height: context.r(AppSizes.tapTargetMd),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.r(AppSizes.radiusFull)),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: context.rf(AppSizes.fontMd),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
