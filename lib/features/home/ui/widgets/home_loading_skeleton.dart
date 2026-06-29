import 'package:flutter/material.dart';
import 'package:gate_buddy/core/themes/app_colors.dart';

class HomeLoadingSkeleton extends StatelessWidget {
  const HomeLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.primary200),
    );
  }
}
