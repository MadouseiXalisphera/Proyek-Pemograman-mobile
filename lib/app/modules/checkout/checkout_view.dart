import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/payment_info.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/utils/responsive.dart';
import '../../data/models/order_model.dart';
import 'checkout_controller.dart';
import 'widgets/order_summary.dart';
import 'widgets/payment_expand.dart';
import 'widgets/payment_method_tile.dart';

class CheckoutView extends GetView<CheckoutController> {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Center(
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(maxWidth: AppSizes.maxContentDesktop),
            child: Row(
              children: [
                IconButton(
                  padding:
                      EdgeInsets.symmetric(horizontal: context.r(AppSizes.lg)),
                  icon: const Icon(Icons.arrow_back,
                      color: AppColors.textPrimary),
                  onPressed: () => Get.back(),
                ),
                Text(
                  'Confirm Order',
                  style: TextStyle(
                    fontSize: context.rf(21),
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          context.r(AppSizes.lg),
          context.r(AppSizes.lg),
          context.r(AppSizes.lg),
          context.r(AppSizes.xl),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(maxWidth: AppSizes.maxContentDesktop),
            child: Form(
              key: controller.formKey,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius:
                      BorderRadius.circular(context.r(AppSizes.radiusLg)),
                ),
                padding: EdgeInsets.all(context.r(AppSizes.xl)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OrderSummary(
                      items: controller.items,
                      totalFormatted: controller.totalHargaFormatted,
                    ),
                    const Divider(color: AppColors.border, height: 32),
                    Center(
                      child: Text(
                        controller.namaMeja,
                        style: TextStyle(
                          fontSize: context.rf(AppSizes.fontDisplay),
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    SizedBox(height: context.r(AppSizes.xl)),

                    // Hilangkan AbsorbPointer dari luar, langsung panggil _buildForm
                    _buildForm(context),

                    Obx(() => AnimatedSize(
                          duration: const Duration(milliseconds: 250),
                          alignment: Alignment.topCenter,
                          child: controller.isConfirmed.value
                              ? const PaymentExpand()
                              : const SizedBox(width: double.infinity),
                        )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Customer info',
          style: TextStyle(
            fontSize: context.rf(AppSizes.fontLg),
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: context.r(AppSizes.md)),

        // Letakkan AbsorbPointer DI SINI, supaya HANYA text field yang terkunci
        Obx(() => AbsorbPointer(
              absorbing: controller.isConfirmed.value,
              child: Column(
                children: [
                  TextFormField(
                    controller: controller.namaC,
                    validator: controller.validateNama,
                    decoration: _pill(context, 'Nama'),
                  ),
                  SizedBox(height: context.r(AppSizes.md)),
                  TextFormField(
                    controller: controller.hpC,
                    validator: controller.validateHp,
                    keyboardType: TextInputType.number,
                    decoration: _pill(context, 'Phone Number (opsional)'),
                  ),
                  SizedBox(height: context.r(AppSizes.md)),
                  TextFormField(
                    controller: controller.emailC,
                    validator: controller.validateEmail,
                    keyboardType: TextInputType.emailAddress,
                    decoration: _pill(context, 'Email'),
                  ),
                ],
              ),
            )),

        SizedBox(height: context.r(AppSizes.xl)),
        Text(
          'Payment Method',
          style: TextStyle(
            fontSize: context.rf(AppSizes.fontLg),
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: context.r(AppSizes.sm)),
        Obx(() {
          final current = controller.paymentMethod.value;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PaymentMethodTile(
                title: 'Cash',
                subtitle: 'Bayar langsung ke kasir',
                icon: Icons.payments_outlined,
                isActive: current == PaymentMethod.cash,
                onTap: () => controller.selectPayment(PaymentMethod.cash),
              ),
              PaymentMethodTile(
                title: 'Transfer',
                subtitle: PaymentInfo.bankName,
                icon: Icons.account_balance_outlined,
                isActive: current == PaymentMethod.transfer,
                onTap: () => controller.selectPayment(PaymentMethod.transfer),
              ),
              PaymentMethodTile(
                title: 'QRIS',
                subtitle: 'Scan dengan e-wallet apa saja',
                icon: Icons.qr_code,
                isActive: current == PaymentMethod.qris,
                onTap: () => controller.selectPayment(PaymentMethod.qris),
              ),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.only(
          left: context.r(AppSizes.lg),
          right: context.r(AppSizes.lg),
          bottom: 0,
        ),
        child: Center(
          heightFactor: 1.0,
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(maxWidth: AppSizes.maxContentDesktop),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(context.r(AppSizes.radiusLg)),
                ),
                border: const Border(
                  top: BorderSide(color: AppColors.border, width: 1.5),
                  left: BorderSide(color: AppColors.border, width: 1.5),
                  right: BorderSide(color: AppColors.border, width: 1.5),
                ),
              ),
              padding: EdgeInsets.all(context.r(AppSizes.lg)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total:',
                    style: TextStyle(
                      fontSize: context.rf(AppSizes.fontMd),
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    controller.totalHargaFormatted,
                    style: TextStyle(
                      fontSize: context.rf(AppSizes.fontXxl),
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: context.r(AppSizes.md)),
                  SizedBox(
                    height: context.r(46),
                    width: double.infinity,
                    child: Obx(() {
                      final confirmed = controller.isConfirmed.value;
                      final submitting = controller.isSubmitting.value;
                      return ElevatedButton(
                        onPressed: submitting
                            ? null
                            : (confirmed
                                ? controller.finalize
                                : controller.confirmAndPay),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor:
                              AppColors.primary.withValues(alpha: 0.6),
                          disabledForegroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                context.r(AppSizes.radiusMd)),
                          ),
                        ),
                        child: submitting
                            ? SizedBox(
                                width: context.r(20),
                                height: context.r(20),
                                child: const CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2.5),
                              )
                            : Text(
                                confirmed ? 'Kirim ke Kasir' : 'Confirm & Pay',
                                style: TextStyle(
                                  fontSize: context.rf(AppSizes.fontLg),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _pill(BuildContext context, String hint) {
    OutlineInputBorder border(Color c, double w) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.r(AppSizes.radiusFull)),
          borderSide: c == Colors.transparent
              ? BorderSide.none
              : BorderSide(color: c, width: w),
        );
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: AppColors.fieldFill,
      hintStyle: TextStyle(
        color: AppColors.textSecondary,
        fontSize: context.rf(AppSizes.fontMd),
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: context.r(AppSizes.xl),
        vertical: context.r(AppSizes.lg),
      ),
      border: border(Colors.transparent, 0),
      enabledBorder: border(Colors.transparent, 0),
      focusedBorder: border(AppColors.primary, 1.5),
      errorBorder: border(AppColors.error, 1),
      focusedErrorBorder: border(AppColors.error, 1.5),
    );
  }
}
