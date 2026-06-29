import 'package:flutter/material.dart';
import 'package:gate_buddy/core/themes/app_colors.dart';
import 'package:gate_buddy/core/themes/app_text_styles.dart';
import 'package:gate_buddy/core/utils/spacing.dart';

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
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary300, AppColors.primary200],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(rr(36)),
          bottomRight: Radius.circular(rr(36)),
        ),
      ),
      padding: EdgeInsets.fromLTRB(rw(24), top + rh(20), rw(24), rh(36)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showBack)
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: rw(36),
                height: rh(36),
                decoration: BoxDecoration(
                  color: AppColors.primary300,
                  borderRadius: BorderRadius.circular(rr(10)),
                ),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: AppColors.white,
                  size: rr(16),
                ),
              ),
            ),
          SizedBox(height: showBack ? rh(24) : rh(8)),
          Row(
            children: [
              Container(
                width: rw(40),
                height: rh(40),
                decoration: BoxDecoration(
                  color: AppColors.secondary200,
                  borderRadius: BorderRadius.circular(rr(10)),
                ),
                child: Icon(
                  Icons.flight_rounded,
                  color: AppColors.white,
                  size: rr(22),
                ),
              ),
              horizontalSpacing(10),
              Text(
                'GateBuddy',
                style: AppTextStyles.font18Bold.copyWith(
                  color: AppColors.secondary200,
                ),
              ),
            ],
          ),
          SizedBox(height: rh(20)),
          Text(
            title,
            style: AppTextStyles.font24Bold.copyWith(color: AppColors.white),
          ),
          SizedBox(height: rh(6)),
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
