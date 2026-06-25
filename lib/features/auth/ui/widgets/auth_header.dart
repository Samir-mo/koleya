import 'package:flutter/material.dart';
import 'package:gate_buddy/core/themes/app_colors.dart';
import 'package:gate_buddy/core/themes/app_text_styles.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool showBack;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.showBack = true,
  });

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary300, AppColors.primary200],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(36),
          bottomRight: Radius.circular(36),
        ),
      ),
      padding: EdgeInsets.fromLTRB(24, top + 20, 24, 36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showBack)
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primary300,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: AppColors.white,
                  size: 16,
                ),
              ),
            ),
          SizedBox(height: showBack ? 24 : 8),
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.secondary200,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.flight_rounded,
                  color: AppColors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'GateBuddy',
                style: AppTextStyles.font18Bold.copyWith(
                  color: AppColors.secondary200,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: AppTextStyles.font24Bold.copyWith(color: AppColors.white),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: AppTextStyles.font14Regular.copyWith(
              color: AppColors.primary50,
            ),
          ),
        ],
      ),
    );
  }
}
