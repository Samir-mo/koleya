import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../../../core/utils/extensions/context_ext.dart';
import '../../../../core/utils/spacing.dart';
import '../../data/models/recommendation_model.dart';

class RecommendationCard extends StatelessWidget {
  final RecommendationModel recommendation;
  final VoidCallback? onViewMaps;

  const RecommendationCard({
    super.key,
    required this.recommendation,
    this.onViewMaps,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;

    return SizedBox(
      width: rw(160),
      child: Container(
        margin: EdgeInsets.only(right: rw(12)),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(rr(16)),
          border: Border.all(color: colors.border),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(rr(15))),
              child: SizedBox(
                height: rw(120),
                width: double.infinity,
                child: recommendation.image.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: recommendation.image,
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) => Container(
                          color: colors.border,
                          child: Icon(
                            Icons.image_not_supported_rounded,
                            color: colors.textSecondary,
                          ),
                        ),
                        placeholder: (_, __) => Container(
                          color: colors.border,
                          child: const CircularProgressIndicator(),
                        ),
                      )
                    : Container(
                        color: colors.border,
                        child: Icon(
                          Icons.location_on_rounded,
                          color: colors.textSecondary,
                        ),
                      ),
              ),
            ),

            // Content
            Padding(
              padding: EdgeInsets.all(rw(10)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & Rating
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          recommendation.name,
                          style: AppTextStyles.font12Medium.copyWith(
                            color: colors.textPrimary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (recommendation.rating > 0) ...[
                        horizontalSpacing(4),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: rw(4),
                            vertical: rh(2),
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.amber200.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(rr(4)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star_rounded,
                                size: rw(10),
                                color: AppColors.amber200,
                              ),
                              Text(
                                recommendation.rating.toStringAsFixed(1),
                                style: AppTextStyles.font12Regular.copyWith(
                                  color: AppColors.amber200,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),

                  verticalSpacing(6),

                  // Category
                  Text(
                    recommendation.category,
                    style: AppTextStyles.font12Regular.copyWith(
                      color: colors.textSecondary,
                      fontSize: 10,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  verticalSpacing(8),

                  // View on Maps button
                  if (recommendation.googleMapsLink.isNotEmpty)
                    GestureDetector(
                      onTap: onViewMaps,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: rw(8),
                          vertical: rh(5),
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary200.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(rr(6)),
                          border: Border.all(
                            color: AppColors.primary200.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.map_rounded,
                              size: rw(10),
                              color: AppColors.primary200,
                            ),
                            horizontalSpacing(4),
                            Text(
                              'tracked_flight.view_maps'.tr(),
                              style: AppTextStyles.font12Regular.copyWith(
                                color: AppColors.primary200,
                                fontSize: 9,
                              ),
                            ),
                          ],
                        ),
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
