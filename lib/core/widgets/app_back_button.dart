import 'package:flutter/material.dart';

import '../utils/extensions/context_ext.dart';
import '../utils/spacing.dart';

/// Reusable app back button widget
/// Standard back button with consistent styling and sizing
///
/// Usage:
///   AppBackButton()
///   AppBackButton(color: Colors.white)
///   AppBackButton(
///     onPressed: () => context.pop(),
///     color: AppColors.primary200,
///   )
class AppBackButton extends StatelessWidget {
  const AppBackButton({
    super.key,
    this.onPressed,
    this.color,
    this.size = 24,
    this.padding = 8,
  });

  final VoidCallback? onPressed;
  final Color? color;
  final double size;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed ?? () => context.pop(),
      child: Padding(
        padding: EdgeInsets.all(rw(padding)),
        child: Icon(
          Icons.arrow_back_ios_rounded,
          size: size,
          color: color ?? context.customColors.textPrimary,
        ),
      ),
    );
  }
}
