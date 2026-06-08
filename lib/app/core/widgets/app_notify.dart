import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme/app_colors.dart';
import '../theme/app_sizes.dart';
import '../utils/responsive.dart';

/// Notifikasi POPUP melayang dari POJOK KANAN ATAS (fade + slide-in),
/// menumpuk vertikal, auto-hilang. Menggantikan Get.snackbar (yang lebar-penuh
/// & turun dari atas). Font/warna/layout mengikuti ketentuan proyek (Inter,
/// AppColors, AppSizes).
///
/// Pakai:
///   AppNotify.show(title: 'Pesanan masuk', message: 'Meja A1 • 2 item');
class AppNotify {
  AppNotify._();

  static final ValueNotifier<List<_NotifyData>> _list =
      ValueNotifier<List<_NotifyData>>(<_NotifyData>[]);
  static OverlayEntry? _entry;
  static int _seq = 0;

  static void show({
    required String title,
    required String message,
    Color? color,
    IconData icon = Icons.notifications_active_outlined,
    Duration duration = const Duration(seconds: 4),
  }) {
    final ctx = Get.overlayContext;
    if (ctx == null) return;
    _ensureHost(ctx);

    final data = _NotifyData(
      id: ++_seq,
      title: title,
      message: message,
      color: color ?? AppColors.primary,
      icon: icon,
      duration: duration,
    );
    _list.value = [..._list.value, data];
  }

  static void _ensureHost(BuildContext ctx) {
    if (_entry != null) return;
    _entry = OverlayEntry(
      builder: (_) => Positioned(
        top: 0,
        right: 0,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ValueListenableBuilder<List<_NotifyData>>(
              valueListenable: _list,
              builder: (_, items, __) => Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for (final d in items)
                    _NotifyCard(
                      key: ValueKey(d.id),
                      data: d,
                      onDone: () => _remove(d.id),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    Overlay.of(ctx, rootOverlay: true).insert(_entry!);
  }

  static void _remove(int id) {
    _list.value = _list.value.where((e) => e.id != id).toList();
  }
}

class _NotifyData {
  final int id;
  final String title;
  final String message;
  final Color color;
  final IconData icon;
  final Duration duration;

  _NotifyData({
    required this.id,
    required this.title,
    required this.message,
    required this.color,
    required this.icon,
    required this.duration,
  });
}

class _NotifyCard extends StatefulWidget {
  final _NotifyData data;
  final VoidCallback onDone;

  const _NotifyCard({super.key, required this.data, required this.onDone});

  @override
  State<_NotifyCard> createState() => _NotifyCardState();
}

class _NotifyCardState extends State<_NotifyCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 280),
  );
  late final Animation<double> _fade =
      CurvedAnimation(parent: _c, curve: Curves.easeOut);
  late final Animation<Offset> _slide = Tween<Offset>(
    begin: const Offset(0.35, 0), // masuk dari kanan
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _c, curve: Curves.easeOutCubic));

  bool _leaving = false;

  @override
  void initState() {
    super.initState();
    _c.forward();
    Future.delayed(widget.data.duration, _dismiss);
  }

  Future<void> _dismiss() async {
    if (_leaving || !mounted) return;
    _leaving = true;
    await _c.reverse();
    if (mounted) widget.onDone();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.data;
    final maxW = MediaQuery.of(context).size.width - 32;
    final width = maxW < 340.0 ? maxW : 340.0;

    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: GestureDetector(
            onTap: _dismiss,
            child: Container(
              width: width,
              padding: EdgeInsets.all(context.r(AppSizes.md)),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius:
                    BorderRadius.circular(context.r(AppSizes.radiusLg)),
                border: Border.all(color: d.color.withValues(alpha: 0.35)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.10),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: context.r(36),
                    height: context.r(36),
                    decoration: BoxDecoration(
                      color: d.color.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(d.icon,
                        color: d.color, size: context.r(AppSizes.iconMd)),
                  ),
                  SizedBox(width: context.r(AppSizes.sm)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          d.title,
                          style: TextStyle(
                            fontSize: context.rf(AppSizes.fontMd),
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: context.r(2)),
                        Text(
                          d.message,
                          style: TextStyle(
                            fontSize: context.rf(AppSizes.fontSm),
                            color: AppColors.textSecondary,
                            height: 1.25,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
