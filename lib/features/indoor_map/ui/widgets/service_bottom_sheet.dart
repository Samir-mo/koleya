import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gate_buddy/core/themes/app_colors.dart';
import 'package:gate_buddy/core/themes/app_text_styles.dart';
import 'package:gate_buddy/features/indoor_map/data/models/map_service_model.dart';

class ServiceBottomSheet extends StatelessWidget {
  final MapServiceModel service;
  final VoidCallback onClose;

  const ServiceBottomSheet({
    super.key,
    required this.service,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 12.h),
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),

          // Image
          if (service.images.isNotEmpty)
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              height: 140.h,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                image: DecorationImage(
                  image: NetworkImage(service.images.first),
                  fit: BoxFit.cover,
                ),
              ),
            ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name + status
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        service.name,
                        style: AppTextStyles.font18Bold,
                      ),
                    ),
                    _StatusBadge(status: service.status),
                  ],
                ),
                SizedBox(height: 4.h),

                // Category + zone
                Text(
                  '${service.category}  •  Zone ${service.zone}',
                  style: AppTextStyles.font12Regular.copyWith(
                    color: Colors.grey[500],
                  ),
                ),
                SizedBox(height: 8.h),

                // Description
                Text(service.description, style: AppTextStyles.font14Regular),
                SizedBox(height: 12.h),

                // Info row
                Row(
                  children: [
                    _InfoChip(
                      icon: Icons.access_time_rounded,
                      label: service.operatingHours,
                    ),
                    SizedBox(width: 8.w),
                    if (service.gate != null)
                      _InfoChip(
                        icon: Icons.door_sliding_outlined,
                        label: service.gate!,
                      ),
                  ],
                ),
                SizedBox(height: 12.h),

                // Amenities
                if (service.amenities.isNotEmpty) ...[
                  Text('Amenities', style: AppTextStyles.font14Bold),
                  SizedBox(height: 6.h),
                  Wrap(
                    spacing: 6.w,
                    runSpacing: 6.h,
                    children: service.amenities
                        .map((a) => _Tag(label: a))
                        .toList(),
                  ),
                  SizedBox(height: 16.h),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final isOpen = status.toLowerCase() == 'open';
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isOpen
            ? AppColors.primary200.withOpacity(0.15)
            : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        status,
        style: AppTextStyles.font12Bold.copyWith(
          color: isOpen ? AppColors.primary200 : Colors.red,
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14.sp, color: Colors.grey[500]),
        SizedBox(width: 4.w),
        Text(
          label,
          style: AppTextStyles.font12Regular.copyWith(color: Colors.grey[600]),
        ),
      ],
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  const _Tag({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Text(label, style: AppTextStyles.font12Regular),
    );
  }
}
