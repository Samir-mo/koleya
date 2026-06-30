import 'package:flutter/material.dart';
import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';
import '../utils/spacing.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary200,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.flight_rounded,
              color: AppColors.secondary200,
              size: 64,
            ),
            verticalSpacing(16),
            Text('GateBuddy', style: AppTextStyles.font20Bold),
            verticalSpacing(16),
            const CircularProgressIndicator(
              color: AppColors.secondary200,
              strokeWidth: 2,
            ),
          ],
        ),
      ),
    );
  }
}
