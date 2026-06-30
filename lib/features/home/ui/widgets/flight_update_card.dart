import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../../../core/utils/extensions/context_ext.dart';
import '../../../../core/utils/spacing.dart';
import '../../../../core/utils/helpers/flight_time_helpers.dart';
import '../../../../core/widgets/flight_status_badge.dart';
import '../../data/models/home_model.dart';

class FlightUpdateCard extends StatelessWidget {
  final UpdatedFlightModel flight;
  const FlightUpdateCard({super.key, required this.flight});

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    final statusColor = flightStatusColor(flight.status);
    final updatedInfo = _updatedInfo(flight);

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(rr(14)),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Color accent bar ────────────────────────────────────────────────
            Container(
              width: rw(4),
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(14),
                ),
              ),
            ),

            // ── Content ─────────────────────────────────────────────────────────
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: rw(14),
                  vertical: rh(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Flight number + route
                          Row(
                            children: [
                              Text(
                                '${'home.flight_number'.tr()}: ${flight.flightNumber}',
                                style: AppTextStyles.font14SemiBold.copyWith(
                                  color: colors.textPrimary,
                                ),
                              ),
                              const Spacer(),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    flight.route.fromCode,
                                    style: AppTextStyles.font12Medium.copyWith(
                                      color: AppColors.primary200,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: rw(4),
                                    ),
                                    child: Icon(
                                      Icons.arrow_forward_rounded,
                                      size: rw(11),
                                      color: colors.textHint,
                                    ),
                                  ),
                                  Text(
                                    flight.route.toCode,
                                    style: AppTextStyles.font12Medium.copyWith(
                                      color: AppColors.primary200,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          verticalSpacing(5),

                          // Airline + updated info
                          Row(
                            children: [
                              Text(
                                flight.airline.name,
                                style: AppTextStyles.font12Regular.copyWith(
                                  color: colors.textSecondary,
                                ),
                              ),
                              if (updatedInfo != null) ...[
                                horizontalSpacing(8),
                                Container(
                                  width: rw(3),
                                  height: rw(3),
                                  decoration: BoxDecoration(
                                    color: colors.textHint,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                horizontalSpacing(8),
                                Text(
                                  updatedInfo,
                                  style: AppTextStyles.font12Medium.copyWith(
                                    color: AppColors.secondary200,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),

                    horizontalSpacing(12),

                    // ── Status badge ─────────────────────────────────────────
                    FlightStatusBadge(status: flight.status, showBorder: false),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Surfaces the most relevant update info based on flight status
  String? _updatedInfo(UpdatedFlightModel f) {
    switch (f.status.toUpperCase()) {
      case 'GATE_CHANGED':
        if (f.gate != null) return '${'home.updated_gate'.tr()}: ${f.gate}';
        break;
      case 'DELAYED':
        if (f.scheduledTime != null) {
          return '${'home.updated_time'.tr()}: ${formatHmFromIso(f.scheduledTime)}';
        }
        break;
      default:
        if (f.gate != null) return '${'home.gate'.tr()}: ${f.gate}';
        if (f.scheduledTime != null) return formatHmFromIso(f.scheduledTime);
    }
    return null;
  }
}
