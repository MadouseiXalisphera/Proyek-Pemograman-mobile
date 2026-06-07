import 'package:flutter/material.dart';

/// Bungkus widget apa pun agar mengecil halus saat ditekan (umpan balik tap).
/// Pakai untuk kartu menu, tombol kustom, tile, dll.
///
///   Pressable(onTap: () {...}, child: KartuMenu(...))
class Pressable extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double scale;
  final Duration duration;

  const Pressable({
    super.key,
    required this.child,
    this.onTap,
    this.scale = 0.96,
    this.duration = const Duration(milliseconds: 110),
  });

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  bool _down = false;

  void _set(bool v) {
    if (_down != v) setState(() => _down = v);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => _set(true),
      onTapUp: (_) => _set(false),
      onTapCancel: () => _set(false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _down ? widget.scale : 1.0,
        duration: widget.duration,
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
