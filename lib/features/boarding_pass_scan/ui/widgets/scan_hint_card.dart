import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gate_buddy/core/themes/app_colors.dart';
import 'package:gate_buddy/core/themes/app_text_styles.dart';
import 'package:gate_buddy/core/utils/spacing.dart';

class ScanHintCard extends StatelessWidget {
  const ScanHintCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: rw(24)),
      padding: EdgeInsets.symmetric(horizontal: rw(20), vertical: rh(16)),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(rr(16)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: AppColors.primary200,
            size: rr(22),
          ),
          horizontalSpacing(12),
          Expanded(
            child: Text(
              'boarding_pass.scan_hint'.tr(),
              style: AppTextStyles.font12Regular.copyWith(
                color: AppColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
