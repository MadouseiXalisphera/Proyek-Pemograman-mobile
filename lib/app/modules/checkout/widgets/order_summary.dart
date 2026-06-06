import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/utils/format.dart';
import '../../../core/utils/responsive.dart';
import '../../../data/models/cart_item_model.dart';

/// Ringkasan item + total pesanan di atas form checkout.
class OrderSummary extends StatelessWidget {
  final List<CartItem> items;
  final String totalFormatted;

  const OrderSummary({
    super.key,
    required this.items,
    required this.totalFormatted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final it in items)
          Padding(
            padding: EdgeInsets.only(bottom: context.r(6)),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${it.menuItem.nama} x${it.quantity}',
                    style: TextStyle(
                      fontSize: context.rf(AppSizes.fontMd),
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                Text(
                  formatRupiah(it.subtotal),
                  style: TextStyle(
                    fontSize: context.rf(AppSizes.fontMd),
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        SizedBox(height: context.r(AppSizes.sm)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total:',
              style: TextStyle(
                fontSize: context.rf(AppSizes.fontMd),
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              totalFormatted,
              style: TextStyle(
                fontSize: context.rf(AppSizes.fontMd),
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
