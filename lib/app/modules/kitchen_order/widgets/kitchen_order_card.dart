import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/app_menu_image.dart';
import '../../../data/models/cart_item_model.dart';

/// Kartu item pesanan kitchen. Panel aksi kanan = 3 kondisi (animasi warna +
/// pergantian konten + umpan balik tekan):
///   confirm → "Confirm Order"   (tap → ready)
///   ready   → "Done"            (tap → done)  ← dulu ikon centang (✓)
///   done    → "Selesai" (muted, tidak bisa di-tap)
class KitchenOrderCard extends StatelessWidget {
  final CartItem item;
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
      height: context.r(112),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: radius),
      child: ClipRRect(
        borderRadius: radius,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: AppMenuImage(path: item.menuItem.fotoPath),
            ),
            Expanded(
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: context.r(AppSizes.lg)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.menuItem.nama,
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
                      'X${item.quantity}',
                      style: TextStyle(
                        fontSize: context.rf(AppSizes.fontMd),
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _ActionPanel(status: item.status, onAdvance: onAdvance),
          ],
        ),
      ),
    );
  }
}

class _ActionPanel extends StatefulWidget {
  final ItemStatus status;
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
    final isDone = widget.status == ItemStatus.done;
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
          width: context.r(118),
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
      case ItemStatus.confirm:
        return Text('Confirm\nOrder',
            key: const ValueKey('confirm'),
            textAlign: TextAlign.center,
            style: whiteBold);
      case ItemStatus.ready:
        // Dulu ikon centang (✓) → sekarang teks "Done".
        return Text('Done',
            key: const ValueKey('ready'),
            textAlign: TextAlign.center,
            style: whiteBold);
      case ItemStatus.done:
        return Text('Selesai',
            key: const ValueKey('done'),
            textAlign: TextAlign.center,
            style: whiteBold);
    }
  }
}
