import 'package:flutter/material.dart';
import 'package:gate_buddy/core/themes/app_colors.dart';
import 'package:gate_buddy/core/utils/extensions/context_ext.dart';
import 'package:gate_buddy/core/utils/spacing.dart';
import 'package:gate_buddy/features/indoor_map/logic/cubit/indoor_map_state.dart';

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

  // Use AppColors constants — not hardcoded values

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
            color: Colors.black.withValues(alpha: 0.14),
            blurRadius: 20,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Blue header ──────────────────────────────────────────────────
          Container(
            padding: EdgeInsets.fromLTRB(rw(16), rh(14), rw(16), rh(12)),
            decoration: const BoxDecoration(
              color: AppColors.primary200,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.navigation_rounded,
                      color: AppColors.secondary200,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Navigating to ${dest.name}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    GestureDetector(
                      onTap: onCancel,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha:0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Distance + time chips
                Row(
                  children: [
                    _MetaChip(
                      icon: Icons.straighten_rounded,
                      label: route.distanceLabel,
                    ),
                    const SizedBox(width: 8),
                    _MetaChip(
                      icon: Icons.directions_walk_rounded,
                      label: route.estimatedTimeLabel,
                    ),
                    const Spacer(),
                    Text(
                      '${state.currentStepIndex + 1} / ${route.steps.length} steps',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha:0.7),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress.clamp(0.0, 1.0),
                    backgroundColor: Colors.white.withValues(alpha:0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.secondary200,
                    ),
                    minHeight: 5,
                  ),
                ),
              ],
            ),
          ),

          // ── Current step ────────────────────────────────────────────────
          if (step != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF4FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _iconForStep(step.instruction),
                      color: AppColors.primary200,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          step.instruction,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Color(0xFF1A1A2E),
                          ),
                        ),
                        if (step.distanceMeters > 0)
                          Text(
                            '${step.distanceMeters.toStringAsFixed(0)}m',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // ── All steps list ───────────────────────────────────────────────
          if (route.steps.length > 1)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 14),
              child: Column(
                children: [
                  const Divider(height: 16),
                  ...route.steps.asMap().entries.map((e) {
                    final idx = e.key;
                    final s = e.value;
                    final isDone = idx < state.currentStepIndex;
                    final isCurrent = idx == state.currentStepIndex;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          // Step indicator dot
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isDone
                                  ? Colors.green.shade400
                                  : isCurrent
                                  ? AppColors.primary200
                                  : Colors.grey.shade200,
                            ),
                            child: Icon(
                              isDone
                                  ? Icons.check
                                  : isCurrent
                                  ? Icons.radio_button_checked
                                  : Icons.circle,
                              size: 12,
                              color: isDone || isCurrent
                                  ? Colors.white
                                  : Colors.grey.shade400,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              s.instruction,
                              style: TextStyle(
                                fontSize: 12,
                                color: isDone
                                    ? Colors.grey.shade400
                                    : isCurrent
                                    ? const Color(0xFF1A1A2E)
                                    : Colors.grey.shade600,
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
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade400,
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
    if (lower.contains('straight') || lower.contains('continue')) {
      return Icons.straight_rounded;
    }
    if (lower.contains('destination') || lower.contains('arrived')) {
      return Icons.place_rounded;
    }
    if (lower.contains('head') || lower.contains('towards')) {
      return Icons.north_rounded;
    }
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha:0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 12),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
