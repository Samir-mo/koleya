import 'package:flutter/material.dart';
import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';
import '../utils/extensions/context_ext.dart';
import '../utils/spacing.dart';

/// Compact info chip used in flight cards to display gate, terminal, etc.
///
/// Flat mode (value omitted):
/// ```dart
/// FlightInfoChip(icon: Icons.door_sliding_outlined, label: 'Gate B4')
/// ```
///
/// Stacked mode (label = hint text, value = primary text):
/// ```dart
/// FlightInfoChip(icon: Icons.access_time_rounded, label: 'Boards at', value: '14:30')
/// ```
class FlightInfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  /// When provided, renders a two-line chip with [label] as a muted hint
  /// above [value] as the primary text. When null, renders a flat single-line chip.
  final String? value;

  const FlightInfoChip({
    super.key,
    required this.icon,
    required this.label,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    final isStacked = value != null;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: rw(10),
        vertical: isStacked ? rh(7) : rh(5),
      ),
      decoration: BoxDecoration(
        color: AppColors.primary200.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(rr(isStacked ? 10 : 8)),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: rw(isStacked ? 13 : 12),
            color: AppColors.primary200,
          ),
          horizontalSpacing(5),
          if (isStacked)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.font12Regular.copyWith(
                    color: colors.textHint,
                  ),
                ),
                Text(
                  value!,
                  style: AppTextStyles.font12Medium.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
              ],
            )
          else
            Text(
              label,
              style: AppTextStyles.font12Medium.copyWith(
                color: colors.textPrimary,
              ),
            ),
        ],
      ),
    );
  }
}
