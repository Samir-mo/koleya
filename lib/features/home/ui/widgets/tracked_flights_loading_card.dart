import 'package:flutter/material.dart';
import 'package:gate_buddy/core/themes/app_colors.dart';
import 'package:gate_buddy/core/utils/extensions/context_ext.dart';
import 'package:gate_buddy/core/utils/spacing.dart';

class TrackedFlightsLoadingCard extends StatelessWidget {
  const TrackedFlightsLoadingCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    return Container(
      height: rh(100),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(rr(14)),
        border: Border.all(color: colors.border),
      ),
      child: const Center(
        child: CircularProgressIndicator(
            strokeWidth: 2, color: AppColors.primary200),
      ),
    );
  }
}
