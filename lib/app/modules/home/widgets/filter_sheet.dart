import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/utils/responsive.dart';
import '../home_controller.dart';

class FilterSheet extends StatefulWidget {
  const FilterSheet({super.key});

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  late String _kategoriPilihan;
  late String _sortPilihan;

  final HomeController _homeController = Get.find<HomeController>();

  final List<Map<String, String>> _kategoriOptions = const [
    {'value': 'all', 'label': 'Semua'},
    {'value': 'food', 'label': 'Makanan'},
    {'value': 'drink', 'label': 'Minuman'},
  ];

  final List<Map<String, String>> _sortOptions = const [
    {'value': 'default', 'label': 'Default'},
    {'value': 'price_asc', 'label': 'Harga termurah'},
    {'value': 'price_desc', 'label': 'Harga termahal'},
    {'value': 'name_asc', 'label': 'Nama A-Z'},
  ];

  @override
  void initState() {
    super.initState();
    _kategoriPilihan = _homeController.kategori.value;
    _sortPilihan = _homeController.sortBy.value;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.r(AppSizes.xl),
        context.r(AppSizes.md),
        context.r(AppSizes.xl),
        context.r(AppSizes.xl) + MediaQuery.of(context).padding.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: context.r(40),
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: context.r(AppSizes.lg)),
          Text(
            'Filter & Urutkan',
            style: TextStyle(
              fontSize: context.rf(18),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: context.r(AppSizes.xl)),
          Text(
            'Kategori',
            style: TextStyle(
              fontSize: context.rf(AppSizes.fontMd),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: context.r(AppSizes.md)),
          Wrap(
            spacing: context.r(AppSizes.sm),
            children: _kategoriOptions.map((opt) {
              final isActive = _kategoriPilihan == opt['value'];
              return GestureDetector(
                onTap: () => setState(() => _kategoriPilihan = opt['value']!),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.r(AppSizes.md),
                    vertical: context.r(AppSizes.sm),
                  ),
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.primary : Colors.transparent,
                    border: Border.all(
                      color: isActive ? AppColors.primary : AppColors.border,
                    ),
                    borderRadius:
                        BorderRadius.circular(context.r(AppSizes.radiusXl)),
                  ),
                  child: Text(
                    opt['label']!,
                    style: TextStyle(
                      color: isActive ? Colors.white : AppColors.textSecondary,
                      fontSize: context.rf(AppSizes.fontMd),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: context.r(AppSizes.xl)),
          Text(
            'Urutkan',
            style: TextStyle(
              fontSize: context.rf(AppSizes.fontMd),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: context.r(AppSizes.sm)),
          ..._sortOptions.map((opt) {
            final isActive = _sortPilihan == opt['value'];
            return GestureDetector(
              onTap: () => setState(() => _sortPilihan = opt['value']!),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: context.r(AppSizes.sm)),
                child: Row(
                  children: [
                    Icon(
                      isActive
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color: isActive
                          ? AppColors.primary
                          : AppColors.textSecondary,
                      size: context.r(AppSizes.iconMd),
                    ),
                    SizedBox(width: context.r(AppSizes.md)),
                    Text(
                      opt['label']!,
                      style: TextStyle(
                        fontSize: context.rf(AppSizes.fontMd),
                        color: isActive
                            ? AppColors.primary
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          SizedBox(height: context.r(AppSizes.xl)),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => setState(() {
                    _kategoriPilihan = 'all';
                    _sortPilihan = 'default';
                  }),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary),
                    foregroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(context.r(AppSizes.md)),
                    ),
                    padding: EdgeInsets.symmetric(vertical: context.r(14)),
                  ),
                  child: const Text('Reset'),
                ),
              ),
              SizedBox(width: context.r(AppSizes.md)),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _homeController.applyFilter(
                      _kategoriPilihan,
                      _sortPilihan,
                    );
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(context.r(AppSizes.md)),
                    ),
                    padding: EdgeInsets.symmetric(vertical: context.r(14)),
                  ),
                  child: const Text('Terapkan'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
