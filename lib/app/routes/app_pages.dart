import 'package:get/get.dart';

import '../core/middlewares/auth_middleware.dart';
import '../core/middlewares/role_middleware.dart';
import '../modules/checkout/checkout_binding.dart';
import '../modules/checkout/checkout_view.dart';
import '../modules/login/login_binding.dart';
import '../modules/login/login_view.dart';
import '../modules/logout_confirm/logout_confirm_binding.dart';
import '../modules/logout_confirm/logout_confirm_view.dart';
import '../modules/shell/admin_shell.dart';
import '../modules/shell/admin_shell_binding.dart';
import '../modules/shell/kitchen_shell.dart';
import '../modules/shell/kitchen_shell_binding.dart';
import '../modules/shell/user_shell.dart';
import '../modules/shell/user_shell_binding.dart';
import '../modules/splash/splash_binding.dart';
import '../modules/splash/splash_view.dart';
import 'app_routes.dart';

abstract class AppPages {
  AppPages._();

  static final List<GetPage> pages = [
    // ── Splash (entry) ────────────────────────────────────────────────
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
      transition: Transition.fadeIn,
    ),

    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
      transition: Transition.fadeIn,
    ),

    // ── Shell per role ────────────────────────────────────────────────
    GetPage(
      name: AppRoutes.userShell,
      page: () => const UserShell(),
      binding: UserShellBinding(),
      middlewares: [RoleMiddleware('user')],
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.kitchenShell,
      page: () => const KitchenShell(),
      binding: KitchenShellBinding(),
      middlewares: [RoleMiddleware('kitchen')],
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.adminShell,
      page: () => const AdminShell(),
      binding: AdminShellBinding(),
      middlewares: [RoleMiddleware('admin')],
      transition: Transition.fadeIn,
    ),

    // ── Route di atas shell ───────────────────────────────────────────
    GetPage(
      name: AppRoutes.checkout,
      page: () => const CheckoutView(),
      binding: CheckoutBinding(),
      middlewares: [AuthMiddleware()],
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.logoutConfirm,
      page: () => const LogoutConfirmView(),
      binding: LogoutConfirmBinding(),
      middlewares: [AuthMiddleware()],
      transition: Transition.rightToLeft,
    ),
  ];
}
