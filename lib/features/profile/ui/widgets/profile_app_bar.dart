import 'package:flutter/material.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../../../core/utils/extensions/context_ext.dart';
import '../../../../core/utils/spacing.dart';

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
      padding: EdgeInsets.only(
        top: rh(44),
        left: rw(16),
        right: rw(16),
        bottom: rh(16),
      ),
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
        ],
      ),
    );
  }
}
