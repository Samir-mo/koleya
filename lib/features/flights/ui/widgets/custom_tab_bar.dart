import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../../../core/utils/spacing.dart';

class CustomTabBar extends StatelessWidget {
  final TabController controller;
  const CustomTabBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary200,
      child: Container(
        margin: EdgeInsets.fromLTRB(rw(16), rh(2), rw(16), rh(14)),
        decoration: BoxDecoration(
          color: AppColors.primary300,
          borderRadius: BorderRadius.circular(rr(12)),
        ),
        child: TabBar(
          controller: controller,
          dividerColor: Colors.transparent,
          indicator: BoxDecoration(
            color: AppColors.secondary200,
            borderRadius: BorderRadius.circular(rr(10)),
          ),
          labelStyle: AppTextStyles.font14SemiBold,
          unselectedLabelStyle: AppTextStyles.font14Regular,
          labelColor: AppColors.white,
          unselectedLabelColor: AppColors.primary50,
          tabs: [
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: rw(12)),
                  const Icon(Icons.flight_takeoff_rounded, size: 16),
                  SizedBox(width: rw(6)),
                  Text('flights.departure'.tr()),
                  SizedBox(width: rw(12)),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.flight_land_rounded, size: 16),
                  SizedBox(width: rw(6)),
                  Text('flights.arrival'.tr()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
