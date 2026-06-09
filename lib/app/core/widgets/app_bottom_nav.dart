import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_sizes.dart';
import '../utils/responsive.dart';

/// Satu item pada [AppBottomNav].
class NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const NavItem({
    required this.icon,
    required this.label,
    IconData? activeIcon,
  }) : activeIcon = activeIcon ?? icon;
}

/// Bottom navigation reusable (user/kitchen/admin) — versi BERANIMASI:
/// - ikon outlined↔filled berganti dgn efek scale (AnimatedSwitcher),
/// - warna ikon & teks transisi halus (AnimatedDefaultTextStyle / TweenColor),
/// - indikator garis bawah membesar/mengecil (AnimatedContainer),
/// - tab mengecil sedikit saat ditekan (AnimatedScale).
class AppBottomNav extends StatelessWidget {
  final List<NavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNav({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border, width: 1.5)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: context.r(72),
          child: Row(
            children: [
              for (int i = 0; i < items.length; i++)
                _Tab(
                  item: items[i],
                  isActive: i == currentIndex,
                  onTap: () => onTap(i),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Tab extends StatefulWidget {
  final NavItem item;
  final bool isActive;
  final VoidCallback onTap;

  const _Tab({required this.item, required this.isActive, required this.onTap});

  @override
  State<_Tab> createState() => _TabState();
}

class _TabState extends State<_Tab> {
  bool _down = false;
  void _set(bool v) => setState(() => _down = v);

  @override
  Widget build(BuildContext context) {
    final active = widget.isActive;
    const dur = Duration(milliseconds: 220);

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _set(true),
        onTapUp: (_) => _set(false),
        onTapCancel: () => _set(false),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _down ? 0.90 : 1.0,
          duration: const Duration(milliseconds: 90),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ikon: ganti outlined↔filled dgn pop scale + transisi warna.
              TweenAnimationBuilder<Color?>(
                tween: ColorTween(
                  end: active ? AppColors.primary : AppColors.primaryLight,
                ),
                duration: dur,
                builder: (_, color, __) => AnimatedSwitcher(
                  duration: dur,
                  transitionBuilder: (child, anim) =>
                      ScaleTransition(scale: anim, child: child),
                  child: Icon(
                    active ? widget.item.activeIcon : widget.item.icon,
                    key: ValueKey(active),
                    color: color,
                    size: context.r(AppSizes.iconLg),
                  ),
                ),
              ),
              SizedBox(height: context.r(2)),
              AnimatedDefaultTextStyle(
                duration: dur,
                style: TextStyle(
                  fontSize: context.rf(11),
                  fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                  color: active ? AppColors.primary : AppColors.primaryLight,
                ),
                child: Text(
                  widget.item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: context.r(4)),
              // Indikator garis bawah: lebar & opacity beranimasi.
              AnimatedContainer(
                duration: dur,
                curve: Curves.easeOut,
                height: 2,
                width: active ? context.r(AppSizes.iconLg) : 0,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
