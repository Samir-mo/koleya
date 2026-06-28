import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gate_buddy/core/themes/app_colors.dart';
import 'package:gate_buddy/core/themes/app_text_styles.dart';
import 'package:gate_buddy/core/utils/spacing.dart';
import 'package:gate_buddy/features/auth/logic/cubit/auth_cubit.dart';
import 'package:gate_buddy/features/auth/logic/cubit/auth_state.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'home.greeting_morning'.tr();
    if (hour < 17) return 'home.greeting_afternoon'.tr();
    return 'home.greeting_evening'.tr();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final name = state.user?.name;
        final greeting = name != null && name.isNotEmpty
            ? '${_greeting()}, ${name.split(' ').first}! ✈️'
            : 'home.greeting_guest'.tr();

        return Padding(
          padding: EdgeInsets.fromLTRB(rw(20), 0, rw(20), rh(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting,
                style: AppTextStyles.font20Bold.copyWith(color: AppColors.white),
              ),
              verticalSpacing(4),
              Text(
                'home.tagline'.tr(),
                style: AppTextStyles.font14Regular
                    .copyWith(color: AppColors.primary50),
              ),
            ],
          ),
        );
      },
    );
  }
}
