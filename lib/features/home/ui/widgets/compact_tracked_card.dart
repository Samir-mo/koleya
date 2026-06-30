import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gate_buddy/core/themes/app_colors.dart';
import 'package:gate_buddy/core/themes/app_text_styles.dart';
import 'package:gate_buddy/core/utils/extensions/context_ext.dart';
import 'package:gate_buddy/core/utils/helpers/flight_time_helpers.dart';
import 'package:gate_buddy/core/utils/spacing.dart';
import 'package:gate_buddy/core/widgets/flight_info_chip.dart';
import 'package:gate_buddy/core/widgets/flight_status_badge.dart';
import 'package:gate_buddy/features/flights/data/models/flight_model.dart';
import 'package:gate_buddy/features/tracked_flight/ui/tracked_flight_screen.dart';

class CompactTrackedCard extends StatelessWidget {
  final FlightModel flight;
  const CompactTrackedCard({super.key, required this.flight});

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
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
                      formatHm(depTime),
                      style: AppTextStyles.font14Bold
                          .copyWith(color: AppColors.white),
                    ),
                  horizontalSpacing(8),
                  FlightStatusBadge(status: flight.status, showBorder: false),
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
                      FlightInfoChip(
                        icon: Icons.door_sliding_outlined,
                        label: '${'tracked_flight.gate'.tr()} ${dep.gate}',
                      ),
                    if (dep.gate != null && dep.terminal != null)
                      horizontalSpacing(8),
                    if (dep.terminal != null)
                      FlightInfoChip(
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



}

