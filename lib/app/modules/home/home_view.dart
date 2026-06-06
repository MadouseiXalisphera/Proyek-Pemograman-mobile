import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/menu_grid_card.dart';
import '../../core/widgets/menu_list_card.dart';
import '../../core/widgets/responsive_wrapper.dart';
import '../cart/cart_controller.dart';
import '../shell/user_shell_controller.dart';
import 'home_controller.dart';
import 'widgets/cart_floating_bar.dart';
import 'widgets/home_sections.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeController controller = Get.find<HomeController>();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _allMenuKey = GlobalKey();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToAllMenu() {
    final ctx = _allMenuKey.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final sidePadding = context.rv<double>(
      mobile: AppSizes.lg,
      tablet: AppSizes.xxl,
      desktop: AppSizes.xxl,
    );

    // Body-only: shell yang menyediakan Scaffold + bottom nav. Halaman ini
    // hanya mengembalikan konten tab Home.
    return SafeArea(
        child: Stack(
          children: [
            // Konten utama dibatasi max-width via ResponsiveWrapper
            ResponsiveWrapper(
              child: ListView(
                controller: _scrollController,
                children: [
                  // Search bar
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      sidePadding,
                      context.r(AppSizes.xl),
                      sidePadding,
                      context.r(AppSizes.lg),
                    ),
                    child: const HomeSearchBar(),
                  ),

                  // Top Picks — tersembunyi saat search aktif
                  Obx(() {
                    final searching = controller.searchQuery.value.isNotEmpty;
                    return AnimatedSize(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOutCubic,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: searching ? 0 : 1,
                        child: searching
                            ? const SizedBox(width: double.infinity)
                            : HomeTopPicksSection(
                                sidePadding: sidePadding,
                                onSeeAll: _scrollToAllMenu,
                              ),
                      ),
                    );
                  }),

                  // Header All Menu
                  HomeAllMenuHeader(
                    allMenuKey: _allMenuKey,
                    sidePadding: sidePadding,
                  ),

                  // Label hasil pencarian
                  Obx(() {
                    final q = controller.searchQuery.value;
                    if (q.isEmpty) return const SizedBox.shrink();
                    final count = controller.filteredMenu.length;
                    return Padding(
                      padding: EdgeInsets.fromLTRB(
                        sidePadding,
                        0,
                        sidePadding,
                        context.r(AppSizes.md),
                      ),
                      child: Text(
                        'Hasil pencarian "$q" ($count item)',
                        style: TextStyle(
                          fontSize: context.rf(AppSizes.fontMd),
                          color: AppColors.textSecondary,
                        ),
                      ),
                    );
                  }),

                  // All Menu list / grid / empty state
                  Obx(() {
                    final q = controller.searchQuery.value;
                    final list = controller.filteredMenu;
                    if (list.isEmpty && q.isNotEmpty) {
                      return const HomeSearchEmpty();
                    }
                    return _buildMenuList(context, sidePadding, list);
                  }),

                  // Buffer di bawah supaya tidak ketutup floating bar
                  SizedBox(height: context.r(88)),
                ],
              ),
            ),

            // Floating bar — ikut max-width content
            Positioned(
              left: 0,
              right: 0,
              bottom: context.r(AppSizes.sm),
              child: ResponsiveWrapper(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: sidePadding),
                  child: Obx(() {
                    final visible = Get.find<CartController>().items.isNotEmpty;
                    return IgnorePointer(
                      ignoring: !visible,
                      child: AnimatedSlide(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOutCubic,
                        offset: visible ? Offset.zero : const Offset(0, 2),
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: visible ? 1.0 : 0.0,
                          child: CartFloatingBar(
                            onTap: () =>
                                Get.find<UserShellController>().goToCart(),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      );
  }

  // ─────────────────────────────────────────────────────────────
  // SECTION: All Menu list / grid
  // Adaptive: ListView (mobile) vs GridView (tablet/desktop).
  // Tetap di file ini karena butuh akses langsung ke controller.filteredMenu
  // dan logic if-else berdasarkan device.
  // ─────────────────────────────────────────────────────────────
  Widget _buildMenuList(
    BuildContext context,
    double sidePadding,
    List list,
  ) {
    if (context.isMobile) {
      return Column(
        children: [
          for (int i = 0; i < list.length; i++)
            Padding(
              padding: EdgeInsets.fromLTRB(
                sidePadding,
                0,
                sidePadding,
                context.r(AppSizes.md),
              ),
              child: MenuListCard(item: list[i]),
            ),
        ],
      );
    }

    final crossAxisCount = context.menuGridColumns;
    final spacing = context.r(AppSizes.md);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: sidePadding),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: spacing,
          crossAxisSpacing: spacing,
          childAspectRatio: 0.7,
        ),
        itemCount: list.length,
        itemBuilder: (context, index) {
          return MenuGridCard(item: list[index]);
        },
      ),
    );
  }
}
