import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../../../core/utils/extensions/context_ext.dart';
import '../../../../core/utils/spacing.dart';
import '../../logic/cubit/indoor_map_state.dart';

class NavigationPanel extends StatelessWidget {
  final IndoorMapLoaded state;
  final VoidCallback onCancel;
  final VoidCallback onNextStep;

  const NavigationPanel({
    super.key,
    required this.state,
    required this.onCancel,
    required this.onNextStep,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    final route = state.activeRoute;
    final dest = state.navigationDestination;
    final step = state.currentStep;
    if (route == null || dest == null) return const SizedBox.shrink();

    final progress =
        state.simulationPointIndex /
        (route.polylinePoints.length - 1).clamp(1, double.infinity);

    return Container(
      margin: EdgeInsets.fromLTRB(rw(12), 0, rw(12), rh(12)),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(rr(20)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.14),
            blurRadius: 20,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(rw(16), rh(14), rw(16), rh(12)),
            decoration: BoxDecoration(
              color: AppColors.primary200,
              borderRadius: BorderRadius.vertical(top: Radius.circular(rr(20))),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.navigation_rounded,
                      color: AppColors.secondary200,
                      size: rr(18),
                    ),
                    horizontalSpacing(8),
                    Expanded(
                      child: Text(
                        'indoor_map.navigating_to'.tr(
                          namedArgs: {'name': dest.name},
                        ),
                        style: AppTextStyles.font14Bold.copyWith(
                          color: AppColors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    GestureDetector(
                      onTap: onCancel,
                      child: Container(
                        padding: EdgeInsets.all(rr(5)),
                        decoration: BoxDecoration(
                          color: AppColors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(rr(8)),
                        ),
                        child: Icon(
                          Icons.close,
                          color: AppColors.white,
                          size: rr(16),
                        ),
                      ),
                    ),
                  ],
                ),
                verticalSpacing(10),
                Row(
                  children: [
                    _MetaChip(
                      icon: Icons.straighten_rounded,
                      label: route.distanceLabel,
                    ),
                    horizontalSpacing(8),
                    _MetaChip(
                      icon: Icons.directions_walk_rounded,
                      label: route.estimatedTimeLabel,
                    ),
                    const Spacer(),
                    Text(
                      'indoor_map.steps'.tr(
                        namedArgs: {
                          'current': '${state.currentStepIndex + 1}',
                          'total': '${route.steps.length}',
                        },
                      ),
                      style: AppTextStyles.font12Regular.copyWith(
                        color: AppColors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
                verticalSpacing(10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(rr(4)),
                  child: LinearProgressIndicator(
                    value: progress.clamp(0.0, 1.0),
                    backgroundColor: AppColors.white.withValues(alpha: 0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.secondary200,
                    ),
                    minHeight: rh(5),
                  ),
                ),
              ],
            ),
          ),

          if (step != null)
            Padding(
              padding: EdgeInsets.fromLTRB(rw(16), rh(14), rw(16), rh(6)),
              child: Row(
                children: [
                  Container(
                    width: rw(40),
                    height: rh(40),
                    decoration: BoxDecoration(
                      color: AppColors.primary200.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(rr(12)),
                    ),
                    child: Icon(
                      _iconForStep(step.instruction),
                      color: AppColors.primary200,
                      size: rr(20),
                    ),
                  ),
                  horizontalSpacing(12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          step.instruction,
                          style: AppTextStyles.font14SemiBold.copyWith(
                            color: context.customColors.textPrimary,
                          ),
                        ),
                        if (step.distanceMeters > 0)
                          Text(
                            '${step.distanceMeters.toStringAsFixed(0)}m',
                            style: AppTextStyles.font12Regular.copyWith(
                              color: context.customColors.textSecondary,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          if (route.steps.length > 1)
            Padding(
              padding: EdgeInsets.fromLTRB(rw(16), rh(4), rw(16), rh(14)),
              child: Column(
                children: [
                  Divider(height: rh(16), color: context.customColors.divider),
                  ...route.steps.asMap().entries.map((e) {
                    final idx = e.key;
                    final s = e.value;
                    final isDone = idx < state.currentStepIndex;
                    final isCurrent = idx == state.currentStepIndex;
                    return Padding(
                      padding: EdgeInsets.only(bottom: rh(8)),
                      child: Row(
                        children: [
                          Container(
                            width: rw(20),
                            height: rw(20),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isDone
                                  ? AppColors.green200
                                  : isCurrent
                                  ? AppColors.primary200
                                  : context.customColors.surfaceVariant,
                            ),
                            child: Icon(
                              isDone
                                  ? Icons.check
                                  : isCurrent
                                  ? Icons.radio_button_checked
                                  : Icons.circle,
                              size: rr(12),
                              color: isDone || isCurrent
                                  ? AppColors.white
                                  : context.customColors.iconSecondary,
                            ),
                          ),
                          horizontalSpacing(10),
                          Expanded(
                            child: Text(
                              s.instruction,
                              style: AppTextStyles.font12Regular.copyWith(
                                color: isDone
                                    ? context.customColors.textDisabled
                                    : isCurrent
                                    ? context.customColors.textPrimary
                                    : context.customColors.textSecondary,
                                fontWeight: isCurrent
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                                decoration: isDone
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                          ),
                          if (s.distanceMeters > 0)
                            Text(
                              '${s.distanceMeters.toStringAsFixed(0)}m',
                              style: AppTextStyles.font12Regular.copyWith(
                                color: context.customColors.textDisabled,
                              ),
                            ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
        ],
      ),
    );
  }

  IconData _iconForStep(String instruction) {
    final lower = instruction.toLowerCase();
    if (lower.contains('left')) return Icons.turn_left_rounded;
    if (lower.contains('right')) return Icons.turn_right_rounded;
    if (lower.contains('straight') || lower.contains('continue'))
      return Icons.straight_rounded;
    if (lower.contains('destination') || lower.contains('arrived'))
      return Icons.place_rounded;
    if (lower.contains('head') || lower.contains('towards'))
      return Icons.north_rounded;
    return Icons.directions_walk_rounded;
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MetaChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: rw(8), vertical: rh(4)),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(rr(8)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.white, size: rr(12)),
          horizontalSpacing(4),
          Text(
            label,
            style: AppTextStyles.font12Bold.copyWith(color: AppColors.white),
          ),
        ],
      ),
    );
  }
}
