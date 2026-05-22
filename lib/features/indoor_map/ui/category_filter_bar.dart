import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gate_buddy/core/themes/app_colors.dart';
import 'package:gate_buddy/core/themes/app_text_styles.dart';


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

  static const categoryLabels = {
    null: 'All',
    'SHOPS': 'Shops',
    'RESTAURANTS': 'Restaurants',
    'SERVICES': 'Services',
    'ATM': 'ATM',
    'LOUNGE': 'Lounge',
  };

  const CategoryFilterBar({
    super.key,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: categories.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = cat == selectedCategory;
          return GestureDetector(
            onTap: () => onCategoryChanged(isSelected ? null : cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary200 : Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: isSelected ? AppColors.primary200 : Colors.grey[300]!,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primary200.withOpacity(0.3),
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
