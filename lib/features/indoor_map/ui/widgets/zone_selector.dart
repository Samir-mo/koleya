import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gate_buddy/core/themes/app_colors.dart';
import 'package:gate_buddy/core/themes/app_text_styles.dart';

class ZoneSelector extends StatelessWidget {
  final String selectedZone;
  final ValueChanged<String> onZoneChanged;

  static const zones = ['All', '0', '1', '2'];
  static const zoneLabels = {'All': 'All', '0': 'G', '1': 'F1', '2': 'F2'};

  const ZoneSelector({
    super.key,
    required this.selectedZone,
    required this.onZoneChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: zones.map((zone) {
          final isSelected = zone == selectedZone;
          return GestureDetector(
            onTap: () => onZoneChanged(zone),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.symmetric(vertical: 2.h),
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary200 : Colors.transparent,
                borderRadius: BorderRadius.circular(10.r),
              ),
              alignment: Alignment.center,
              child: Text(
                zoneLabels[zone]!,
                style: AppTextStyles.font12Bold.copyWith(
                  color: isSelected ? Colors.white : Colors.grey[600],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
