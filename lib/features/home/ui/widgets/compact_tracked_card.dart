import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gate_buddy/core/themes/app_colors.dart';
import 'package:gate_buddy/core/themes/app_text_styles.dart';
import 'package:gate_buddy/core/utils/extensions/context_ext.dart';
import 'package:gate_buddy/core/utils/spacing.dart';
import 'package:gate_buddy/features/flights/data/models/flight_model.dart';
import 'package:gate_buddy/features/tracked_flight/ui/tracked_flight_screen.dart';

class CompactTrackedCard extends StatelessWidget {
  final FlightModel flight;
  const CompactTrackedCard({super.key, required this.flight});

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    final statusColor = _statusColor(flight.status);
    final dep = flight.departure;
    final depTime = dep.estimatedTime ?? dep.scheduledTime;

    return GestureDetector(
      onTap: () => Navigator.of(context, rootNavigator: true).push(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => TrackedFlightScreen(flight: flight),
          transitionsBuilder: (_, animation, __, child) => SlideTransition(
            position: Tween(begin: const Offset(1, 0), end: Offset.zero)
                .animate(CurvedAnimation(
                    parent: animation, curve: Curves.easeInOutCubic)),
            child: child,
          ),
          transitionDuration: const Duration(milliseconds: 300),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(rr(14)),
          border: Border.all(color: colors.border),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary200.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // ── Navy header strip ──────────────────────────────────────────
            Container(
              padding:
                  EdgeInsets.symmetric(horizontal: rw(14), vertical: rh(10)),
              decoration: const BoxDecoration(
                color: AppColors.primary200,
                borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
              ),
              child: Row(
                children: [
                  Container(
                    width: rw(34),
                    height: rw(34),
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        flight.airline.name.isNotEmpty
                            ? flight.airline.name[0].toUpperCase()
                            : '✈',
                        style: AppTextStyles.font14Bold
                            .copyWith(color: AppColors.white),
                      ),
                    ),
                  ),
                  horizontalSpacing(10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          flight.airline.name,
                          style: AppTextStyles.font14SemiBold
                              .copyWith(color: AppColors.white),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          flight.flightNumber,
                          style: AppTextStyles.font12Regular
                              .copyWith(color: AppColors.primary50),
                        ),
                      ],
                    ),
                  ),
                  if (depTime != null)
                    Text(
                      _fmt(depTime),
                      style: AppTextStyles.font14Bold
                          .copyWith(color: AppColors.white),
                    ),
                  horizontalSpacing(8),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: rw(8), vertical: rh(3)),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(rr(20)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: rw(5),
                          height: rw(5),
                          decoration: BoxDecoration(
                              color: statusColor, shape: BoxShape.circle),
                        ),
                        horizontalSpacing(4),
                        Text(
                          flight.status.replaceAll('_', ' '),
                          style: AppTextStyles.font12Medium
                              .copyWith(color: statusColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Route row ────────────────────────────────────────────────
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: rw(14), vertical: rh(12)),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(flight.route.fromCode,
                          style: AppTextStyles.font18Bold
                              .copyWith(color: AppColors.primary200)),
                      Text(flight.route.from,
                          style: AppTextStyles.font12Regular
                              .copyWith(color: colors.textHint),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: rw(12)),
                      child: Column(
                        children: [
                          Icon(Icons.flight_rounded,
                              color: AppColors.secondary200, size: rw(16)),
                          Container(
                              width: double.infinity,
                              height: 1,
                              color: colors.border),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(flight.route.toCode,
                          style: AppTextStyles.font18Bold
                              .copyWith(color: AppColors.primary200)),
                      Text(flight.route.to,
                          style: AppTextStyles.font12Regular
                              .copyWith(color: colors.textHint),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ],
              ),
            ),

            // ── Gate / terminal chips ────────────────────────────────────
            if (dep.gate != null || dep.terminal != null)
              Padding(
                padding:
                    EdgeInsets.fromLTRB(rw(14), 0, rw(14), rh(10)),
                child: Row(
                  children: [
                    if (dep.gate != null)
                      _Chip(
                        icon: Icons.door_sliding_outlined,
                        label: '${'tracked_flight.gate'.tr()} ${dep.gate}',
                      ),
                    if (dep.gate != null && dep.terminal != null)
                      horizontalSpacing(8),
                    if (dep.terminal != null)
                      _Chip(
                        icon: Icons.business_outlined,
                        label:
                            '${'tracked_flight.terminal'.tr()} ${dep.terminal}',
                      ),
                    const Spacer(),
                    Icon(Icons.chevron_right_rounded,
                        size: rw(18), color: colors.textHint),
                  ],
                ),
              )
            else
              Padding(
                padding: EdgeInsets.only(right: rw(14), bottom: rh(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.chevron_right_rounded,
                        size: rw(18), color: colors.textHint),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _fmt(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

  Color _statusColor(String s) {
    switch (s.toUpperCase()) {
      case 'ON_TIME':
        return AppColors.green200;
      case 'BOARDING':
        return AppColors.blue200;
      case 'DELAYED':
        return AppColors.amber200;
      case 'CANCELLED':
        return AppColors.red200;
      default:
        return AppColors.grey400;
    }
  }
}

// Tiny helper used only by CompactTrackedCard
class _Chip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Chip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: rw(8), vertical: rh(5)),
      decoration: BoxDecoration(
        color: AppColors.primary200.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(rr(8)),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: rw(11), color: AppColors.primary200),
          horizontalSpacing(4),
          Text(label,
              style: AppTextStyles.font12Medium
                  .copyWith(color: colors.textPrimary)),
        ],
      ),
    );
  }
}
