import 'package:flutter/material.dart';
import 'package:gate_buddy/features/indoor_map/logic/cubit/indoor_map_state.dart';

class MapCategoryFilter extends StatelessWidget {
  final MapCategory selected;
  final ValueChanged<MapCategory> onSelected;

  const MapCategoryFilter({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  static const _primaryBlue = Color(0xFF013F82);
  static const _accentGold = Color(0xFFF3A623);

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
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: GestureDetector(
                onTap: () => onSelected(cat),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isActive ? _primaryBlue : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isActive ? _primaryBlue : const Color(0xFFE3E7F1),
                      width: 1.5,
                    ),
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: _primaryBlue.withOpacity(0.25),
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
                        color: isActive ? _accentGold : Colors.grey.shade600,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        cat.label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isActive ? Colors.white : Colors.grey.shade700,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  IconData _iconForCategory(MapCategory cat) {
    return switch (cat) {
      MapCategory.all => Icons.layers_outlined,
      MapCategory.shops => Icons.storefront_outlined,
      MapCategory.restaurants => Icons.restaurant_outlined,
      MapCategory.vip => Icons.workspace_premium_outlined,
      MapCategory.services => Icons.miscellaneous_services_outlined,
    };
  }
}
