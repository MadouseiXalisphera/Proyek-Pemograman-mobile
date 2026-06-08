import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../core/constants/app_branding.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/entrance_animation.dart';
import 'splash_controller.dart';

// ════════════════════════════════════════════════════════════════════════
// SPLASH VIEW (Flutter, beranimasi) — RESPONSIF & sinkron dgn native splash.
//
// Kunci anti-"lompat": logo dirender PERSIS DI CENTER (sama dgn posisi logo
// native splash), sehingga saat native → Flutter tidak ada pergeseran. Logo
// TIDAK fade/scale dari 0 (biar identik dgn native di frame pertama). Yang
// fade-in hanya nama, tagline, dan spinner (memang tak ada di native).
//
// Ukuran dihitung PROPORSIONAL dari layar nyata (MediaQuery + LayoutBuilder),
// bukan bucket tetap — jadi menyesuaikan HP kecil/besar, tablet, & landscape.
// ════════════════════════════════════════════════════════════════════════

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      // Bg terang (#E4ECE7) → ikon status bar GELAP (Android & iOS).
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: AppColors.background,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: LayoutBuilder(
          builder: (context, c) {
            final media = MediaQuery.of(context);
            final Size screen = media.size;
            final double shortest = screen.shortestSide;
            final bool isTablet = shortest >= 600;
            final bool isLandscape = c.maxHeight < c.maxWidth;

            // ── Ukuran PROPORSIONAL (clamp agar aman di ekstrem) ──
            double logo = shortest * (isTablet ? 0.22 : 0.26);
            logo = logo.clamp(84.0, 200.0);
            if (isLandscape) logo = math.min(logo, c.maxHeight * 0.34);

            final double radius = logo * 0.27; // rasio sama dgn login/web
            final double iconSize = logo * 0.50;
            final double nameSize = (logo * 0.33).clamp(22.0, 46.0);
            final double tagSize = (logo * 0.145).clamp(12.0, 20.0);
            final double spinnerSize = (logo * 0.35).clamp(28.0, 56.0);
            final double stroke = (spinnerSize * 0.085).clamp(2.5, 5.0);

            final double gapLogoName = logo * 0.26;
            final double gapNameTag = logo * 0.05;

            // Posisi teks: tepat DI BAWAH logo yg di-center (logo tetap center
            // → sinkron native, tanpa lompatan).
            final double textTop = c.maxHeight / 2 + logo / 2 + gapLogoName;

            // Spinner di bawah, hormati home-indicator/notch bawah.
            final double bottomGap =
                (c.maxHeight * 0.07).clamp(20.0, 72.0) + media.padding.bottom;

            return Obx(
              () => AnimatedOpacity(
                opacity: controller.contentVisible.value ? 1.0 : 0.0,
                duration: SplashController.fadeOut,
                curve: Curves.easeOut,
                child: Stack(
                  children: [
                    // LOGO — center penuh (cocok native). TANPA fade/scale.
                    Center(
                      child: _LogoBox(
                        size: logo,
                        radius: radius,
                        iconSize: iconSize,
                      ),
                    ),

                    // NAMA + TAGLINE — di bawah logo, fade-up bertahap.
                    Positioned(
                      top: textTop,
                      left: 24,
                      right: 24,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          EntranceAnimation(
                            index: 1,
                            offsetY: logo * 0.12,
                            child: Text(
                              AppBranding.appName,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: nameSize,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.2,
                                height: 1.1,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          if (AppBranding.tagline.isNotEmpty) ...[
                            SizedBox(height: gapNameTag),
                            EntranceAnimation(
                              index: 2,
                              offsetY: logo * 0.10,
                              child: Text(
                                AppBranding.tagline,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: tagSize,
                                  fontWeight: FontWeight.w500,
                                  height: 1.2,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    // SPINNER — pinned bawah, hormati safe-area, fade-in.
                    Positioned(
                      bottom: bottomGap,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: EntranceAnimation(
                          index: 3,
                          offsetY: logo * 0.06,
                          child: _SplashSpinner(
                            size: spinnerSize,
                            stroke: stroke,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ── Logo kotak rounded + ikon (static, identik dgn native) ──────────────
class _LogoBox extends StatelessWidget {
  final double size;
  final double radius;
  final double iconSize;
  const _LogoBox({
    required this.size,
    required this.radius,
    required this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.primary, // #425440
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Icon(Icons.restaurant_menu, color: Colors.white, size: iconSize),
    );
  }
}

// ── Spinner ring (replika .spinner di splash.css) ───────────────────────
class _SplashSpinner extends StatefulWidget {
  final double size;
  final double stroke;
  const _SplashSpinner({required this.size, required this.stroke});

  @override
  State<_SplashSpinner> createState() => _SplashSpinnerState();
}

class _SplashSpinnerState extends State<_SplashSpinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900), // = splash-spin 0.9s
    )..repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _c,
        builder: (_, __) => CustomPaint(
          painter: _SpinnerPainter(turns: _c.value, stroke: widget.stroke),
        ),
      ),
    );
  }
}

class _SpinnerPainter extends CustomPainter {
  final double turns;
  final double stroke;
  _SpinnerPainter({required this.turns, required this.stroke});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - stroke) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..color = const Color.fromRGBO(66, 84, 64, 0.18);
    canvas.drawCircle(center, radius, track);

    final arc = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = stroke
      ..color = AppColors.primary;
    final double start = turns * 2 * math.pi;
    final double sweep = (5 / 6) * 2 * math.pi; // 300°
    canvas.drawArc(rect, start, sweep, false, arc);
  }

  @override
  bool shouldRepaint(covariant _SpinnerPainter old) =>
      old.turns != turns || old.stroke != stroke;
}
