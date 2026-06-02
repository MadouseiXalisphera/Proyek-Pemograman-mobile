import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_sizes.dart';
import '../utils/responsive.dart';

/// Tombol counter besar dengan animasi scale press — pakai di DetailSheet.
class QuantityBig extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const QuantityBig({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.r(AppSizes.md),
        vertical: context.r(AppSizes.sm),
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(context.r(AppSizes.radiusLg)),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _BigBtn(icon: Icons.remove, onTap: onDecrement),
          SizedBox(width: context.r(AppSizes.xl)),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (c, a) => FadeTransition(opacity: a, child: c),
            child: Text(
              '$quantity',
              key: ValueKey(quantity),
              style: TextStyle(
                fontSize: context.rf(AppSizes.fontXxl),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(width: context.r(AppSizes.xl)),
          _BigBtn(icon: Icons.add, onTap: onIncrement),
        ],
      ),
    );
  }
}

class _BigBtn extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _BigBtn({required this.icon, required this.onTap});

  @override
  State<_BigBtn> createState() => _BigBtnState();
}

class _BigBtnState extends State<_BigBtn> {
  double _scale = 1;

  void _onTap() {
    setState(() => _scale = 0.85);
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) setState(() => _scale = 1);
    });
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: Container(
          width: context.r(48),
          height: context.r(48),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(context.r(AppSizes.radiusMd)),
          ),
          child: Icon(
            widget.icon,
            size: context.r(AppSizes.iconLg),
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}
