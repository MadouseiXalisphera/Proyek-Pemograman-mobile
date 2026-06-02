import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/top_pick_card.dart';
import '../../../routes/app_routes.dart';
import '../home_controller.dart';
import 'filter_sheet.dart';

/// Search bar pill di atas Home.
///
/// Auto-update searchQuery di HomeController setiap kali user mengetik.
class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Container(
      height: context.r(60),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(context.r(60)),
      ),
      child: TextField(
        controller: controller.searchC,
        onChanged: (v) => controller.searchQuery.value = v,
        style: TextStyle(
          fontSize: context.rf(AppSizes.fontXl),
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
        ),
        decoration: InputDecoration(
          hintText: 'Search...',
          hintStyle: TextStyle(
            fontSize: context.rf(AppSizes.fontXl),
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.only(
              left: context.r(AppSizes.lg),
              right: context.r(AppSizes.sm),
            ),
            child: Icon(
              Icons.search,
              color: AppColors.textSecondary,
              size: context.r(AppSizes.iconLg),
            ),
          ),
          prefixIconConstraints: BoxConstraints(
            minWidth: context.r(AppSizes.iconLg) +
                context.r(AppSizes.lg) +
                context.r(AppSizes.sm),
            minHeight: context.r(AppSizes.iconLg),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            vertical: context.r(18),
          ),
        ),
      ),
    );
  }
}

/// Section Top Picks: heading + "See All" + horizontal scroll list kartu.
///
/// Tinggi container adaptive per device untuk hindari overflow.
class HomeTopPicksSection extends StatelessWidget {
  final double sidePadding;
  final VoidCallback onSeeAll;

  const HomeTopPicksSection({
    super.key,
    required this.sidePadding,
    required this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    final listHeight = context.responsiveValue<double>(
      mobile: 320,
      tablet: 400,
      desktop: 450,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: sidePadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Top Picks',
                style: TextStyle(
                  fontSize: context.rf(AppSizes.fontXxl),
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: onSeeAll,
                child: Text(
                  'See All',
                  style: TextStyle(
                    fontSize: context.rf(AppSizes.fontLg),
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: context.r(AppSizes.md)),
        SizedBox(
          height: listHeight,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: sidePadding),
            itemCount: controller.topPicks.length,
            itemBuilder: (context, index) {
              final item = controller.topPicks[index];
              return Padding(
                padding: EdgeInsets.only(
                  right: index < controller.topPicks.length - 1
                      ? context.r(AppSizes.md)
                      : 0,
                ),
                child: TopPickCard(item: item),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Header "All Menu" dengan tombol filter (icon tune + badge merah jika
/// filter aktif).
///
/// Saat di-tap, otomatis membuka FilterSheet sebagai bottom sheet.
class HomeAllMenuHeader extends StatelessWidget {
  final Key allMenuKey;
  final double sidePadding;

  const HomeAllMenuHeader({
    super.key,
    required this.allMenuKey,
    required this.sidePadding,
  });

  void _openFilterSheet() {
    Get.bottomSheet(
      const FilterSheet(),
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Padding(
      key: allMenuKey,
      padding: EdgeInsets.fromLTRB(
        sidePadding,
        context.r(AppSizes.xl),
        sidePadding,
        context.r(AppSizes.md),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'All Menu',
            style: TextStyle(
              fontSize: context.rf(AppSizes.fontXxl),
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          Obx(() {
            final filterAktif = controller.kategori.value != 'all' ||
                controller.sortBy.value != 'default';
            return GestureDetector(
              onTap: _openFilterSheet,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Padding(
                    padding: EdgeInsets.all(context.r(4)),
                    child: Icon(
                      Icons.tune,
                      color: AppColors.textSecondary,
                      size: context.r(AppSizes.iconLg),
                    ),
                  ),
                  if (filterAktif)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: context.r(AppSizes.sm),
                        height: context.r(AppSizes.sm),
                        decoration: const BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

/// Empty state untuk hasil pencarian kosong.
///
/// Tampil icon search-off + pesan + tombol untuk hapus pencarian.
class HomeSearchEmpty extends StatelessWidget {
  const HomeSearchEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.r(40)),
      child: Column(
        children: [
          Icon(
            Icons.search_off,
            size: context.r(64),
            color: AppColors.primaryLight,
          ),
          SizedBox(height: context.r(AppSizes.md)),
          Text(
            'Tidak ada menu yang cocok',
            style: TextStyle(
              fontSize: context.rf(AppSizes.fontLg),
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: context.r(AppSizes.md)),
          TextButton(
            onPressed: controller.clearSearch,
            child: const Text('Hapus pencarian'),
          ),
        ],
      ),
    );
  }
}

/// Footer navigation bar untuk HomeView.
///
/// Dipasang sebagai `Scaffold.bottomNavigationBar` supaya otomatis
/// full-width window (tidak dibatasi max-width content).
///
/// 4 tab: Home (aktif) / Cart / Order / How to Use.
/// Tab Order dan How to Use masih placeholder, tap menampilkan snackbar.
class HomeFooterNav extends StatelessWidget {
  const HomeFooterNav({super.key});

  void _showPlaceholder() {
    Get.snackbar(
      'Segera Hadir',
      'Fitur ini akan datang di pembaruan berikutnya',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.r(81),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.border, width: 1.5),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            _buildTab(
              context,
              icon: Icons.home,
              label: 'Home',
              isActive: true,
            ),
            _buildTab(
              context,
              icon: Icons.shopping_basket_outlined,
              label: 'Cart',
              onTap: () => Get.toNamed(AppRoutes.cart),
            ),
            _buildTab(
              context,
              icon: Icons.receipt_long_outlined,
              label: 'Order',
              onTap: _showPlaceholder,
            ),
            _buildTab(
              context,
              icon: Icons.menu_book_outlined,
              label: 'How to Use',
              onTap: _showPlaceholder,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(
    BuildContext context, {
    required IconData icon,
    required String label,
    bool isActive = false,
    VoidCallback? onTap,
  }) {
    final color = isActive ? AppColors.primary : AppColors.primaryLight;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: context.r(AppSizes.iconLg)),
            SizedBox(height: context.r(2)),
            Text(
              label,
              style: TextStyle(
                fontSize: context.rf(11),
                color: color,
              ),
            ),
            if (isActive) ...[
              SizedBox(height: context.r(4)),
              Container(
                height: 2,
                width: context.r(AppSizes.iconLg),
                color: AppColors.primary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
