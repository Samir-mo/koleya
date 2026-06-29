import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gate_buddy/core/router/routes.dart';
import 'package:gate_buddy/core/themes/app_colors.dart';
import 'package:gate_buddy/core/themes/app_text_styles.dart';
import 'package:gate_buddy/core/utils/extensions/context_ext.dart';
import 'package:gate_buddy/core/utils/spacing.dart';
import 'package:gate_buddy/core/shared/models/service_model.dart';

class ServiceListItem extends StatelessWidget {
  final ServiceModel service;

  const ServiceListItem({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    return GestureDetector(
      onTap: () => context.pushNamed(
        Routes.placeDetailsScreen,
        rootNavigator: true,
        arguments: {'place': service},
      ),
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(rr(16)),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius:
                  BorderRadius.horizontal(left: Radius.circular(rr(16))),
              child: CachedNetworkImage(
                imageUrl: service.primaryImage ?? '',
                width: rw(110),
                height: rh(110),
                fit: BoxFit.cover,
                placeholder: (_, __) => _placeholder(colors.surfaceVariant),
                errorWidget: (_, __, ___) =>
                    _placeholder(colors.surfaceVariant),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: rw(12), vertical: rh(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            service.name,
                            style: AppTextStyles.font14Bold
                                .copyWith(color: colors.textPrimary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        horizontalSpacing(6),
                        _StatusBadge(isOpen: service.isOpen),
                      ],
                    ),
                    verticalSpacing(4),
                    Text(
                      service.categoryLabel,
                      style: AppTextStyles.font12Medium
                          .copyWith(color: AppColors.secondary200),
                    ),
                    verticalSpacing(8),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: rr(13),
                          color: colors.iconSecondary,
                        ),
                        horizontalSpacing(3),
                        Expanded(
                          child: Text(
                            service.terminal.isNotEmpty
                                ? '${"flights.terminal".tr()} ${service.terminal}'
                                : service.airport,
                            style: AppTextStyles.font12Regular
                                .copyWith(color: colors.textSecondary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    verticalSpacing(8),
                    Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          size: rr(14),
                          color: AppColors.secondary200,
                        ),
                        horizontalSpacing(3),
                        Text(
                          service.rating.toStringAsFixed(1),
                          style: AppTextStyles.font12Medium
                              .copyWith(color: colors.textPrimary),
                        ),
                        const Spacer(),
                        _PriceLevel(level: service.priceLevel),
                      ],
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

  Widget _placeholder(Color bg) => Container(
        width: rw(110),
        height: rh(110),
        color: bg,
        child: Icon(Icons.storefront_outlined,
            size: rr(36), color: AppColors.grey400),
      );
}

class _StatusBadge extends StatelessWidget {
  final bool isOpen;
  const _StatusBadge({required this.isOpen});

  @override
  Widget build(BuildContext context) {
    final color = isOpen ? AppColors.green200 : AppColors.red200;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: rw(7), vertical: rh(2)),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(rr(20)),
      ),
      child: Text(
        isOpen ? 'explore_places.open_short'.tr() : 'explore_places.closed'.tr(),
        style: AppTextStyles.font12Bold.copyWith(color: color),
      ),
    );
  }
}

class _PriceLevel extends StatelessWidget {
  final int level;
  const _PriceLevel({required this.level});

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    return Row(
      children: List.generate(4, (i) {
        return Text(
          '\$',
          style: AppTextStyles.font12Bold.copyWith(
            color: i < level ? AppColors.secondary200 : colors.textDisabled,
          ),
        );
      }),
    );
  }
}
