import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/utils/responsive.dart';

class KitchenOrderCard extends StatelessWidget {
  // Ubah dari CartItem menjadi Map JSON
  final Map<String, dynamic> item;
  final VoidCallback onAdvance;

  const KitchenOrderCard({
    super.key,
    required this.item,
    required this.onAdvance,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(context.r(AppSizes.radiusLg));
    return Container(
      margin: EdgeInsets.only(bottom: context.r(AppSizes.md)),
      height: context.r(110), // Fixed height agar rapi
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: radius),
      child: ClipRRect(
        borderRadius: radius,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Bagian Kiri: Tampilan Meja pengganti gambar
            Container(
              width: context.r(85),
              color: AppColors.primaryLight.withOpacity(0.3),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.table_restaurant, color: AppColors.primary),
                  Text('Meja',
                      style: TextStyle(fontSize: context.rf(AppSizes.fontSm))),
                  Text(
                    item['table_name'].toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: context.rf(AppSizes.fontDisplay),
                        color: AppColors.primary),
                  ),
                ],
              ),
            ),
            // Bagian Tengah: Detail Pesanan
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: context.r(AppSizes.md),
                    vertical: context.r(AppSizes.sm)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['menu_name'] ?? '-',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: context.rf(AppSizes.fontLg),
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: context.r(AppSizes.xs)),
                    Text(
                      'Qty: ${item['quantity']} | Cust: ${item['customer_name']}',
                      style: TextStyle(
                        fontSize: context.rf(AppSizes.fontMd),
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Bagian Kanan: Tombol Animasi
            _ActionPanel(
                status: item['status'].toString(), onAdvance: onAdvance),
          ],
        ),
      ),
    );
  }
}

class _ActionPanel extends StatefulWidget {
  final String status;
  final VoidCallback onAdvance;

  const _ActionPanel({required this.status, required this.onAdvance});

  @override
  State<_ActionPanel> createState() => _ActionPanelState();
}

class _ActionPanelState extends State<_ActionPanel> {
  bool _down = false;
  void _set(bool v) => setState(() => _down = v);

  @override
  Widget build(BuildContext context) {
    final isDone = widget.status == 'done';
    final bg = isDone ? AppColors.primaryLight : AppColors.primary;

    return GestureDetector(
      onTapDown: isDone ? null : (_) => _set(true),
      onTapUp: isDone ? null : (_) => _set(false),
      onTapCancel: isDone ? null : () => _set(false),
      onTap: isDone ? null : widget.onAdvance,
      child: AnimatedScale(
        scale: _down ? 0.94 : 1.0,
        duration: const Duration(milliseconds: 90),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          width: context.r(100),
          color: bg,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: context.r(AppSizes.sm)),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 240),
            transitionBuilder: (child, anim) => ScaleTransition(
              scale: CurvedAnimation(parent: anim, curve: Curves.easeOut),
              child: FadeTransition(opacity: anim, child: child),
            ),
            child: _content(context),
          ),
        ),
      ),
    );
  }

  Widget _content(BuildContext context) {
    final whiteBold = TextStyle(
      color: Colors.white,
      fontSize: context.rf(AppSizes.fontMd),
      fontWeight: FontWeight.w600,
      height: 1.2,
    );
    switch (widget.status) {
      case 'confirm':
        return Text('Confirm\nOrder',
            key: const ValueKey('confirm'),
            textAlign: TextAlign.center,
            style: whiteBold);
      case 'ready':
        return Text('Done',
            key: const ValueKey('ready'),
            textAlign: TextAlign.center,
            style: whiteBold);
      case 'done':
      default:
        return Text('Selesai',
            key: const ValueKey('done'),
            textAlign: TextAlign.center,
            style: whiteBold);
    }
  }
}
