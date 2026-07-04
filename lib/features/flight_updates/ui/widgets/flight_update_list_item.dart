import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../../../core/utils/extensions/context_ext.dart';
import '../../../../core/utils/helpers/flight_time_helpers.dart';
import '../../../../core/utils/spacing.dart';
import '../../../../core/widgets/flight_status_badge.dart';
import '../../../flights/data/models/flight_model.dart';

class FlightUpdateListItem extends StatelessWidget {
  final FlightModel flight;
  final VoidCallback onTap;

  const FlightUpdateListItem({
    super.key,
    required this.flight,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    final depTime = flight.departure.estimatedTime ?? flight.departure.scheduledTime;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: rw(20), vertical: rh(8)),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(rr(16)),
          border: Border.all(color: colors.border),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // ── Header: Flight + Status ──────────────────────
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: rw(14),
                vertical: rh(10),
              ),
              decoration: const BoxDecoration(
                color: AppColors.primary200,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${flight.airline.name} ${flight.flightNumber}',
                          style: AppTextStyles.font14SemiBold.copyWith(
                            color: AppColors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        verticalSpacing(2),
                        Text(
                          '${flight.route.fromCode} → ${flight.route.toCode}',
                          style: AppTextStyles.font12Regular.copyWith(
                            color: AppColors.primary50,
                          ),
                        ),
                      ],
                    ),
                  ),
                  horizontalSpacing(10),
                  if (depTime != null)
                    Text(
                      formatHm(depTime),
                      style: AppTextStyles.font12Medium.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  horizontalSpacing(8),
                  FlightStatusBadge(status: flight.status, showBorder: false),
                ],
              ),
            ),

            // ── Updates preview ─────────────────────────────
            if (flight.updates.isNotEmpty)
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: rw(14),
                  vertical: rh(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'flight_updates.recent_changes'.tr(),
                      style: AppTextStyles.font12Medium.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    verticalSpacing(8),
                    ...flight.updates.take(2).map(
                          (u) => Padding(
                            padding: EdgeInsets.only(bottom: rh(6)),
                            child: _UpdatePreview(update: u),
                          ),
                        ),
                    if (flight.updates.length > 2)
                      Padding(
                        padding: EdgeInsets.only(top: rh(4)),
                        child: Text(
                          'flight_updates.and_more'.tr(args: [
                            (flight.updates.length - 2).toString(),
                          ]),
                          style: AppTextStyles.font12Regular.copyWith(
                            color: colors.textHint,
                          ),
                        ),
                      ),
                  ],
                ),
              )
            else
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: rw(14),
                  vertical: rh(12),
                ),
                child: Text(
                  'flight_updates.no_changes'.tr(),
                  style: AppTextStyles.font12Regular.copyWith(
                    color: colors.textHint,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _UpdatePreview extends StatelessWidget {
  final FlightUpdateModel update;
  const _UpdatePreview({required this.update});

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    final field = update.field.split('.').last;

    return Row(
      children: [
        Container(
          width: rw(4),
          height: rw(4),
          decoration: BoxDecoration(
            color: AppColors.secondary200,
            shape: BoxShape.circle,
          ),
        ),
        horizontalSpacing(8),
        Expanded(
          child: Text(
            '$field: ${_trim(update.before)} → ${_trim(update.after)}',
            style: AppTextStyles.font12Regular.copyWith(
              color: colors.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _trim(String val) {
    try {
      final dt = DateTime.parse(val).toLocal();
      return formatHm(dt);
    } catch (_) {
      return val.length > 15 ? '${val.substring(0, 12)}...' : val;
    }
  }
}
