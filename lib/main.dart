import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/gestures.dart';

import 'app/core/theme/app_theme.dart';
import 'app/data/services/auth_service.dart';
import 'app/data/services/menu_service.dart';
import 'app/data/services/order_service.dart';
import 'app/modules/cart/cart_controller.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Force portrait orientation (tablet di meja biasanya portrait)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // 1. Init SharedPreferences sebagai dependency global
  final prefs = await SharedPreferences.getInstance();
  Get.put<SharedPreferences>(prefs, permanent: true);

  // 2. Init AuthService global (permanent: true biar tidak di-dispose)
  Get.put<AuthService>(AuthService(), permanent: true);

  // 3. Init services global lainnya
  Get.put<MenuService>(MenuService(), permanent: true);
  Get.put<CartController>(CartController(), permanent: true);
  Get.put<OrderService>(OrderService(), permanent: true);

  // 4. Cek apakah sudah ada session login sebelumnya
  final auth = Get.find<AuthService>();
  final isLoggedIn = await auth.checkSession();

  runApp(
      CafeAmbaApp(initialRoute: isLoggedIn ? AppRoutes.home : AppRoutes.login));
}

class CafeAmbaApp extends StatelessWidget {
  final String initialRoute;
  const CafeAmbaApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Cafe Amba',
      theme: AppTheme.lightTheme,
      initialRoute: initialRoute,
      getPages: AppPages.pages,
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 250),
      // Fix Issue 1: hide scrollbar default Flutter web supaya tidak
      // muncul di dalam wrapper. User tetap bisa scroll pakai mouse
      // wheel, trackpad, touch, atau keyboard.
      scrollBehavior: const _AppScrollBehavior(),
    );
  }
}

/// Scroll behavior global app:
/// - Hide scrollbar di web (supaya tidak muncul di edge ResponsiveWrapper)
/// - Tetap support scroll via mouse wheel, touch, trackpad, keyboard
/// - Drag dengan mouse di area scrollable (untuk web)
class _AppScrollBehavior extends MaterialScrollBehavior {
  const _AppScrollBehavior();

  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    // Tidak render scrollbar di semua platform
    return child;
  }

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
      };
}
