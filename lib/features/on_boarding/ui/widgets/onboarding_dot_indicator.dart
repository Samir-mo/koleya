import 'package:flutter/material.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/utils/spacing.dart';

class OnboardingDotIndicator extends StatelessWidget {
  const OnboardingDotIndicator({
    super.key,
    required this.totalDots,
    required this.currentIndex,
  });

  final int totalDots;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(totalDots, (index) {
        final isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: EdgeInsets.symmetric(horizontal: rw(4)),
          width: isActive ? rw(20) : rw(8),
          height: rh(8),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.secondary200
                : AppColors.primary200.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(rr(4)),
          ),
        );
      }),
    );
  }
}
