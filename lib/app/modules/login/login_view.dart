import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/responsive_wrapper.dart';
import 'login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LoginResponsiveWrapper(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: context.r(AppSizes.xl)),
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: context.r(64)),

                  // ============ LOGO ============
                  Center(
                    child: Container(
                      width: context.r(88),
                      height: context.r(88),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(context.r(24)),
                      ),
                      child: Icon(
                        Icons.restaurant_menu,
                        color: Colors.white,
                        size: context.r(44),
                      ),
                    ),
                  ),
                  SizedBox(height: context.r(AppSizes.xxl)),

                  // ============ TITLE ============
                  Text(
                    'Selamat Datang',
                    style: TextStyle(
                      fontSize: context.rf(28),
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: context.r(6)),
                  Text(
                    'Login untuk mulai memesan',
                    style: TextStyle(
                      fontSize: context.rf(AppSizes.fontMd),
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: context.r(40)),

                  // ============ USERNAME ============
                  const _FieldLabel('Username'),
                  TextFormField(
                    controller: controller.usernameC,
                    validator: controller.validateUsername,
                    textInputAction: TextInputAction.next,
                    autocorrect: false,
                    enableSuggestions: false,
                    style: TextStyle(fontSize: context.rf(AppSizes.fontMd)),
                    decoration: _decoration(
                      context: context,
                      hint: 'Masukkan username',
                      icon: Icons.person_outline,
                    ),
                  ),
                  SizedBox(height: context.r(20)),

                  // ============ PASSWORD ============
                  const _FieldLabel('Password'),
                  Obx(() {
                    return TextFormField(
                      controller: controller.passwordC,
                      validator: controller.validatePassword,
                      obscureText: controller.obscurePassword.value,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => controller.submit(),
                      style: TextStyle(fontSize: context.rf(AppSizes.fontMd)),
                      decoration: _decoration(
                        context: context,
                        hint: 'Masukkan password',
                        icon: Icons.lock_outline,
                        suffix: IconButton(
                          onPressed: controller.toggleObscure,
                          icon: Icon(
                            controller.obscurePassword.value
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.textSecondary,
                            size: context.r(22),
                          ),
                        ),
                      ),
                    );
                  }),
                  SizedBox(height: context.r(36)),

                  // ============ TOMBOL LOGIN ============
                  Obx(() {
                    final loading = controller.isLoading.value;
                    return SizedBox(
                      width: double.infinity,
                      height: context.r(AppSizes.tapTargetLg),
                      child: ElevatedButton(
                        onPressed: loading ? null : controller.submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor:
                              AppColors.primary.withValues(alpha: 0.6),
                          disabledForegroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                context.r(AppSizes.radiusLg)),
                          ),
                        ),
                        child: loading
                            ? SizedBox(
                                width: context.r(22),
                                height: context.r(22),
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: context.rf(AppSizes.fontLg),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    );
                  }),
                  SizedBox(height: context.r(AppSizes.xl)),

                  // ============ INFO BAWAH ============
                  Center(
                    child: Text(
                      'Hubungi kasir jika ada masalah login',
                      style: TextStyle(
                        fontSize: context.rf(AppSizes.fontSm),
                        color: AppColors.textSecondary.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                  SizedBox(height: context.r(AppSizes.xl)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _decoration({
    required BuildContext context,
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    // FIX issue icon mepet ke border:
    // - Tambah margin di prefixIcon dengan Padding
    // - Atur prefixIconConstraints supaya icon punya space yang cukup
    final iconSize = context.r(22);
    final hPadding = context.r(AppSizes.lg);

    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: AppColors.textSecondary,
        fontWeight: FontWeight.w400,
        fontSize: context.rf(AppSizes.fontMd),
      ),
      prefixIcon: Padding(
        padding: EdgeInsets.only(
          left: hPadding,
          right: context.r(AppSizes.sm),
        ),
        child: Icon(icon, color: AppColors.textSecondary, size: iconSize),
      ),
      prefixIconConstraints: BoxConstraints(
        minWidth: iconSize + hPadding + context.r(AppSizes.sm),
        minHeight: iconSize,
      ),
      suffixIcon: suffix == null
          ? null
          : Padding(
              padding: EdgeInsets.only(right: context.r(AppSizes.sm)),
              child: suffix,
            ),
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: EdgeInsets.symmetric(
        horizontal: context.r(AppSizes.md),
        vertical: context.r(18),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(context.r(14)),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(context.r(14)),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(context.r(14)),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(context.r(14)),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(context.r(14)),
        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: context.r(AppSizes.sm), left: context.r(4)),
      child: Text(
        text,
        style: TextStyle(
          fontSize: context.rf(AppSizes.fontMd),
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
