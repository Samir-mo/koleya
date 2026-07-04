import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/extensions/context_ext.dart';
import '../../logic/cubit/home_state.dart';
import 'home_error_view.dart';
import 'home_loaded_view.dart';
import 'home_loading_skeleton.dart';

class HomeBody extends StatelessWidget {
  final HomeState state;
  final ScrollController scrollController;
  const HomeBody({
    super.key,
    required this.state,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    return Container(
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        child: _content(context),
      ),
    );
  }

  Widget _content(BuildContext context) {
    if (state.isLoading) return const HomeLoadingSkeleton();
    if (state.isFailure) {
      return HomeErrorView(error: state.error ?? 'errors.unknown'.tr());
    }
    if (state.isSuccess && state.data != null) {
      return HomeLoadedView(
        data: state.data!,
        scrollController: scrollController,
      );
    }
    return const HomeLoadingSkeleton();
  }
}
