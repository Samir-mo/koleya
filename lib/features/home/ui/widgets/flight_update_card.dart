import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gate_buddy/core/themes/app_colors.dart';
import 'package:gate_buddy/core/themes/app_text_styles.dart';
import 'package:gate_buddy/core/utils/extensions/context_ext.dart';
import 'package:gate_buddy/core/utils/spacing.dart';
import 'package:gate_buddy/features/home/data/models/home_model.dart';

class FlightUpdateCard extends StatelessWidget {
  final UpdatedFlightModel flight;
  const FlightUpdateCard({super.key, required this.flight});

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    final statusColor = _statusColor(flight.status);
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
                  left: Radius.circular(14)),
            ),
          ),

          // ── Content ─────────────────────────────────────────────────────────
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: rw(14), vertical: rh(12)),
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
                              style: AppTextStyles.font14SemiBold
                                  .copyWith(color: colors.textPrimary),
                            ),
                            const Spacer(),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  flight.route.fromCode,
                                  style: AppTextStyles.font12Medium
                                      .copyWith(color: AppColors.primary200),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: rw(4)),
                                  child: Icon(Icons.arrow_forward_rounded,
                                      size: rw(11),
                                      color: colors.textHint),
                                ),
                                Text(
                                  flight.route.toCode,
                                  style: AppTextStyles.font12Medium
                                      .copyWith(color: AppColors.primary200),
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
                              style: AppTextStyles.font12Regular
                                  .copyWith(color: colors.textSecondary),
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
                                style: AppTextStyles.font12Medium
                                    .copyWith(
                                        color: AppColors.secondary200),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),

                  horizontalSpacing(12),

                  // ── Status badge ─────────────────────────────────────────
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: rw(10), vertical: rh(5)),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(rr(20)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: rw(6),
                          height: rw(6),
                          decoration: BoxDecoration(
                              color: statusColor, shape: BoxShape.circle),
                        ),
                        horizontalSpacing(5),
                        Text(
                          _statusLabel(flight.status),
                          style: AppTextStyles.font12Medium
                              .copyWith(color: statusColor),
                        ),
                      ],
                    ),
                  ),
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
          return '${'home.updated_time'.tr()}: ${_fmt(f.scheduledTime)}';
        }
        break;
      default:
        if (f.gate != null) return '${'home.gate'.tr()}: ${f.gate}';
        if (f.scheduledTime != null) return _fmt(f.scheduledTime);
    }
    return null;
  }

  Color _statusColor(String s) {
    switch (s.toUpperCase()) {
      case 'ON_TIME':
      case 'BOARDING':
        return AppColors.green200;
      case 'DELAYED':
        return AppColors.amber200;
      case 'CANCELLED':
        return AppColors.red200;
      case 'GATE_CHANGED':
        return AppColors.blue200;
      default:
        return AppColors.grey400;
    }
  }

  String _statusLabel(String s) {
    switch (s.toUpperCase()) {
      case 'ON_TIME':
        return 'home.status_on_time'.tr();
      case 'BOARDING':
        return 'home.status_boarding'.tr();
      case 'DELAYED':
        return 'home.status_delayed'.tr();
      case 'CANCELLED':
        return 'home.status_cancelled'.tr();
      case 'GATE_CHANGED':
        return 'home.status_gate_changed'.tr();
      default:
        return s;
    }
  }

  String _fmt(String? iso) {
    if (iso == null) return '';
    try {
      final dt = DateTime.parse(iso).toLocal();
      return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return '';
    }
  }
}
