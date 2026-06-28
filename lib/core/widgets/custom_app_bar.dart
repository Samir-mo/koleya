import 'package:flutter/material.dart';
import 'package:gate_buddy/core/themes/app_colors.dart';
import 'package:gate_buddy/core/themes/app_text_styles.dart';
import 'package:gate_buddy/core/utils/spacing.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final Widget? leading;
  final VoidCallback? onLeadingPressed;

  const CustomAppBar({
    super.key,
    required this.title,
    this.leading,
    this.onLeadingPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: rh(32), left: rw(16), right: rw(16)),
      height: rh(100),
      width: double.infinity,
      color: AppColors.primary200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (leading != null)
            Positioned(
              left: 0,
              child: GestureDetector(onTap: onLeadingPressed, child: leading),
            ),
          Text(
            title,
            style: AppTextStyles.font20Bold.copyWith(color: AppColors.white),
          ),
        ],
      ),
    );
  }
}
