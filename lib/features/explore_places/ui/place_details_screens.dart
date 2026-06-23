import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gate_buddy/core/themes/app_colors.dart';
import 'package:gate_buddy/core/utils/extensions/context_ext.dart';
import 'package:gate_buddy/core/utils/spacing.dart';
import 'package:gate_buddy/features/explore_places/data/models/place_of_service_model.dart';

class PlaceDetailsScreen extends StatelessWidget {
  final PlaceOfServiceModel place;

  const PlaceDetailsScreen({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customColors.background,
      body: Column(
        children: [
          // Dark Blue Header
          _buildHeader(context),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero Image
                  Stack(
                    children: [
                      ClipRRect(
                        child: CachedNetworkImage(
                          imageUrl:
                              place.image ??
                              'https://via.placeholder.com/375x240',
                          height: 240,
                          width: double.infinity,
                          fit: BoxFit.cover,

                          placeholder: (context, url) => Container(
                            height: 240,
                            width: double.infinity,
                            color: AppColors.grey100,
                            alignment: Alignment.center,
                            child: const CircularProgressIndicator.adaptive(),
                          ),

                          errorWidget: (context, url, error) => Container(
                            height: 240,
                            width: double.infinity,
                            color: AppColors.grey200,
                            alignment: Alignment.center,
                            child: const Icon(Icons.image, size: 80),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.secondary200,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.white,
                                size: 18,
                              ),
                              Text(
                                " ${place.rating?.toStringAsFixed(1) ?? '4.5'}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name + Category
                        Text(
                          place.name,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: context.customColors.textPrimary,
                              ),
                        ),
                        verticalSpacing(4),
                        Text(
                          place.category ?? "COFFEE",
                          style: TextStyle(
                            color: AppColors.secondary200,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        verticalSpacing(12),

                        // Location
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: AppColors.grey500,
                              size: 20,
                            ),
                            horizontalSpacing(6),
                            Expanded(
                              child: Text(
                                place.zone ?? "Gate 3, Terminal 3",
                                style: TextStyle(
                                  color: context.customColors.textSecondary,
                                ),
                              ),
                            ),
                            if (place.isOpen)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.green200.withValues(
                                    alpha: 0.15,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  "OPEN",
                                  style: TextStyle(
                                    color: AppColors.green200,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                          ],
                        ),

                        verticalSpacing(24),

                        // Description
                        Text(
                          "Description",
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        verticalSpacing(8),
                        Text(
                          place.description.isNotEmpty
                              ? place.description
                              : "A cozy coffee spot located near Gate 3 offering premium beverages and light snacks. Perfect for a quick break during your layover.",
                          style: TextStyle(
                            color: context.customColors.textSecondary,
                            height: 1.5,
                          ),
                        ),

                        verticalSpacing(28),

                        // Opening Hours
                        _buildOpeningHours(),

                        verticalSpacing(28),

                        // Facilities / Amenities
                        Text(
                          "Facilities",
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        verticalSpacing(12),
                        _buildFacilities(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Action Buttons
          _buildBottomActions(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 110,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(color: AppColors.primary200),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.bookmark_border, color: Colors.white),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOpeningHours() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Opening Hours",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        verticalSpacing(12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Today"),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.green200.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "OPEN",
                    style: TextStyle(
                      color: AppColors.green200,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                horizontalSpacing(8),
                const Text(
                  "08:00 - 22:00",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFacilities() {
    final facilities = ["WiFi", "Power Outlet", "Seating Area", "Takeaway"];
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: facilities.map((facility) {
        return Chip(
          label: Text(facility),
          backgroundColor: AppColors.grey100,
          side: BorderSide.none,
        );
      }).toList(),
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.directions),
              label: const Text("Directions"),
            ),
          ),
          horizontalSpacing(12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.phone),
              label: const Text("Call"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary200,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
