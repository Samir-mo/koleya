import 'package:flutter/material.dart';

import '../themes/app_text_styles.dart';
import '../utils/extensions/context_ext.dart';
import '../utils/spacing.dart';

/// Reusable section title widget
/// Displays title text with optional trailing action (e.g., "See All")
///
/// Usage:
///   SectionTitle(title: 'Recent Flights')
///   SectionTitle(
///     title: 'Featured Places',
///     trailingLabel: 'View all',
///     onTrailingPressed: () {},
///   )
class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    required this.title,
    this.trailingLabel,
    this.onTrailingPressed,
    this.textStyle,
  });

  final String title;
  final String? trailingLabel;
  final VoidCallback? onTrailingPressed;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: rw(16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style:
                  textStyle ??
                  AppTextStyles.font16Bold.copyWith(color: colors.textPrimary),
            ),
          ),
          if (trailingLabel != null && onTrailingPressed != null) ...[
            horizontalSpacing(8),
            GestureDetector(
              onTap: onTrailingPressed,
              child: Text(
                trailingLabel!,
                style: AppTextStyles.font14SemiBold.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
