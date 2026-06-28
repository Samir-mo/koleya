import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gate_buddy/core/themes/app_colors.dart';
import 'package:gate_buddy/core/themes/app_text_styles.dart';
import 'package:gate_buddy/core/utils/spacing.dart';

class CategoryFilterBar extends StatelessWidget {
  final String? selectedCategory;
  final ValueChanged<String?> onCategoryChanged;

  static const categories = [
    null,
    'SHOPS',
    'RESTAURANTS',
    'SERVICES',
    'ATM',
    'LOUNGE',
  ];

  static const categoryIcons = {
    null: Icons.grid_view_rounded,
    'SHOPS': Icons.shopping_bag_outlined,
    'RESTAURANTS': Icons.restaurant_outlined,
    'SERVICES': Icons.miscellaneous_services_outlined,
    'ATM': Icons.atm_outlined,
    'LOUNGE': Icons.weekend_outlined,
  };

  static Map<String?, String> _getCategoryLabels(BuildContext context) => {
        null: 'indoor_map.category_all'.tr(),
        'SHOPS': 'indoor_map.category_shops'.tr(),
        'RESTAURANTS': 'indoor_map.category_restaurants'.tr(),
        'SERVICES': 'indoor_map.category_services'.tr(),
        'ATM': 'indoor_map.category_atm'.tr(),
        'LOUNGE': 'indoor_map.category_lounge'.tr(),
      };

  const CategoryFilterBar({
    super.key,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    final categoryLabels = _getCategoryLabels(context);
    return SizedBox(
      height: rh(40),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: rw(16)),
        itemCount: categories.length,
        separatorBuilder: (_, __) => SizedBox(width: rw(8)),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = cat == selectedCategory;
          return GestureDetector(
            onTap: () => onCategoryChanged(isSelected ? null : cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: rw(14)),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary200 : Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: isSelected ? AppColors.primary200 : Colors.grey[300]!,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primary200.withValues(alpha: 0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : [],
              ),
              child: Row(
                children: [
                  Icon(
                    categoryIcons[cat],
                    size: 14.sp,
                    color: isSelected ? Colors.white : Colors.grey[600],
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    categoryLabels[cat]!,
                    style: AppTextStyles.font12Bold.copyWith(
                      color: isSelected ? Colors.white : Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
