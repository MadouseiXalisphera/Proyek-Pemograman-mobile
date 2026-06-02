import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/utils/format.dart';
import '../../core/utils/responsive.dart';
import '../../data/models/cart_item_model.dart';
import '../../routes/app_routes.dart';
import 'cart_controller.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();

    return Container(
      color: AppColors.background,
      child: Center(
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(maxWidth: AppSizes.maxContentDesktop),
          child: Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.surface,
              elevation: 0,
              leading: IconButton(
                icon:
                    const Icon(Icons.arrow_back, color: AppColors.textPrimary),
                onPressed: () => Get.back(),
              ),
              title: Text(
                'Keranjang',
                style: TextStyle(
                  fontSize: context.rf(28),
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            body: Obx(() {
              if (cartController.items.isEmpty) {
                return _buildEmptyState(context);
              }
              return ListView.builder(
                padding: EdgeInsets.all(context.r(AppSizes.lg)),
                itemCount: cartController.items.length,
                itemBuilder: (context, index) {
                  final cartItem = cartController.items[index];
                  return _CartItemCard(
                    cartItem: cartItem,
                    onIncrement: () => cartController.increment(
                        cartItem.menuItem.id, cartItem.menuItem),
                    onDecrement: () =>
                        cartController.decrement(cartItem.menuItem.id),
                    onDelete: () => _showDeleteDialog(cartItem, cartController),
                  );
                },
              );
            }),
            bottomNavigationBar: Obx(() {
              if (cartController.items.isEmpty) return const SizedBox.shrink();
              return Container(
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  border: Border(
                    top: BorderSide(color: AppColors.border, width: 1.5),
                  ),
                ),
                padding: EdgeInsets.fromLTRB(
                  context.r(AppSizes.lg),
                  context.r(AppSizes.md),
                  context.r(AppSizes.lg),
                  context.r(AppSizes.md),
                ),
                child: SafeArea(
                  top: false,
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
                        height: context.r(43),
                        child: ElevatedButton(
                          onPressed: () => Get.toNamed(AppRoutes.checkout),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(context.r(AppSizes.md)),
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
                ),
              );
            }),
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
            onPressed: () => Get.back(),
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

  void _showDeleteDialog(CartItem cartItem, CartController cartController) {
    Get.defaultDialog(
      title: 'Hapus Item',
      middleText: 'Hapus ${cartItem.menuItem.nama} dari keranjang?',
      textCancel: 'Batal',
      textConfirm: 'Hapus',
      confirmTextColor: Colors.white,
      buttonColor: AppColors.error,
      cancelTextColor: AppColors.textSecondary,
      onConfirm: () {
        cartController.removeItem(cartItem.menuItem.id);
        Get.back();
      },
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
    final cart = Get.find<CartController>();

    return Container(
      margin: EdgeInsets.only(bottom: context.r(AppSizes.md)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(context.r(10)),
      ),
      padding: EdgeInsets.all(context.r(6)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Foto kiri
          ClipRRect(
            borderRadius: BorderRadius.circular(context.r(AppSizes.sm)),
            child: cartItem.menuItem.fotoPath != null
                ? Image.asset(
                    cartItem.menuItem.fotoPath!,
                    width: context.r(115),
                    height: context.r(115),
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _fotoPlaceholder(context),
                  )
                : _fotoPlaceholder(context),
          ),
          SizedBox(width: context.r(AppSizes.md)),
          // Detail kanan
          Expanded(
            child: SizedBox(
              height: context.r(115),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama + trash
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
                          padding: EdgeInsets.only(left: context.r(4)),
                          child: Icon(
                            Icons.delete_outline,
                            size: context.r(AppSizes.iconMd),
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: context.r(2)),
                  // Quantity label
                  Obx(() {
                    final qty = cart.getQuantity(cartItem.menuItem.id);
                    return Text(
                      '${qty}x',
                      style: TextStyle(
                        fontSize: context.rf(AppSizes.fontXs),
                        color: AppColors.textSecondary,
                      ),
                    );
                  }),
                  const Spacer(),
                  // Subtotal + qty control
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Subtotal dengan animasi
                      Obx(() {
                        final qty = cart.getQuantity(cartItem.menuItem.id);
                        final subtotal = cartItem.menuItem.harga * qty;
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          transitionBuilder: (child, animation) =>
                              FadeTransition(opacity: animation, child: child),
                          child: Text(
                            formatRupiah(subtotal),
                            key: ValueKey(subtotal),
                            style: TextStyle(
                              fontSize: context.rf(AppSizes.fontLg),
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        );
                      }),
                      // Qty control compact
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
                          SizedBox(width: context.r(6)),
                          Obx(() {
                            final qty = cart.getQuantity(cartItem.menuItem.id);
                            return AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              transitionBuilder: (child, animation) =>
                                  FadeTransition(
                                      opacity: animation, child: child),
                              child: Text(
                                '$qty',
                                key: ValueKey(qty),
                                style: TextStyle(
                                  fontSize: context.rf(AppSizes.fontMd),
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            );
                          }),
                          SizedBox(width: context.r(6)),
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
          ),
        ],
      ),
    );
  }

  Widget _fotoPlaceholder(BuildContext context) {
    return Container(
      width: context.r(115),
      height: context.r(115),
      color: AppColors.imagePlaceholder,
    );
  }
}
