import 'package:flutter/material.dart';

import '../themes/app_text_styles.dart';
import '../utils/extensions/context_ext.dart';
import '../utils/spacing.dart';
import 'custom_text_button.dart';

/// Reusable empty state widget
/// Displays icon + title + description + optional CTA button
///
/// Usage:
///   EmptyState(
///     icon: Icons.inbox_outlined,
///     title: 'No items',
///     description: 'Start adding items to get started',
///   )
///   EmptyState(
///     icon: Icons.search_off,
///     title: 'No results',
///     description: 'Try a different search',
///     actionLabel: 'Clear search',
///     onAction: () {},
///   )
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.actionLabel,
    this.onAction,
    this.iconSize = 80,
  });

  final IconData icon;
  final String title;
  final String description;
  final String? actionLabel;
  final VoidCallback? onAction;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: rw(24), vertical: rh(32)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Container(
              padding: EdgeInsets.all(rw(20)),
              decoration: BoxDecoration(
                color: colors.backgroundSecondary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: rf(iconSize),
                color: colors.textSecondary,
              ),
            ),

            verticalSpacing(24),

            // Title
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.font18Bold.copyWith(
                color: colors.textPrimary,
              ),
            ),

            verticalSpacing(8),

            // Description
            Text(
              description,
              textAlign: TextAlign.center,
              style: AppTextStyles.font14Regular.copyWith(
                color: colors.textSecondary,
                height: 1.5,
              ),
            ),

            // Action button (optional)
            if (actionLabel != null && onAction != null) ...[
              verticalSpacing(24),
              CustomTextButton.outlined(
                text: actionLabel!,
                onPressed: onAction,
                size: CustomButtonSize.small,
                isFullWidth: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
