import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/utils/format.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/order_status_badge.dart';
import '../../core/widgets/responsive_wrapper.dart';
import '../../data/models/cart_item_model.dart';
import '../../data/models/order_model.dart';
import 'kitchen_history_controller.dart';

/// Tab RIWAYAT (kitchen): daftar pesanan yang sudah dibayar, bisa di-expand
/// untuk melihat rincian item + status tiap item. Tiap kartu menampilkan
/// NOMOR PESANAN agar mudah dilacak. Animasi expand/collapse memakai
/// AnimatedRotation (ikon panah) + AnimatedSize (isi).
class KitchenHistoryPage extends GetView<KitchenHistoryController> {
  const KitchenHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ResponsiveWrapper(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                context.r(AppSizes.lg),
                context.r(AppSizes.lg),
                context.r(AppSizes.lg),
                context.r(AppSizes.sm),
              ),
              child: Text(
                'Riwayat',
                style: TextStyle(
                  fontSize: context.rf(AppSizes.fontDisplay),
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Expanded(
              child: Obx(() {
                final data = controller.history;
                if (data.isEmpty) return _empty(context);
                return ListView.separated(
                  padding: EdgeInsets.fromLTRB(
                    context.r(AppSizes.lg),
                    0,
                    context.r(AppSizes.lg),
                    context.r(AppSizes.lg),
                  ),
                  itemCount: data.length,
                  itemBuilder: (_, i) => _HistoryCard(order: data[i]),
                  separatorBuilder: (_, __) =>
                      SizedBox(height: context.r(AppSizes.md)),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _empty(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.history,
              size: context.r(72), color: AppColors.primaryLight),
          SizedBox(height: context.r(AppSizes.md)),
          Text(
            'Belum ada riwayat pesanan',
            style: TextStyle(
              fontSize: context.rf(AppSizes.fontMd),
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryCard extends StatefulWidget {
  final OrderModel order;
  const _HistoryCard({required this.order});

  @override
  State<_HistoryCard> createState() => _HistoryCardState();
}

class _HistoryCardState extends State<_HistoryCard> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final o = widget.order;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(context.r(AppSizes.radiusLg)),
        border: Border.all(color: AppColors.border, width: 1.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _open = !_open),
            child: Padding(
              padding: EdgeInsets.all(context.r(AppSizes.lg)),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // NOMOR PESANAN + meja
                        Text(
                          'Pesanan ${o.displayNo} · ${o.namaMeja}',
                          style: TextStyle(
                            fontSize: context.rf(AppSizes.fontLg),
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: context.r(2)),
                        Text(
                          '${_time(o.createdAt)} · ${o.items.length} item · ${formatRupiah(o.totalHarga)}',
                          style: TextStyle(
                            fontSize: context.rf(AppSizes.fontSm),
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  StatusBadge(statusKey: o.statusKey),
                  SizedBox(width: context.r(AppSizes.sm)),
                  AnimatedRotation(
                    turns: _open ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(Icons.expand_more,
                        color: AppColors.textSecondary,
                        size: context.r(AppSizes.iconLg)),
                  ),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 220),
            alignment: Alignment.topCenter,
            curve: Curves.easeInOut,
            child: _open
                ? _detail(context, o)
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }

  Widget _detail(BuildContext context, OrderModel o) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.r(AppSizes.lg),
        0,
        context.r(AppSizes.lg),
        context.r(AppSizes.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(color: AppColors.border, height: 1),
          SizedBox(height: context.r(AppSizes.md)),
          Text(
            '${o.namaPemesan} · ${paymentMethodLabel(o.paymentMethod)}',
            style: TextStyle(
              fontSize: context.rf(AppSizes.fontSm),
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: context.r(AppSizes.sm)),
          for (final item in o.items) _itemRow(context, item),
        ],
      ),
    );
  }

  Widget _itemRow(BuildContext context, CartItem item) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.r(4)),
      child: Row(
        children: [
          _itemDot(item.status),
          SizedBox(width: context.r(AppSizes.sm)),
          Expanded(
            child: Text(
              '${item.menuItem.nama} x${item.quantity}',
              style: TextStyle(
                fontSize: context.rf(AppSizes.fontMd),
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Text(
            _itemStatusLabel(item.status),
            style: TextStyle(
              fontSize: context.rf(AppSizes.fontSm),
              fontWeight: FontWeight.w600,
              color: _itemStatusColor(item.status),
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemDot(ItemStatus s) => Container(
        width: 8,
        height: 8,
        decoration:
            BoxDecoration(color: _itemStatusColor(s), shape: BoxShape.circle),
      );

  String _itemStatusLabel(ItemStatus s) {
    switch (s) {
      case ItemStatus.confirm:
        return 'Menunggu';
      case ItemStatus.ready:
        return 'Siap';
      case ItemStatus.done:
        return 'Selesai';
    }
  }

  Color _itemStatusColor(ItemStatus s) {
    switch (s) {
      case ItemStatus.confirm:
        return const Color(0xFFB8860B);
      case ItemStatus.ready:
        return AppColors.primary;
      case ItemStatus.done:
        return AppColors.textSecondary;
    }
  }

  String _time(DateTime t) {
    String two(int n) => n < 10 ? '0$n' : '$n';
    return '${two(t.hour)}:${two(t.minute)}';
  }
}
