import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gate_buddy/core/themes/app_colors.dart';
import 'package:gate_buddy/core/themes/app_text_styles.dart';
import 'package:gate_buddy/core/utils/spacing.dart';

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
        left: 16,
        right: 16,
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
              size: 22,
            ),
          ),
          SizedBox(width: rw(12)),
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
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'AI Assistant · Online',
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
