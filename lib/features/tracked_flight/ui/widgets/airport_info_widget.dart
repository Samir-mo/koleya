import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../../../core/utils/extensions/context_ext.dart';
import '../../../../core/utils/spacing.dart';
import '../../data/models/airport_model.dart';

class AirportInfoWidget extends StatelessWidget {
  final AirportModel airport;
  final VoidCallback? onCallTap;

  const AirportInfoWidget({
    super.key,
    required this.airport,
    this.onCallTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;

    return Container(
      padding: EdgeInsets.all(rw(16)),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(rr(16)),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: rw(32),
                height: rw(32),
                decoration: BoxDecoration(
                  color: AppColors.green100.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.apartment_rounded,
                  size: rw(16),
                  color: AppColors.green200,
                ),
              ),
              horizontalSpacing(10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      airport.name,
                      style: AppTextStyles.font14SemiBold.copyWith(
                        color: colors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      airport.code,
                      style: AppTextStyles.font12Regular.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          verticalSpacing(14),

          // Info Grid
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: rw(10),
            crossAxisSpacing: rw(10),
            childAspectRatio: 1.3,
            children: [
              _InfoBox(
                icon: Icons.schedule_rounded,
                label: 'tracked_flight.hours'.tr(),
                value: airport.operationHours,
              ),
              _InfoBox(
                icon: Icons.wifi_rounded,
                label: 'tracked_flight.wifi'.tr(),
                value: airport.wifi
                    ? 'tracked_flight.available'.tr()
                    : 'tracked_flight.not_available'.tr(),
                iconColor: airport.wifi ? AppColors.green200 : AppColors.grey400,
              ),
              _InfoBox(
                icon: Icons.local_parking_rounded,
                label: 'tracked_flight.parking'.tr(),
                value: airport.parkingSpaces > 0
                    ? '${airport.parkingSpaces} ${'tracked_flight.parking_spaces'.tr()}'
                    : 'N/A',
              ),
              if (airport.contactCenter.isNotEmpty)
                _ContactBox(
                  onTap: onCallTap,
                  contact: airport.contactCenter,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? iconColor;

  const _InfoBox({
    required this.icon,
    required this.label,
    required this.value,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    final accent = iconColor ?? AppColors.blue200;

    return Container(
      padding: EdgeInsets.all(rw(10)),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(rr(12)),
        border: Border.all(color: colors.border.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: rw(14), color: accent),
              horizontalSpacing(4),
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.font12Regular.copyWith(
                    color: colors.textSecondary,
                    fontSize: 10,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: AppTextStyles.font12Regular.copyWith(
              color: colors.textPrimary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _ContactBox extends StatelessWidget {
  final VoidCallback? onTap;
  final String contact;

  const _ContactBox({
    required this.onTap,
    required this.contact,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(rw(10)),
        decoration: BoxDecoration(
          color: AppColors.amber200.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(rr(12)),
          border: Border.all(color: AppColors.amber200.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.phone_rounded, size: rw(14), color: AppColors.amber200),
                horizontalSpacing(4),
                Expanded(
                  child: Text(
                    'tracked_flight.call'.tr(),
                    style: AppTextStyles.font12Regular.copyWith(
                      color: colors.textSecondary,
                      fontSize: 10,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Text(
              contact,
              style: AppTextStyles.font12Regular.copyWith(
                color: AppColors.amber200,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
