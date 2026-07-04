import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../../../core/utils/extensions/context_ext.dart';
import '../../../../core/utils/helpers/flight_time_helpers.dart';
import '../../../../core/utils/spacing.dart';
import '../../../flights/data/models/flight_model.dart';

/// Displays a single live field-change update for the currently tracked
/// flight (fetched from `GET /flights/:id/updates`).
class FlightUpdateEntryCard extends StatelessWidget {
  final FlightUpdateModel update;
  const FlightUpdateEntryCard({super.key, required this.update});

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    final field = update.field.split('.').last;
    final label = field.isEmpty
        ? field
        : '${field[0].toUpperCase()}${field.substring(1)}';

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
            Container(
              width: rw(4),
              decoration: BoxDecoration(
                color: colors.warning,
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(14),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: rw(14),
                  vertical: rh(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'home.field_updated'.tr(args: [label]),
                            style: AppTextStyles.font14SemiBold.copyWith(
                              color: colors.textPrimary,
                            ),
                          ),
                          verticalSpacing(4),
                          Text(
                            '${_display(update.before)} → ${_display(update.after)}',
                            style: AppTextStyles.font12Regular.copyWith(
                              color: colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (update.timestamp != null) ...[
                      horizontalSpacing(12),
                      Text(
                        formatHm(update.timestamp!),
                        style: AppTextStyles.font12Medium.copyWith(
                          color: AppColors.secondary200,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _display(String val) {
    try {
      return formatHm(DateTime.parse(val).toLocal());
    } catch (_) {
      return val;
    }
  }
}
