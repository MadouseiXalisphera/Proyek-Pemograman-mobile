import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/services/auth_service.dart';
import '../../routes/app_routes.dart';

// Middleware untuk route yang butuh login.
// Kalau belum ada session → redirect ke /login.

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final auth = Get.find<AuthService>();
    if (auth.currentUser == null) {
      return const RouteSettings(name: AppRoutes.login);
    }
    return null; // boleh akses
  }
}
