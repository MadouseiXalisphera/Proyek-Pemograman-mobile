import 'package:flutter/material.dart';

/// IndexedStack yang melakukan FADE halus tiap kali tab berganti, TANPA
/// kehilangan state tab (semua halaman tetap hidup, seperti IndexedStack biasa).
/// Dipakai di UserShell & KitchenShell agar perpindahan tab tidak "patah".
class FadeIndexedStack extends StatefulWidget {
  final int index;
  final List<Widget> children;
  final Duration duration;

  const FadeIndexedStack({
    super.key,
    required this.index,
    required this.children,
    this.duration = const Duration(milliseconds: 220),
  });

  @override
  State<FadeIndexedStack> createState() => _FadeIndexedStackState();
}

class _FadeIndexedStackState extends State<FadeIndexedStack>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: widget.duration,
  )..forward();

  late final Animation<double> _fade =
      CurvedAnimation(parent: _c, curve: Curves.easeOut);

  @override
  void didUpdateWidget(covariant FadeIndexedStack old) {
    super.didUpdateWidget(old);
    if (old.index != widget.index) {
      _c.forward(from: 0); // fade-in halaman baru tiap ganti tab
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: IndexedStack(index: widget.index, children: widget.children),
    );
  }
}
