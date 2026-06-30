import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../../../core/utils/extensions/context_ext.dart';
import '../../../../core/utils/spacing.dart';

class ScanBoardingPassCard extends StatelessWidget {
  const ScanBoardingPassCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          context.pushNamed(Routes.boardingPassScan, rootNavigator: true),
      child: Container(
        padding: EdgeInsets.all(rw(16)),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary200, AppColors.primary300],
          ),
          borderRadius: BorderRadius.circular(rr(16)),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary200.withValues(alpha: 0.25),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: rw(52),
              height: rw(52),
              decoration: BoxDecoration(
                color: AppColors.secondary200.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(rr(14)),
                border: Border.all(color: AppColors.secondary200),
              ),
              child: Icon(
                Icons.qr_code_scanner_rounded,
                color: AppColors.secondary200,
                size: rw(28),
              ),
            ),
            horizontalSpacing(14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'home.scan_boarding_pass_title'.tr(),
                    style: AppTextStyles.font16Bold.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                  verticalSpacing(4),
                  Text(
                    'home.scan_boarding_pass_subtitle'.tr(),
                    style: AppTextStyles.font12Regular.copyWith(
                      color: AppColors.primary50,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.secondary200,
              size: rw(16),
            ),
          ],
        ),
      ),
    );
  }
}
