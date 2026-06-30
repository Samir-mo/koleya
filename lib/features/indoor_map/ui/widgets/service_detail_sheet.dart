import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/shared/models/service_model.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../../../core/utils/extensions/context_ext.dart';
import '../../../../core/utils/spacing.dart';
import '../../../../core/widgets/custom_text_button.dart';

class ServiceDetailSheet extends StatelessWidget {
  final ServiceModel service;
  final VoidCallback onClose;
  final VoidCallback onNavigate;

  const ServiceDetailSheet({
    super.key,
    required this.service,
    required this.onClose,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    return Container(
      margin: EdgeInsets.fromLTRB(rw(12), 0, rw(12), rh(12)),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(rr(20)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.12),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(top: rh(10)),
            child: Container(
              width: rw(36),
              height: rh(4),
              decoration: BoxDecoration(
                color: colors.border,
                borderRadius: BorderRadius.circular(rr(2)),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(rw(16), rh(12), rw(16), rh(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(rr(12)),
                      child: service.primaryImage?.isNotEmpty == true
                          ? Image.network(
                              service.primaryImage!,
                              width: rw(72),
                              height: rh(72),
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  _placeholder(colors),
                            )
                          : _placeholder(colors),
                    ),
                    horizontalSpacing(12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  service.name,
                                  style: AppTextStyles.font16Bold.copyWith(
                                    color: AppColors.primary200,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: onClose,
                                child: Container(
                                  padding: EdgeInsets.all(rr(4)),
                                  decoration: BoxDecoration(
                                    color: colors.surfaceVariant,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    size: rr(16),
                                    color: colors.iconSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          verticalSpacing(5),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: rw(8),
                              vertical: rh(3),
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary200.withValues(
                                alpha: 0.08,
                              ),
                              borderRadius: BorderRadius.circular(rr(6)),
                            ),
                            child: Text(
                              service.categoryLabel,
                              style: AppTextStyles.font12Medium.copyWith(
                                color: AppColors.primary200,
                              ),
                            ),
                          ),
                          verticalSpacing(6),
                          Row(
                            children: [
                              Container(
                                width: rw(7),
                                height: rw(7),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: service.isOpen
                                      ? AppColors.green200
                                      : AppColors.red200,
                                ),
                              ),
                              horizontalSpacing(5),
                              Text(
                                service.isOpen
                                    ? 'indoor_map.open_now'.tr()
                                    : 'indoor_map.closed'.tr(),
                                style: AppTextStyles.font12Medium.copyWith(
                                  color: service.isOpen
                                      ? AppColors.green200
                                      : AppColors.red200,
                                ),
                              ),
                              horizontalSpacing(10),
                              Icon(
                                Icons.star_rounded,
                                size: rr(13),
                                color: AppColors.secondary200,
                              ),
                              horizontalSpacing(3),
                              Text(
                                service.rating.toStringAsFixed(1),
                                style: AppTextStyles.font12Medium.copyWith(
                                  color: colors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                verticalSpacing(12),

                Wrap(
                  spacing: rw(8),
                  runSpacing: rh(6),
                  children: [
                    if (service.hours?.isNotEmpty == true)
                      _InfoChip(
                        icon: Icons.access_time_rounded,
                        label: service.hours!,
                      ),
                    _InfoChip(
                      icon: Icons.location_on_outlined,
                      label: service.gate?.isNotEmpty == true
                          ? '${"flights.gate".tr()} ${service.gate}'
                          : service.zone.isNotEmpty
                          ? 'indoor_map.zone'.tr(
                              namedArgs: {'name': service.zone},
                            )
                          : '${"flights.terminal".tr()} ${service.terminal}',
                    ),
                    if (service.waitTime > 0)
                      _InfoChip(
                        icon: Icons.timer_outlined,
                        label: 'indoor_map.min_wait'.tr(
                          namedArgs: {'n': '${service.waitTime}'},
                        ),
                        highlight: true,
                      ),
                  ],
                ),

                if (service.description.isNotEmpty) ...[
                  verticalSpacing(10),
                  Text(
                    service.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.font12Regular.copyWith(
                      color: colors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ],

                if (service.amenities.isNotEmpty) ...[
                  verticalSpacing(10),
                  Wrap(
                    spacing: rw(6),
                    runSpacing: rh(4),
                    children: service.amenities
                        .take(4)
                        .map((a) => _TagChip(label: a))
                        .toList(),
                  ),
                ],

                verticalSpacing(14),

                CustomTextButton(
                  text: 'indoor_map.navigate'.tr(),
                  onPressed: onNavigate,
                  prefixIcon: Icon(
                    Icons.navigation_rounded,
                    color: AppColors.secondary200,
                    size: rr(18),
                  ),
                  foregroundColor: AppColors.secondary200,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder(dynamic colors) => Container(
    width: rw(72),
    height: rh(72),
    decoration: BoxDecoration(
      color: colors.surfaceVariant,
      borderRadius: BorderRadius.circular(rr(12)),
    ),
    child: Icon(
      Icons.storefront_outlined,
      size: rr(30),
      color: AppColors.primary200,
    ),
  );
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool highlight;
  const _InfoChip({
    required this.icon,
    required this.label,
    this.highlight = false,
  });
  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: rw(8), vertical: rh(5)),
      decoration: BoxDecoration(
        color: highlight
            ? AppColors.secondary200.withValues(alpha: 0.1)
            : colors.surfaceVariant,
        borderRadius: BorderRadius.circular(rr(8)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: rr(12),
            color: highlight ? AppColors.secondary200 : colors.iconSecondary,
          ),
          horizontalSpacing(4),
          Text(
            label,
            style: AppTextStyles.font12Medium.copyWith(
              color: highlight ? AppColors.secondary200 : colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String label;
  const _TagChip({required this.label});
  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: rw(8), vertical: rh(3)),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(rr(6)),
        border: Border.all(color: colors.border),
      ),
      child: Text(
        label,
        style: AppTextStyles.font12Medium.copyWith(color: AppColors.primary200),
      ),
    );
  }
}
