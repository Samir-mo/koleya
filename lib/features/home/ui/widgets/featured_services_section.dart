import 'package:flutter/material.dart';
import 'package:gate_buddy/core/themes/app_colors.dart';
import 'package:gate_buddy/core/themes/app_text_styles.dart';
import 'package:gate_buddy/core/utils/extensions/context_ext.dart';
import 'package:gate_buddy/core/utils/spacing.dart';
import 'package:gate_buddy/features/home/data/models/home_model.dart';

class FeaturedServicesSection extends StatelessWidget {
  final List<FeaturedServiceModel> services;
  const FeaturedServicesSection({super.key, required this.services});

  @override
  Widget build(BuildContext context) {
    if (services.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: rh(155),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: services.length,
        separatorBuilder: (_, __) => horizontalSpacing(12),
        itemBuilder: (_, i) => _ServiceCard(service: services[i]),
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final FeaturedServiceModel service;
  const _ServiceCard({required this.service});

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    final categoryColor = _categoryColor(service.category);

    return Container(
      width: rw(180),
      padding: EdgeInsets.all(rw(14)),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(rr(16)),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: rw(36),
                height: rw(36),
                decoration: BoxDecoration(
                  color: categoryColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(rr(10)),
                ),
                child: Icon(
                  _categoryIcon(service.category),
                  size: rw(18),
                  color: categoryColor,
                ),
              ),
              const Spacer(),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.star_rounded,
                    size: rw(13),
                    color: AppColors.secondary200,
                  ),
                  horizontalSpacing(3),
                  Text(
                    service.rating.toStringAsFixed(1),
                    style: AppTextStyles.font12Medium.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          verticalSpacing(10),
          Text(
            service.name,
            style: AppTextStyles.font14SemiBold.copyWith(
              color: colors.textPrimary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: rw(11),
                color: colors.textHint,
              ),
              horizontalSpacing(3),
              Expanded(
                child: Text(
                  service.zone.isNotEmpty ? service.zone : service.terminal,
                  style: AppTextStyles.font12Regular.copyWith(
                    color: colors.textHint,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (service.operatingHours.isNotEmpty) ...[
            verticalSpacing(3),
            Row(
              children: [
                Icon(
                  Icons.access_time_rounded,
                  size: rw(11),
                  color: colors.textHint,
                ),
                horizontalSpacing(3),
                Text(
                  service.operatingHours,
                  style: AppTextStyles.font12Regular.copyWith(
                    color: colors.textHint,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Color _categoryColor(String cat) {
    switch (cat.toUpperCase()) {
      case 'VIP_SERVICES':
        return AppColors.secondary200;
      case 'RESTAURANTS':
        return AppColors.red200;
      case 'SHOPS':
        return AppColors.blue200;
      case 'FINANCIAL':
        return AppColors.green200;
      case 'ACCESSIBILITY':
        return AppColors.amber200;
      default:
        return AppColors.primary200;
    }
  }

  IconData _categoryIcon(String cat) {
    switch (cat.toUpperCase()) {
      case 'VIP_SERVICES':
        return Icons.star_outline_rounded;
      case 'RESTAURANTS':
        return Icons.restaurant_outlined;
      case 'SHOPS':
        return Icons.shopping_bag_outlined;
      case 'FINANCIAL':
        return Icons.account_balance_outlined;
      case 'ACCESSIBILITY':
        return Icons.accessible_outlined;
      case 'COUNTERS':
        return Icons.check_circle_outline_rounded;
      default:
        return Icons.local_airport_rounded;
    }
  }
}

// â”€â”€ Section title helper used by HomeScreen â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class HomeSectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const HomeSectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    return Row(
      children: [
        Container(
          width: rw(3),
          height: rh(16),
          decoration: BoxDecoration(
            color: AppColors.primary200,
            borderRadius: BorderRadius.circular(rr(2)),
          ),
        ),
        horizontalSpacing(8),
        Text(
          title,
          style: AppTextStyles.font16Bold.copyWith(color: colors.textPrimary),
        ),
        if (actionLabel != null) ...[
          const Spacer(),
          GestureDetector(
            onTap: onAction,
            child: Text(
              actionLabel!,
              style: AppTextStyles.font14SemiBold.copyWith(
                color: AppColors.secondary200,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
