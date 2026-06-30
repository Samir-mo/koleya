import 'package:flutter/material.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../../../core/utils/spacing.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(rw(20), rh(12), rw(20), rh(12)),
      child: Row(
        children: [
          _IconBtn(
            icon: Icons.search_rounded,
            onTap: () => Navigator.of(
              context,
              rootNavigator: true,
            ).pushNamed(Routes.search),
          ),
          const Spacer(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.flight_rounded,
                color: AppColors.secondary200,
                size: rw(18),
              ),
              horizontalSpacing(6),
              Text(
                'GateBuddy',
                style: AppTextStyles.font20Bold.copyWith(
                  color: AppColors.white,
                ),
              ),
            ],
          ),
          const Spacer(),
          _IconBtn(
            icon: Icons.person_outline_rounded,
            onTap: () => Navigator.of(
              context,
              rootNavigator: true,
            ).pushNamed(Routes.profile),
          ),
        ],
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: rw(40),
        height: rw(40),
        decoration: const BoxDecoration(
          color: AppColors.primary300,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.secondary200, size: rw(20)),
      ),
    );
  }
}
