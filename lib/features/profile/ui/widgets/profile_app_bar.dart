import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gate_buddy/core/themes/app_colors.dart';
import 'package:gate_buddy/core/themes/app_text_styles.dart';
import 'package:gate_buddy/core/utils/extensions/context_ext.dart';
import 'package:gate_buddy/core/utils/spacing.dart';

class ProfileAppBar extends StatelessWidget {
  final String title;

  final bool showEdit;
  final VoidCallback? onEdit;

  const ProfileAppBar({
    super.key,
    required this.title,
    required this.showEdit,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary200,
      padding: EdgeInsets.only(top: rh(44), left: rw(16), right: rw(16), bottom: rh(16)),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded),
            color: AppColors.white,
            onPressed: context.pop,
          ),
          horizontalSpacing(16),
          Text(
            title,
            style: AppTextStyles.font20Bold.copyWith(color: AppColors.white),
          ),
          const Spacer(),
          if (showEdit)
            GestureDetector(
              onTap: onEdit,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: rw(12), vertical: rh(6)),
                decoration: BoxDecoration(
                  color: AppColors.primary300,
                  borderRadius: BorderRadius.circular(rr(20)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.edit_outlined, size: rr(14), color: AppColors.secondary200),
                    horizontalSpacing(4),
                    Text(
                      'profile.edit_button'.tr(),
                      style: AppTextStyles.font12Medium.copyWith(
                        color: AppColors.secondary200,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
