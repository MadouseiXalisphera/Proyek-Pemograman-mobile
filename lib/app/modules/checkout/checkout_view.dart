import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/payment_info.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/utils/format.dart';
import '../../core/utils/responsive.dart';
import '../../data/models/order_model.dart';
import 'checkout_controller.dart';

class CheckoutView extends GetView<CheckoutController> {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: Center(
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(maxWidth: AppSizes.maxContentDesktop),
          child: Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.surface,
              elevation: 0,
              leading: IconButton(
                icon:
                    const Icon(Icons.arrow_back, color: AppColors.textPrimary),
                onPressed: () => Get.back(),
              ),
              title: Text(
                'Confirm Order',
                style: TextStyle(
                  fontSize: context.rf(21),
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
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
              child: Form(
                key: controller.formKey,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius:
                        BorderRadius.circular(context.r(AppSizes.radiusLg)),
                  ),
                  padding: EdgeInsets.all(context.r(AppSizes.xl)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- Ringkasan pesanan ---
                      _buildOrderSummary(context),
                      const Divider(color: AppColors.border, height: 32),

                      // --- Header meja ---
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

                      // --- Costumer info ---
                      Text(
                        'Costumer info',
                        style: TextStyle(
                          fontSize: context.rf(AppSizes.fontLg),
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: context.r(AppSizes.md)),
                      TextFormField(
                        controller: controller.namaC,
                        validator: controller.validateNama,
                        decoration: _pillDecoration(context, hint: 'Nama'),
                      ),
                      SizedBox(height: context.r(AppSizes.md)),
                      TextFormField(
                        controller: controller.hpC,
                        validator: controller.validateHp,
                        keyboardType: TextInputType.number,
                        decoration: _pillDecoration(context,
                            hint: 'Phone Number (opsional)'),
                      ),
                      SizedBox(height: context.r(AppSizes.md)),
                      TextFormField(
                        controller: controller.emailC,
                        validator: controller.validateEmail,
                        keyboardType: TextInputType.emailAddress,
                        decoration: _pillDecoration(context, hint: 'Email'),
                      ),

                      // --- Metode pembayaran ---
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
                          children: [
                            _PaymentRadioTile(
                              method: PaymentMethod.cash,
                              title: 'Cash',
                              subtitle: 'Bayar langsung ke kasir',
                              icon: Icons.payments_outlined,
                              isActive: current == PaymentMethod.cash,
                              onTap: () =>
                                  controller.selectPayment(PaymentMethod.cash),
                            ),
                            _PaymentRadioTile(
                              method: PaymentMethod.transfer,
                              title: 'Transfer',
                              subtitle: PaymentInfo.bankName,
                              icon: Icons.account_balance_outlined,
                              isActive: current == PaymentMethod.transfer,
                              onTap: () => controller
                                  .selectPayment(PaymentMethod.transfer),
                            ),
                            _PaymentRadioTile(
                              method: PaymentMethod.qris,
                              title: 'QRIS',
                              subtitle: 'Scan dengan e-wallet apa saja',
                              icon: Icons.qr_code,
                              isActive: current == PaymentMethod.qris,
                              onTap: () =>
                                  controller.selectPayment(PaymentMethod.qris),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: Container(
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(
                  top: BorderSide(color: AppColors.border, width: 1.5),
                ),
              ),
              padding: EdgeInsets.all(context.r(AppSizes.lg)),
              child: SafeArea(
                top: false,
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
                      height: context.r(AppSizes.tapTargetLg),
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: controller.submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                context.r(AppSizes.radiusLg)),
                          ),
                        ),
                        child: Text(
                          'Confirm & Pay',
                          style: TextStyle(
                            fontSize: context.rf(AppSizes.fontLg),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderSummary(BuildContext context) {
    final items = controller.items;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < items.length; i++)
          Padding(
            padding: EdgeInsets.only(bottom: context.r(6)),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${items[i].menuItem.nama} x${items[i].quantity}',
                    style: TextStyle(
                      fontSize: context.rf(AppSizes.fontMd),
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                Text(
                  formatRupiah(items[i].subtotal),
                  style: TextStyle(
                    fontSize: context.rf(AppSizes.fontMd),
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        SizedBox(height: context.r(AppSizes.sm)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total:',
              style: TextStyle(
                fontSize: context.rf(AppSizes.fontMd),
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              controller.totalHargaFormatted,
              style: TextStyle(
                fontSize: context.rf(AppSizes.fontMd),
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  InputDecoration _pillDecoration(BuildContext context,
      {required String hint}) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFE0E0E0),
      hintStyle: TextStyle(
        color: const Color(0xFF808080),
        fontSize: context.rf(AppSizes.fontMd),
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: context.r(AppSizes.xl),
        vertical: context.r(AppSizes.lg),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(context.r(28)),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(context.r(28)),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(context.r(28)),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(context.r(28)),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(context.r(28)),
        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      ),
    );
  }
}

class _PaymentRadioTile extends StatelessWidget {
  final PaymentMethod method;
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _PaymentRadioTile({
    required this.method,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(context.r(AppSizes.md)),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(
            horizontal: context.r(AppSizes.md),
            vertical: context.r(AppSizes.md),
          ),
          decoration: BoxDecoration(
            color: isActive ? AppColors.background : Colors.transparent,
            borderRadius: BorderRadius.circular(context.r(AppSizes.md)),
          ),
          child: Row(
            children: [
              Icon(
                isActive
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: isActive ? AppColors.primary : AppColors.textSecondary,
                size: context.r(22),
              ),
              SizedBox(width: context.r(AppSizes.md)),
              Icon(
                icon,
                color: isActive ? AppColors.primary : AppColors.textSecondary,
                size: context.r(22),
              ),
              SizedBox(width: context.r(AppSizes.md)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: context.rf(AppSizes.fontLg),
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: context.rf(AppSizes.fontSm),
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
