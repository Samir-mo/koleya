import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gate_buddy/core/widgets/empty_state.dart';
import 'package:gate_buddy/features/home/logic/cubit/home_cubit.dart';

class HomeErrorView extends StatelessWidget {
  final String error;
  const HomeErrorView({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.cloud_off_rounded,
      title: 'errors.error_screen_title'.tr(),
      description: error,
      actionLabel: 'errors.error_screen_button'.tr(),
      onAction: () => context.read<HomeCubit>().refresh(),
    );
  }
}
