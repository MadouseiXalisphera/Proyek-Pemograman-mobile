import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/responsive_wrapper.dart';
import 'logout_confirm_controller.dart';

/// Halaman konfirmasi logout: masukkan ulang password, lalu Logout.
/// Di-push di atas shell mana pun (user/kitchen/admin).
class LogoutConfirmView extends GetView<LogoutConfirmController> {
  const LogoutConfirmView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: LoginResponsiveWrapper(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: context.r(AppSizes.xl)),
            child: Container(
              padding: EdgeInsets.all(context.r(AppSizes.xl)),
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                borderRadius:
                    BorderRadius.circular(context.r(AppSizes.radiusXl)),
              ),
              child: Form(
                key: controller.formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Password',
                      style: TextStyle(
                        fontSize: context.rf(AppSizes.fontDisplay),
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: context.r(AppSizes.xl)),

                    // Field password — ikon MATA (sama seperti halaman login).
                    Obx(() {
                      return TextFormField(
                        controller: controller.passwordC,
                        validator: controller.validatePassword,
                        obscureText: controller.obscure.value,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => controller.submit(),
                        style: TextStyle(fontSize: context.rf(AppSizes.fontMd)),
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle:
                              const TextStyle(color: AppColors.textSecondary),
                          filled: true,
                          fillColor: AppColors.fieldFill,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: context.r(AppSizes.lg),
                            vertical: context.r(AppSizes.lg),
                          ),
                          suffixIcon: Padding(
                            padding:
                                EdgeInsets.only(right: context.r(AppSizes.sm)),
                            child: IconButton(
                              onPressed: controller.toggleObscure,
                              icon: Icon(
                                controller.obscure.value
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: AppColors.textSecondary,
                                size: context.r(22),
                              ),
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                context.r(AppSizes.radiusFull)),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                context.r(AppSizes.radiusFull)),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                context.r(AppSizes.radiusFull)),
                            borderSide: const BorderSide(
                                color: AppColors.primary, width: 1.5),
                          ),
                        ),
                      );
                    }),
                    SizedBox(height: context.r(AppSizes.xl)),

                    // Tombol Logout (danger)
                    Obx(() {
                      final loading = controller.isLoading.value;
                      return SizedBox(
                        width: double.infinity,
                        height: context.r(AppSizes.tapTargetLg),
                        child: ElevatedButton(
                          onPressed: loading ? null : controller.submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.danger,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor:
                                AppColors.danger.withValues(alpha: 0.6),
                            disabledForegroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  context.r(AppSizes.radiusFull)),
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
                                  'Logout',
                                  style: TextStyle(
                                    fontSize: context.rf(AppSizes.fontLg),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
