import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/app_menu_image.dart';
import '../../../data/models/cart_item_model.dart';

/// Kartu satu item pesanan di layar kitchen (Image 3 & 4).
/// Panel hijau kanan menampilkan kondisi sesuai [item.status] dan, saat di-tap,
/// memanggil [onAdvance] untuk maju ke kondisi berikutnya.
///   confirm → teks "Confirm Order"   (tap → ready)
///   ready   → ikon centang (✓)        (tap → done)
///   done    → teks "Selesai" (muted, tidak bisa di-tap)
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
            // Foto kiri (persegi setinggi kartu)
            AspectRatio(
              aspectRatio: 1,
              child: AppMenuImage(path: item.menuItem.fotoPath),
            ),
            // Tengah: nama + jumlah
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: context.r(AppSizes.lg)),
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
            // Panel aksi kanan
            _ActionPanel(status: item.status, onAdvance: onAdvance),
          ],
        ),
      ),
    );
  }
}

class _ActionPanel extends StatelessWidget {
  final ItemStatus status;
  final VoidCallback onAdvance;

  const _ActionPanel({required this.status, required this.onAdvance});

  @override
  Widget build(BuildContext context) {
    final isDone = status == ItemStatus.done;
    final bg = isDone ? AppColors.primaryLight : AppColors.primary;

    return GestureDetector(
      onTap: isDone ? null : onAdvance,
      child: Container(
        width: context.r(118),
        color: bg,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: context.r(AppSizes.sm)),
        child: _content(context),
      ),
    );
  }

  Widget _content(BuildContext context) {
    switch (status) {
      case ItemStatus.confirm:
        return Text(
          'Confirm\nOrder',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: context.rf(AppSizes.fontMd),
            fontWeight: FontWeight.w600,
            height: 1.2,
          ),
        );
      case ItemStatus.ready:
        return Icon(Icons.check, color: Colors.white, size: context.r(40));
      case ItemStatus.done:
        return Text(
          'Selesai',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: context.rf(AppSizes.fontMd),
            fontWeight: FontWeight.w600,
          ),
        );
    }
  }
}
