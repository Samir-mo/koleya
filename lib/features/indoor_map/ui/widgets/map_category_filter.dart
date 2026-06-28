import 'package:flutter/material.dart';
import 'package:gate_buddy/core/themes/app_colors.dart';
import 'package:gate_buddy/features/indoor_map/logic/cubit/indoor_map_state.dart';

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
    return SizedBox(
      height: 38,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: MapCategory.values.map((cat) {
          final isActive = selected == cat;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onSelected(cat),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primary200 : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isActive
                        ? AppColors.primary200
                        : const Color(0xFFE3E7F1),
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
                      size: 13,
                      color: isActive
                          ? AppColors.secondary200
                          : Colors.grey.shade600,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      cat.label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color:
                            isActive ? Colors.white : Colors.grey.shade700,
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
