import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_sizes.dart';
import '../utils/responsive.dart';

/// Tombol counter kompak berbentuk pill — pakai di card Home dan Cart.
class QuantityPill extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const QuantityPill({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.r(40),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(context.r(AppSizes.radiusFull)),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: onDecrement,
            borderRadius: BorderRadius.circular(context.r(AppSizes.radiusFull)),
            child: SizedBox(
              width: context.r(40),
              height: context.r(40),
              child: Icon(
                Icons.remove,
                size: context.r(AppSizes.iconMd),
                color: AppColors.primary,
              ),
            ),
          ),
          SizedBox(
            width: context.r(32),
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (c, a) =>
                    FadeTransition(opacity: a, child: c),
                child: Text(
                  '$quantity',
                  key: ValueKey(quantity),
                  style: TextStyle(
                    fontSize: context.rf(AppSizes.fontLg),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: onIncrement,
            borderRadius: BorderRadius.circular(context.r(AppSizes.radiusFull)),
            child: SizedBox(
              width: context.r(40),
              height: context.r(40),
              child: Icon(
                Icons.add,
                size: context.r(AppSizes.iconMd),
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
