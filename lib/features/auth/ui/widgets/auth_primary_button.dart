import 'package:flutter/material.dart';
import 'package:gate_buddy/core/themes/app_colors.dart';
import 'package:gate_buddy/core/themes/app_text_styles.dart';
import 'package:gate_buddy/core/utils/spacing.dart';

class AuthPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  const AuthPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: rh(54),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary200,
          disabledBackgroundColor: AppColors.primary100,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(rr(14))),
          elevation: 0,
        ),
        child: isLoading
            ? SizedBox(
                width: rw(22),
                height: rh(22),
                child: const CircularProgressIndicator(
                    strokeWidth: 2.5, color: AppColors.white),
              )
            : Text(
                label,
                style: AppTextStyles.font16SemiBold.copyWith(
                    color: AppColors.white),
              ),
      ),
    );
  }
}
