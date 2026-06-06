import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/services/auth_service.dart';
import '../../routes/app_routes.dart';

/// Middleware role-aware untuk route shell.
///
/// - Belum login → /login.
/// - Login tapi role tidak cocok dengan shell yang diminta → dialihkan ke
///   shell yang sesuai rolenya. Mencegah, misal, user kitchen membuka /user
///   secara manual (relevan terutama di web).
class RoleMiddleware extends GetMiddleware {
  final String requiredRole;
  RoleMiddleware(this.requiredRole);

  @override
  RouteSettings? redirect(String? route) {
    final user = Get.find<AuthService>().currentUser;
    if (user == null) {
      return const RouteSettings(name: AppRoutes.login);
    }
    if (user.role != requiredRole) {
      return RouteSettings(name: AppRoutes.shellForRole(user.role));
    }
    return null;
  }
}
