import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gate_buddy/core/themes/app_colors.dart';
import 'package:gate_buddy/features/home/logic/cubit/home_cubit.dart';
import 'package:gate_buddy/features/home/logic/cubit/home_state.dart';
import 'package:gate_buddy/features/home/ui/widgets/home_app_bar.dart';
import 'package:gate_buddy/features/home/ui/widgets/home_body.dart';

class HomeScreen extends StatelessWidget {
  final ScrollController scrollController;
  const HomeScreen({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Material(
          color: AppColors.primary200,
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                const HomeAppBar(),
                Expanded(
                  child: HomeBody(
                    state: state,
                    scrollController: scrollController,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
