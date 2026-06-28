import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gate_buddy/core/router/routes.dart';
import 'package:gate_buddy/core/themes/app_colors.dart';
import 'package:gate_buddy/core/utils/extensions/context_ext.dart';
import 'package:gate_buddy/core/utils/spacing.dart';
import 'package:gate_buddy/core/shared/models/service_model.dart';

class PlaceCard extends StatelessWidget {
  final ServiceModel place;

  const PlaceCard({super.key, required this.place});

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
        margin: EdgeInsets.only(bottom: rh(14)),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(rr(16)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(rr(16)),
              ),
              child: CachedNetworkImage(
                imageUrl: place.primaryImage ?? '',
                width: rw(110),
                height: rh(110),
                fit: BoxFit.cover,
                placeholder: (_, __) => _placeholder(colors.surfaceVariant),
                errorWidget: (_, __, ___) =>
                    _placeholder(colors.surfaceVariant),
              ),
            ),

            // Info
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: rw(12), vertical: rh(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name + status
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            place.name,
                            style: TextStyle(
                              fontSize: rf(14),
                              fontWeight: FontWeight.w700,
                              color: colors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: rw(6)),
                        _StatusBadge(isOpen: place.isOpen),
                      ],
                    ),

                    SizedBox(height: 4.h),

                    // Type
                    Text(
                      place.categoryLabel,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.secondary200,
                      ),
                    ),

                    SizedBox(height: 8.h),

                    // Terminal
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 13.r,
                          color: colors.iconSecondary,
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Text(
                            place.terminal.isNotEmpty
                                ? 'Terminal ${place.terminal}'
                                : place.airport,
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: colors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 8.h),

                    // Rating + price level
                    Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          size: 14.r,
                          color: AppColors.secondary200,
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          place.rating.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: colors.textPrimary,
                          ),
                        ),
                        const Spacer(),
                        _PriceLevel(level: place.priceLevel),
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
    width: 110.w,
    height: 110.h,
    color: bg,
    child: Icon(
      Icons.storefront_outlined,
      size: 36.r,
      color: AppColors.grey400,
    ),
  );
}

class _StatusBadge extends StatelessWidget {
  final bool isOpen;
  const _StatusBadge({required this.isOpen});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: (isOpen ? AppColors.green200 : AppColors.red200).withValues(
          alpha: 0.12,
        ),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        isOpen ? 'Open' : 'Closed',
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w700,
          color: isOpen ? AppColors.green200 : AppColors.red200,
        ),
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
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w700,
            color: i < level ? AppColors.secondary200 : colors.textDisabled,
          ),
        );
      }),
    );
  }
}
