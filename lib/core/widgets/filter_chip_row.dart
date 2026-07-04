import 'package:flutter/material.dart';

import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';
import '../utils/extensions/context_ext.dart';
import '../utils/spacing.dart';

/// Reusable filter chip row widget
/// Horizontal scrollable chips with single or multi-select support
///
/// Usage (single-select):
///   `FilterChipRow<String>(`
///   `  items: ['All', 'Restaurants', 'Shops'],`
///   `  selected: 'All',`
///   `  onSelected: (value) => setState(() => _selected = value),`
///   `)`
///   `FilterChipRow<String>(`
///   `  items: ['All', 'Restaurants', 'Shops'],`
///   `  selected: _selected,`
///   `  onSelected: (value) => setState(() => _selected = value),`
///   `  multiSelect: false,`
///   `  getLabel: (item) => item,`
///   `)`
class FilterChipRow<T> extends StatelessWidget {
  const FilterChipRow({
    super.key,
    required this.items,
    required this.selected,
    required this.onSelected,
    this.multiSelect = false,
    this.getLabel,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
  });

  final List<T> items;
  final dynamic selected; // T or List<T>
  final ValueChanged<T> onSelected;
  final bool multiSelect;
  final String Function(T)? getLabel;
  final EdgeInsets padding;

  String _getLabel(T item) {
    return getLabel?.call(item) ?? item.toString();
  }

  bool _isSelected(T item) {
    if (multiSelect && selected is List<T>) {
      return (selected as List<T>).contains(item);
    }
    return selected == item;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: padding,
      child: Row(
        children: items.map((item) {
          final isActive = _isSelected(item);
          return Padding(
            padding: EdgeInsets.only(right: rw(8)),
            child: FilterChip(
              label: Text(_getLabel(item)),
              selected: isActive,
              onSelected: (_) => onSelected(item),
              labelStyle: AppTextStyles.font12Bold.copyWith(
                color: isActive ? Colors.white : colors.textSecondary,
              ),
              backgroundColor: colors.surface,
              selectedColor: AppColors.primary200,
              side: BorderSide(
                color: isActive ? AppColors.primary200 : colors.border,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(rr(20)),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
