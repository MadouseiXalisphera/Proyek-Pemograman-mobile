import 'package:flutter/material.dart';

/// Animasi MASUK (fade + naik) untuk item daftar/grid. Beri [index] agar
/// muncul bertahap (staggered). Sekali jalan saat pertama dibangun.
///
///   EntranceAnimation(index: i, child: KartuMenu(...))
class EntranceAnimation extends StatelessWidget {
  final Widget child;
  final int index;
  final double offsetY;
  final Duration base;
  final Duration stagger;

  const EntranceAnimation({
    super.key,
    required this.child,
    this.index = 0,
    this.offsetY = 16,
    this.base = const Duration(milliseconds: 280),
    this.stagger = const Duration(milliseconds: 45),
  });

  @override
  Widget build(BuildContext context) {
    final total = base + stagger * index;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: total,
      curve: Curves.easeOut,
      builder: (_, t, c) => Opacity(
        opacity: t.clamp(0.0, 1.0),
        child: Transform.translate(
          offset: Offset(0, (1 - t) * offsetY),
          child: c,
        ),
      ),
      child: child,
    );
  }
}
