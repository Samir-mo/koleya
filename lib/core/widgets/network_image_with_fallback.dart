import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../themes/app_colors.dart';
import 'loading_shimmer.dart';

/// Reusable cached network image with loading shimmer and error fallback
/// Uses CachedNetworkImage for efficient disk/memory caching.
/// Shows shimmer while loading, error placeholder if load fails.
///
/// Usage:
///   NetworkImageWithFallback(
///     imageUrl: 'https://...',
///     width: 100,
///     height: 100,
///   )
///   NetworkImageWithFallback(
///     imageUrl: 'https://...',
///     width: double.infinity,
///     height: 200,
///     borderRadius: 12,
///     fallbackIcon: Icons.no_photography_outlined,
///   )
class NetworkImageWithFallback extends StatelessWidget {
  const NetworkImageWithFallback({
    super.key,
    required this.imageUrl,
    required this.width,
    required this.height,
    this.borderRadius = 0,
    this.fit = BoxFit.cover,
    this.fallbackIcon = Icons.broken_image_outlined,
    this.fallbackColor = AppColors.grey300,
  });

  final String? imageUrl;
  final double width;
  final double height;
  final double borderRadius;
  final BoxFit fit;
  final IconData fallbackIcon;
  final Color fallbackColor;

  Widget _buildFallback() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Center(
        child: Icon(
          fallbackIcon,
          size: 40,
          color: fallbackColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return _buildFallback();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
        imageUrl: imageUrl!,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => LoadingShimmer.card(
          width: width,
          height: height,
          borderRadius: borderRadius,
        ),
        errorWidget: (context, url, error) => _buildFallback(),
      ),
    );
  }
}
