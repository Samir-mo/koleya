import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../../../core/utils/extensions/context_ext.dart';
import '../../../../core/utils/spacing.dart';
import '../../../../core/shared/models/service_model.dart';

class FeaturedPlaceCard extends StatelessWidget {
  final ServiceModel place;

  const FeaturedPlaceCard({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    return GestureDetector(
      onTap: () => context.pushNamed(
        Routes.placeDetailsScreen,
        rootNavigator: true,
        arguments: {'place': place},
      ),
      child: Container(
        width: rw(200),
        margin: EdgeInsets.only(right: rw(14)),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(rr(18)),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.08),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(rr(18)),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: place.primaryImage ?? '',
                    height: rh(130),
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      height: rh(130),
                      color: colors.surfaceVariant,
                      child: Icon(
                        Icons.storefront_outlined,
                        size: rr(40),
                        color: AppColors.grey400,
                      ),
                    ),
                    errorWidget: (_, __, ___) => Container(
                      height: rh(130),
                      color: colors.surfaceVariant,
                      child: Icon(
                        Icons.storefront_outlined,
                        size: rr(40),
                        color: AppColors.grey400,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: rh(10),
                  right: rw(10),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: rw(8),
                      vertical: rh(4),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.secondary200,
                      borderRadius: BorderRadius.circular(rr(20)),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          color: AppColors.white,
                          size: rr(12),
                        ),
                        horizontalSpacing(3),
                        Text(
                          place.rating.toStringAsFixed(1),
                          style: AppTextStyles.font12Bold.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: EdgeInsets.all(rw(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.name,
                    style: AppTextStyles.font12Bold.copyWith(
                      color: colors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  verticalSpacing(4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: rr(12),
                        color: colors.iconSecondary,
                      ),
                      horizontalSpacing(2),
                      Expanded(
                        child: Text(
                          place.terminal.isNotEmpty
                              ? '${"flights.terminal".tr()} ${place.terminal}'
                              : place.airport,
                          style: AppTextStyles.font12Regular.copyWith(
                            color: colors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  verticalSpacing(6),
                  Text(
                    place.categoryLabel,
                    style: AppTextStyles.font12Medium.copyWith(
                      color: AppColors.secondary200,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
