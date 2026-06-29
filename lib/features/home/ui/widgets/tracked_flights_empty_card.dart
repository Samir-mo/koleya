import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gate_buddy/core/themes/app_colors.dart';
import 'package:gate_buddy/core/themes/app_text_styles.dart';
import 'package:gate_buddy/core/utils/extensions/context_ext.dart';
import 'package:gate_buddy/core/utils/spacing.dart';
import 'package:gate_buddy/core/widgets/custom_text_button.dart';
import 'package:gate_buddy/features/main_navigation/ui/main_scaffold.dart';

class TrackedFlightsEmptyCard extends StatelessWidget {
  const TrackedFlightsEmptyCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: rw(20), vertical: rh(20)),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(rr(14)),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        children: [
          Container(
            width: rw(52),
            height: rw(52),
            decoration: BoxDecoration(
              color: AppColors.primary200.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.flight_rounded,
                size: rw(24), color: AppColors.primary200),
          ),
          verticalSpacing(12),
          Text(
            'tracked_flight.no_tracking'.tr(),
            style: AppTextStyles.font14SemiBold
                .copyWith(color: colors.textPrimary),
            textAlign: TextAlign.center,
          ),
          verticalSpacing(4),
          Text(
            'tracked_flight.no_tracking_hint'.tr(),
            style: AppTextStyles.font12Regular
                .copyWith(color: colors.textSecondary),
            textAlign: TextAlign.center,
          ),
          verticalSpacing(16),
          CustomTextButton(
            text: 'tracked_flight.find_flight'.tr(),
            size: CustomButtonSize.small,
            isFullWidth: false,
            onPressed: () => MainScaffold.jumpToTab(MainScaffold.tabFlights),
            prefixIcon: const Icon(Icons.search_rounded),
          ),
        ],
      ),
    );
  }
}
