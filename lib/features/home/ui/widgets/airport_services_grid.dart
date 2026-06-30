import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../../../core/utils/extensions/context_ext.dart';
import '../../../../core/utils/spacing.dart';

class AirportServicesGrid extends StatelessWidget {
  const AirportServicesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final services = _services();
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: rw(12),
        mainAxisSpacing: rh(12),
        childAspectRatio: 2.4,
      ),
      itemCount: services.length,
      itemBuilder: (_, i) => _ServiceTile(item: services[i]),
    );
  }

  List<_ServiceItem> _services() => [
    _ServiceItem(
      icon: Icons.confirmation_number_outlined,
      labelKey: 'home.service_counters',
      color: AppColors.primary200,
      category: 'COUNTERS',
    ),
    _ServiceItem(
      icon: Icons.star_outline_rounded,
      labelKey: 'home.service_vip',
      color: AppColors.secondary200,
      category: 'VIP_SERVICES',
    ),
    _ServiceItem(
      icon: Icons.account_balance_outlined,
      labelKey: 'home.service_financial',
      color: AppColors.green200,
      category: 'FINANCIAL',
    ),
    _ServiceItem(
      icon: Icons.accessible_outlined,
      labelKey: 'home.service_accessibility',
      color: AppColors.blue200,
      category: 'ACCESSIBILITY',
    ),
    _ServiceItem(
      icon: Icons.shopping_bag_outlined,
      labelKey: 'home.service_shops',
      color: AppColors.amber200,
      category: 'SHOPS',
    ),
    _ServiceItem(
      icon: Icons.restaurant_outlined,
      labelKey: 'home.service_restaurants',
      color: AppColors.red200,
      category: 'RESTAURANTS',
    ),
  ];
}

class _ServiceItem {
  final IconData icon;
  final String labelKey;
  final Color color;
  final String category;
  const _ServiceItem({
    required this.icon,
    required this.labelKey,
    required this.color,
    required this.category,
  });
}

class _ServiceTile extends StatelessWidget {
  final _ServiceItem item;
  const _ServiceTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;

    return GestureDetector(
      onTap: () => context.pushNamed(
        Routes.servicesCategory,
        arguments: {'category': item.category},
        rootNavigator: true,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: rw(14), vertical: rh(10)),
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
        child: Row(
          children: [
            Container(
              width: rw(36),
              height: rw(36),
              decoration: BoxDecoration(
                color: item.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(rr(10)),
              ),
              child: Icon(item.icon, size: rw(18), color: item.color),
            ),
            horizontalSpacing(10),
            Expanded(
              child: Text(
                item.labelKey.tr(),
                style: AppTextStyles.font14SemiBold.copyWith(
                  color: colors.textPrimary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
