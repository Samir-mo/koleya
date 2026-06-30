import 'package:flutter/material.dart';
import '../../../../core/shared/models/assistant_message.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../../../core/utils/spacing.dart';

class MessageBubble extends StatelessWidget {
  final AssistantMessage message;
  final dynamic colors;

  const MessageBubble({super.key, required this.message, required this.colors});

  @override
  Widget build(BuildContext context) {
    final isUser = message.sender == 'user';

    return Padding(
      padding: EdgeInsets.only(bottom: rh(12)),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            Container(
              width: rw(32),
              height: rh(32),
              decoration: const BoxDecoration(
                color: AppColors.primary200,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.smart_toy_rounded,
                color: AppColors.secondary200,
                size: rr(16),
              ),
            ),
            horizontalSpacing(8),
          ],
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: rw(14),
                vertical: rh(10),
              ),
              decoration: BoxDecoration(
                color: isUser ? AppColors.primary200 : AppColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(rr(16)),
                  topRight: Radius.circular(rr(16)),
                  bottomLeft: Radius.circular(isUser ? rr(16) : rr(4)),
                  bottomRight: Radius.circular(isUser ? rr(4) : rr(16)),
                ),
                border: isUser ? null : Border.all(color: AppColors.grey100),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withValues(alpha: 0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                message.text,
                style: AppTextStyles.font14Regular.copyWith(
                  color: isUser ? AppColors.white : colors.textPrimary,
                  height: 1.5,
                ),
              ),
            ),
          ),
          if (isUser) const SizedBox(width: 8),
        ],
      ),
    );
  }
}
