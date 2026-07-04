import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../../../core/utils/extensions/context_ext.dart';
import '../../../../core/utils/spacing.dart';
import '../../data/models/weather_model.dart';

class WeatherInfoWidget extends StatelessWidget {
  final WeatherModel weather;
  final String label;

  const WeatherInfoWidget({
    super.key,
    required this.weather,
    this.label = 'tracked_flight.weather',
  });

  @override
  Widget build(BuildContext context) {
    final isUnavailable = weather.condition == 'Unavailable';
    final colors = context.customColors;

    return Container(
      padding: EdgeInsets.all(rw(16)),
      decoration: BoxDecoration(
        color: AppColors.blue100.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(rr(16)),
        border: Border.all(color: AppColors.blue100.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: rw(32),
                height: rw(32),
                decoration: BoxDecoration(
                  color: AppColors.blue100.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.cloud_rounded,
                  size: rw(16),
                  color: AppColors.blue200,
                ),
              ),
              horizontalSpacing(10),
              Text(
                label.tr(),
                style: AppTextStyles.font14SemiBold.copyWith(
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
          verticalSpacing(12),
          if (isUnavailable)
            Text(
              'tracked_flight.weather_unavailable'.tr(),
              style: AppTextStyles.font12Regular.copyWith(
                color: colors.textSecondary,
              ),
            )
          else
            Row(
              children: [
                Text(
                  weather.temperature,
                  style: AppTextStyles.font24Bold.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
                horizontalSpacing(10),
                Expanded(
                  child: Text(
                    weather.condition,
                    style: AppTextStyles.font14Regular.copyWith(
                      color: colors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
