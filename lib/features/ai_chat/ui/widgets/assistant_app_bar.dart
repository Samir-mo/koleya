import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../../../core/utils/spacing.dart';

class AssistantAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AssistantAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height + MediaQuery.of(context).padding.top,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: rw(16),
        right: rw(16),
      ),
      decoration: BoxDecoration(
        color: AppColors.primary200,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(rr(20))),
      ),
      child: Row(
        children: [
          Container(
            width: rw(40),
            height: rh(40),
            decoration: BoxDecoration(
              color: AppColors.primary300,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.secondary200, width: 1.5),
            ),
            child: Icon(
              Icons.smart_toy_rounded,
              color: AppColors.secondary200,
              size: rr(22),
            ),
          ),
          horizontalSpacing(12),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ai_chat.assistant_name'.tr(),
                style: AppTextStyles.font16Bold.copyWith(
                  color: AppColors.white,
                ),
              ),
              Row(
                children: [
                  Container(
                    width: rw(7),
                    height: rw(7),
                    decoration: const BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                    ),
                  ),
                  horizontalSpacing(5),
                  Text(
                    'ai_chat.online_status'.tr(),
                    style: AppTextStyles.font12Regular.copyWith(
                      color: AppColors.primary50,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
