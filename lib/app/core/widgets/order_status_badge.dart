import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_sizes.dart';
import '../utils/responsive.dart';

/// Pemetaan kunci status lifecycle (OrderModel.statusKey) → label + warna.
/// Satu sumber untuk seluruh sisi (user, admin, dll).
class OrderStatusView {
  final String label;
  final Color color;
  const OrderStatusView(this.label, this.color);

  static const Color _amber = Color(0xFFB8860B);

  static OrderStatusView of(String statusKey) {
    switch (statusKey) {
      case 'waiting_payment':
        return const OrderStatusView('Menunggu pembayaran', _amber);
      case 'waiting_confirmation':
        return const OrderStatusView('Menunggu verifikasi', _amber);
      case 'confirmed':
        return const OrderStatusView('Pesanan dikonfirmasi', AppColors.primary);
      case 'cooking':
        return const OrderStatusView('Sedang diproses', _amber);
      case 'ready':
        return const OrderStatusView('Siap diambil', AppColors.primary);
      case 'done':
        return const OrderStatusView('Selesai', AppColors.textSecondary);
      case 'cancelled':
        return const OrderStatusView('Dibatalkan', AppColors.danger);
      default:
        return const OrderStatusView('Menunggu', _amber);
    }
  }
}

/// Pill badge status untuk dipasang di kartu pesanan.
class StatusBadge extends StatelessWidget {
  final String statusKey;
  const StatusBadge({super.key, required this.statusKey});

  @override
  Widget build(BuildContext context) {
    final s = OrderStatusView.of(statusKey);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.r(AppSizes.md),
        vertical: context.r(AppSizes.xs),
      ),
      decoration: BoxDecoration(
        color: s.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(context.r(AppSizes.radiusFull)),
      ),
      child: Text(
        s.label,
        style: TextStyle(
          fontSize: context.rf(AppSizes.fontSm),
          fontWeight: FontWeight.w600,
          color: s.color,
        ),
      ),
    );
  }
}
