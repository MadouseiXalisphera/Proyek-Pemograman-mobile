import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/gestures.dart';

import 'app/core/theme/app_theme.dart';
import 'app/data/repositories/proof_storage.dart';
import 'app/data/services/auth_service.dart';
import 'app/data/services/menu_service.dart';
import 'app/data/services/menu_stock_service.dart';
import 'app/data/services/order_service.dart';
import 'app/data/services/payment_settings_service.dart';
import 'app/modules/cart/cart_controller.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/data/services/order_api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final prefs = await SharedPreferences.getInstance();
  Get.put<SharedPreferences>(prefs, permanent: true);

  Get.put<AuthService>(AuthService(), permanent: true);
  Get.put<MenuService>(MenuService(), permanent: true);
  Get.put<CartController>(CartController(), permanent: true);
  Get.put<OrderService>(OrderService(), permanent: true);
  Get.put<PaymentSettingsService>(PaymentSettingsService(), permanent: true);
  Get.find<PaymentSettingsService>().load();
  Get.put<MenuStockService>(MenuStockService(), permanent: true);
  Get.put<OrderApiService>(OrderApiService(), permanent: true);
  Get.put<ProofStorage>(InMemoryProofStorage(), permanent: true);

  runApp(const CafeAmbaApp());
}

class CafeAmbaApp extends StatelessWidget {
  const CafeAmbaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Cafe Amba',
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 250),
      scrollBehavior: const _AppScrollBehavior(),
    );
  }
}

class _AppScrollBehavior extends MaterialScrollBehavior {
  const _AppScrollBehavior();

  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) =>
      child;

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
      };
}
