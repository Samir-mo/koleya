import 'package:flutter/material.dart';
import 'package:gate_buddy/core/themes/app_colors.dart';
import 'package:gate_buddy/core/themes/app_text_styles.dart';

class CustomTabBar extends StatelessWidget {
  final TabController controller;
  const CustomTabBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary200,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 2, 16, 14),
        decoration: BoxDecoration(
          color: AppColors.primary300,
          borderRadius: BorderRadius.circular(12),
        ),
        child: TabBar(
          controller: controller,
          dividerColor: Colors.transparent,
          indicator: BoxDecoration(
            color: AppColors.secondary200,
            borderRadius: BorderRadius.circular(10),
          ),
          labelStyle: AppTextStyles.font14SemiBold,
          unselectedLabelStyle: AppTextStyles.font14Regular,
          labelColor: AppColors.white,
          unselectedLabelColor: AppColors.primary50,
          tabs: const [
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 12),
                  Icon(Icons.flight_takeoff_rounded, size: 16),
                  SizedBox(width: 6),
                  Text('Departure'),
                  SizedBox(width: 12),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.flight_land_rounded, size: 16),
                  SizedBox(width: 6),
                  Text('Arrival'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
