import 'package:flutter/material.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../../../core/utils/extensions/context_ext.dart';
import '../../../../core/utils/spacing.dart';

class ProfileSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const ProfileSection({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(rw(4), 0, 0, rh(10)),
          child: Text(
            title.toUpperCase(),
            style: AppTextStyles.font12Medium.copyWith(
              color: colors.textHint,
              letterSpacing: 0.8,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(rr(14)),
            border: Border.all(color: colors.border),
          ),
          child: Column(
            children: [
              for (int i = 0; i < children.length; i++) ...[
                children[i],
                if (i < children.length - 1)
                  Divider(height: 1, indent: rw(52), color: colors.divider),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class ProfileTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String? value;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool isDestructive;

  const ProfileTile({
    super.key,
    required this.icon,
    required this.label,
    this.iconColor = AppColors.primary200,
    this.value,
    this.trailing,
    this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    final labelColor = isDestructive ? AppColors.red200 : colors.textPrimary;
    final bgColor = isDestructive
        ? AppColors.red200.withValues(alpha: 0.08)
        : iconColor.withValues(alpha: 0.1);

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(rr(14)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(rr(14)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: rw(16), vertical: rh(14)),
          child: Row(
            children: [
              Container(
                width: rw(36),
                height: rh(36),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(rr(10)),
                ),
                child: Icon(
                  icon,
                  size: rr(18),
                  color: isDestructive ? AppColors.red200 : iconColor,
                ),
              ),
              horizontalSpacing(14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: AppTextStyles.font14Regular.copyWith(
                        color: labelColor,
                      ),
                    ),
                    if (value != null) ...[
                      verticalSpacing(2),
                      Text(
                        value!,
                        style: AppTextStyles.font12Regular.copyWith(
                          color: colors.textHint,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              trailing ??
                  (onTap != null
                      ? Icon(
                          Icons.chevron_right_rounded,
                          size: rr(20),
                          color: colors.textHint,
                        )
                      : const SizedBox.shrink()),
            ],
          ),
        ),
      ),
    );
  }
}
