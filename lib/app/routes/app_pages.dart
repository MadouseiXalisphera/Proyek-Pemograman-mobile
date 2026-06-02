import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/middlewares/auth_middleware.dart';
import '../modules/cart/cart_binding.dart';
import '../modules/cart/cart_view.dart';
import '../modules/checkout/checkout_binding.dart';
import '../modules/checkout/checkout_view.dart';
import '../modules/home/home_binding.dart';
import '../modules/home/home_view.dart';
import '../modules/login/login_binding.dart';
import '../modules/login/login_view.dart';
import 'app_routes.dart';

abstract class AppPages {
  AppPages._();

  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
      middlewares: [AuthMiddleware()],
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.cart,
      page: () => const CartView(),
      binding: CartBinding(),
      middlewares: [AuthMiddleware()],
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.checkout,
      page: () => const CheckoutView(),
      binding: CheckoutBinding(),
      middlewares: [AuthMiddleware()],
      transition: Transition.rightToLeft,
    ),
    // Placeholder Fase 6 — akan diganti PaymentView nanti
    GetPage(
      name: AppRoutes.payment,
      page: () => Scaffold(
        appBar: AppBar(title: const Text('Pembayaran')),
        body: const Center(child: Text('Payment Page — Fase 6')),
      ),
      middlewares: [AuthMiddleware()],
      transition: Transition.rightToLeft,
    ),
  ];
}
