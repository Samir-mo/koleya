import 'package:flutter/material.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/utils/extensions/context_ext.dart';
import '../../../../core/utils/spacing.dart';

class ServiceTypeChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const ServiceTypeChip({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.only(right: rw(10)),
        padding: EdgeInsets.symmetric(horizontal: rw(14), vertical: rh(10)),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary200 : colors.surface,
          borderRadius: BorderRadius.circular(rr(30)),
          border: Border.all(
            color: isSelected ? AppColors.primary200 : colors.border,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary200.withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: rr(16),
              color: isSelected ? AppColors.white : colors.iconPrimary,
            ),
            SizedBox(width: rw(6)),
            Text(
              label,
              style: TextStyle(
                fontSize: rf(13),
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppColors.white : colors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
