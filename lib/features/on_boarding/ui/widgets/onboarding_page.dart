import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gate_buddy/core/themes/app_colors.dart';
import 'package:gate_buddy/core/themes/app_text_styles.dart';
import 'package:gate_buddy/core/utils/extensions/context_ext.dart';
import 'package:gate_buddy/core/utils/spacing.dart';
import 'package:gate_buddy/core/widgets/custom_text_button.dart';
import 'package:gate_buddy/features/on_boarding/data/models/onboarding_page_data.dart';
import 'package:gate_buddy/features/on_boarding/ui/widgets/onboarding_dot_indicator.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({
    super.key,
    required this.data,
    required this.currentIndex,
    required this.totalPages,
    required this.onNext,
    required this.onSkip,
    required this.onBack,
  });

  final OnboardingPageData data;
  final int currentIndex;
  final int totalPages;
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final VoidCallback onBack;

  bool get _isFirst => currentIndex == 0;
  bool get _isLast => currentIndex == totalPages - 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Top image area ────────────────────────────────────────────
        Expanded(
          flex: 6,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                data.imagePath,
                fit: BoxFit.cover,
              ).animate(key: ValueKey(currentIndex)).fadeIn(duration: 300.ms),

              // Back arrow (pages 2 & 3)
              if (!_isFirst)
                Positioned(
                  top: rh(16),
                  left: rw(16),
                  child: GestureDetector(
                    onTap: onBack,
                    child: Container(
                      padding: EdgeInsets.all(rw(8)),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: AppColors.white,
                        size: rr(20),
                      ),
                    ),
                  ),
                ).animate().fadeIn(duration: 250.ms),

              // Skip button (all pages)
              Positioned(
                top: rh(16),
                right: rw(16),
                child: GestureDetector(
                  onTap: onSkip,
                  child: Text(
                    'onboarding.skip'.tr(),
                    style: AppTextStyles.font14SemiBold.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // ── Bottom sheet area ─────────────────────────────────────────
        Expanded(
          flex: 4,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: context.customColors.surface,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(rr(28)),
                topRight: Radius.circular(rr(28)),
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: rw(24), vertical: rh(28)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Title
                Text(
                      data.titleKey.tr(),
                      style: AppTextStyles.font18Bold.copyWith(
                        color: context.customColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    )
                    .animate(key: ValueKey('title_$currentIndex'))
                    .fadeIn(duration: 300.ms)
                    .slideY(begin: 0.1, end: 0),

                // Dots
                OnboardingDotIndicator(
                  totalDots: totalPages,
                  currentIndex: currentIndex,
                ),

                // Next button
                CustomTextButton(
                      text: _isLast
                          ? 'onboarding.get_started'.tr()
                          : 'onboarding.next'.tr(),
                      onPressed: onNext,
                      backgroundColor: _isLast
                          ? AppColors.secondary200
                          : AppColors.primary200,
                    )
                    .animate(key: ValueKey('btn_$currentIndex'))
                    .fadeIn(duration: 250.ms)
                    .slideY(begin: 0.1, end: 0),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
