import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/utils/format.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/app_menu_image.dart';
import '../../core/widgets/confirm_clear_dialog.dart';
import '../../data/models/cart_item_model.dart';
import '../../routes/app_routes.dart';
import '../shell/user_shell_controller.dart';
import 'cart_controller.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();

    // Tab body-only: judul in-body, list di tengah, bar total+confirm di
    // bawah (di atas bottom nav shell). Tidak ada AppBar / tombol back.
    return Container(
      color: AppColors.background,
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(maxWidth: AppSizes.maxContentDesktop),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    context.r(AppSizes.lg),
                    context.r(AppSizes.lg),
                    context.r(AppSizes.lg),
                    context.r(AppSizes.sm),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Keranjang',
                          style: TextStyle(
                            fontSize: context.rf(AppSizes.fontDisplay),
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      Obx(() {
                        if (cartController.items.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        return TextButton.icon(
                          onPressed: () => showClearAllDialog(
                            onConfirm: cartController.clearCart,
                          ),
                          icon: Icon(Icons.delete_outline,
                              size: context.r(18), color: AppColors.danger),
                          label: Text(
                            'Hapus semua',
                            style: TextStyle(
                              fontSize: context.rf(AppSizes.fontSm),
                              color: AppColors.danger,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                Expanded(
                  child: Obx(() {
                    if (cartController.items.isEmpty) {
                      return _buildEmptyState(context);
                    }
                    return ListView.builder(
                      padding: EdgeInsets.fromLTRB(
                        context.r(AppSizes.lg),
                        0,
                        context.r(AppSizes.lg),
                        context.r(AppSizes.lg),
                      ),
                      itemCount: cartController.items.length,
                      itemBuilder: (context, index) {
                        final cartItem = cartController.items[index];
                        return _CartItemCard(
                          cartItem: cartItem,
                          onIncrement: () => cartController.incrementAt(index),
                          onDecrement: () => cartController.decrementAt(index),
                          onDelete: () => showClearAllDialog(
                            title: 'Hapus Item',
                            message:
                                'Hapus ${cartItem.menuItem.nama} dari keranjang?',
                            confirmLabel: 'Hapus',
                            onConfirm: () => cartController.removeAt(index),
                          ),
                        );
                      },
                    );
                  }),
                ),
                Obx(() {
                  if (cartController.items.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return Container(
                    decoration: const BoxDecoration(
                      color: AppColors.surface,
                      border: Border(
                        top: BorderSide(color: AppColors.border, width: 1.5),
                      ),
                    ),
                    padding: EdgeInsets.all(context.r(AppSizes.lg)),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Total:',
                                style: TextStyle(
                                  fontSize: context.rf(AppSizes.fontMd),
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 250),
                                transitionBuilder: (child, animation) =>
                                    FadeTransition(
                                        opacity: animation, child: child),
                                child: Text(
                                  cartController.totalHargaFormatted,
                                  key: ValueKey(cartController.totalHarga),
                                  style: TextStyle(
                                    fontSize: context.rf(AppSizes.fontXxl),
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: context.r(140),
                          height: context.r(AppSizes.tapTargetMd),
                          child: ElevatedButton(
                            onPressed: () => Get.toNamed(AppRoutes.checkout),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    context.r(AppSizes.md)),
                              ),
                            ),
                            child: const Text(
                              'Confirm Order',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: context.r(80),
            color: AppColors.primaryLight,
          ),
          SizedBox(height: context.r(AppSizes.lg)),
          Text(
            'Keranjang masih kosong',
            style: TextStyle(
              fontSize: context.rf(AppSizes.fontLg),
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: context.r(AppSizes.xl)),
          OutlinedButton(
            onPressed: () => Get.find<UserShellController>().goToHome(),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              padding: EdgeInsets.symmetric(
                horizontal: context.r(AppSizes.xl),
                vertical: context.r(AppSizes.md),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(context.r(AppSizes.md)),
              ),
            ),
            child: const Text('Lihat Menu'),
          ),
        ],
      ),
    );
  }
}

class _CartItemCard extends StatelessWidget {
  final CartItem cartItem;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onDelete;

  const _CartItemCard({
    required this.cartItem,
    required this.onIncrement,
    required this.onDecrement,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: context.r(AppSizes.md)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(context.r(10)),
      ),
      padding: EdgeInsets.all(context.r(8)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppMenuImage(
            path: cartItem.menuItem.fotoPath,
            width: context.r(96),
            height: context.r(96),
            borderRadius: BorderRadius.circular(context.r(AppSizes.sm)),
          ),
          SizedBox(width: context.r(AppSizes.md)),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        cartItem.menuItem.nama,
                        style: TextStyle(
                          fontSize: context.rf(AppSizes.fontLg),
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    GestureDetector(
                      onTap: onDelete,
                      child: Padding(
                        padding: EdgeInsets.only(left: context.r(AppSizes.sm)),
                        child: Icon(
                          Icons.delete_outline,
                          size: context.r(AppSizes.iconLg),
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                // Catatan per-baris (kalau ada)
                if (cartItem.catatan.isNotEmpty) ...[
                  SizedBox(height: context.r(2)),
                  Text(
                    'Catatan: ${cartItem.catatan}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: context.rf(AppSizes.fontXs),
                      fontStyle: FontStyle.italic,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
                SizedBox(height: context.r(AppSizes.sm)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      transitionBuilder: (child, animation) =>
                          FadeTransition(opacity: animation, child: child),
                      child: Text(
                        formatRupiah(cartItem.subtotal),
                        key: ValueKey(cartItem.subtotal),
                        style: TextStyle(
                          fontSize: context.rf(AppSizes.fontLg),
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: onDecrement,
                          child: Icon(
                            Icons.remove_circle_outline,
                            size: context.r(AppSizes.iconLg),
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(width: context.r(AppSizes.sm)),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          transitionBuilder: (child, animation) =>
                              FadeTransition(opacity: animation, child: child),
                          child: Text(
                            '${cartItem.quantity}',
                            key: ValueKey(cartItem.quantity),
                            style: TextStyle(
                              fontSize: context.rf(AppSizes.fontMd),
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        SizedBox(width: context.r(AppSizes.sm)),
                        GestureDetector(
                          onTap: onIncrement,
                          child: Icon(
                            Icons.add_circle_outline,
                            size: context.r(AppSizes.iconLg),
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
