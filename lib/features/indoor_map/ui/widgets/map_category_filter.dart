import 'package:flutter/material.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../../../core/utils/extensions/context_ext.dart';
import '../../../../core/utils/spacing.dart';
import '../../logic/cubit/indoor_map_state.dart';

class MapCategoryFilter extends StatelessWidget {
  final MapCategory selected;
  final ValueChanged<MapCategory> onSelected;

  const MapCategoryFilter({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    return SizedBox(
      height: rh(38),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: rw(16)),
        children: MapCategory.values.map((cat) {
          final isActive = selected == cat;
          return Padding(
            padding: EdgeInsets.only(right: rw(8)),
            child: GestureDetector(
              onTap: () => onSelected(cat),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(
                  horizontal: rw(14),
                  vertical: rh(8),
                ),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primary200 : colors.surface,
                  borderRadius: BorderRadius.circular(rr(20)),
                  border: Border.all(
                    color: isActive ? AppColors.primary200 : colors.border,
                    width: 1.5,
                  ),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: AppColors.primary200.withValues(alpha: 0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : [],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _iconForCategory(cat),
                      size: rr(13),
                      color: isActive
                          ? AppColors.secondary200
                          : colors.iconSecondary,
                    ),
                    horizontalSpacing(5),
                    Text(
                      cat.label,
                      style: AppTextStyles.font12Medium.copyWith(
                        color: isActive ? AppColors.white : colors.textPrimary,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  IconData _iconForCategory(MapCategory cat) => switch (cat) {
    MapCategory.all => Icons.layers_outlined,
    MapCategory.restaurants => Icons.restaurant_outlined,
    MapCategory.shops => Icons.storefront_outlined,
    MapCategory.vipServices => Icons.workspace_premium_outlined,
    MapCategory.financial => Icons.account_balance_outlined,
    MapCategory.counters => Icons.confirmation_number_outlined,
    MapCategory.accessibility => Icons.accessibility_new_outlined,
  };
}
