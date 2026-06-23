import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gate_buddy/core/router/routes.dart';
import 'package:gate_buddy/core/themes/app_colors.dart';
import 'package:gate_buddy/core/utils/extensions/context_ext.dart';
import 'package:gate_buddy/core/utils/spacing.dart';
import 'package:gate_buddy/features/explore_places/data/models/place_of_service_model.dart';

class PlaceCard extends StatelessWidget {
  final PlaceOfServiceModel place;

  const PlaceCard({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(
          Routes.placeDetailsScreen,
          rootNavigator: true,
          arguments: {'place': place},
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: context.customColors.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: CachedNetworkImage(
                imageUrl: place.image ?? 'https://via.placeholder.com/400x200',
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,

                placeholder: (context, url) => Container(
                  height: 180,
                  color: AppColors.grey100,
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(),
                ),

                errorWidget: (context, url, error) => Container(
                  height: 180,
                  color: AppColors.grey200,
                  alignment: Alignment.center,
                  child: const Icon(Icons.image_not_supported, size: 48),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          place.name,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (place.isOpen)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.green200.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            "OPEN",
                            style: TextStyle(
                              color: AppColors.green200,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  verticalSpacing(4),
                  Text(
                    place.category ?? '',
                    style: TextStyle(
                      color: AppColors.secondary200,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  verticalSpacing(8),

                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: AppColors.secondary200,
                        size: 18,
                      ),
                      Text(
                        " ${place.rating?.toStringAsFixed(1) ?? '4.5'}",
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const Spacer(),
                      Text(
                        place.zone ?? '',
                        style: TextStyle(
                          color: context.customColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
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
