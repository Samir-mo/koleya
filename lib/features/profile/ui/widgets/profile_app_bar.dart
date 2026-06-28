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
      padding: EdgeInsets.only(top: 44, left: 16, right: 16, bottom: 16),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary300,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.edit_outlined,
                      size: 14,
                      color: AppColors.secondary200,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Edit',
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
