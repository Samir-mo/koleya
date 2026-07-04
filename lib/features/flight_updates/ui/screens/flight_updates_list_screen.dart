import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../../../core/utils/extensions/context_ext.dart';
import '../../../../core/utils/spacing.dart';
import '../../logic/cubit/flight_updates_list_cubit.dart';
import '../../logic/cubit/flight_updates_list_state.dart';
import '../widgets/flight_update_list_item.dart';

class FlightUpdatesListScreen extends StatelessWidget {
  const FlightUpdatesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<FlightUpdatesListCubit>()..loadFlights(),
      child: const _View(),
    );
  }
}

class _View extends StatefulWidget {
  const _View();

  @override
  State<_View> createState() => _ViewState();
}

class _ViewState extends State<_View> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 500) {
      context.read<FlightUpdatesListCubit>().loadMoreFlights();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary200,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: EdgeInsets.all(rw(8)),
            child: CircleAvatar(
              backgroundColor: AppColors.white.withValues(alpha: 0.12),
              radius: rw(16),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.white,
                size: rw(14),
              ),
            ),
          ),
        ),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'flight_updates.list_title'.tr(),
              style: AppTextStyles.font16Bold.copyWith(
                color: AppColors.white,
              ),
            ),
            Text(
              'flight_updates.list_subtitle'.tr(),
              style: AppTextStyles.font12Regular.copyWith(
                color: AppColors.primary50,
              ),
            ),
          ],
        ),
      ),
      body: BlocBuilder<FlightUpdatesListCubit, FlightUpdatesListState>(
        builder: (context, state) {
          if (state.isLoading && state.flights.isEmpty) {
            return _LoadingView();
          }

          if (state.isFailure && state.flights.isEmpty) {
            return _ErrorView(
              error: state.error ?? 'errors.unknown'.tr(),
              onRetry: () =>
                  context.read<FlightUpdatesListCubit>().loadFlights(),
            );
          }

          if (state.flights.isEmpty) {
            return _EmptyView();
          }

          return RefreshIndicator(
            color: AppColors.primary200,
            onRefresh: () =>
                context.read<FlightUpdatesListCubit>().loadFlights(),
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(vertical: rh(12)),
              itemCount: state.flights.length +
                  (state.hasMore && state.isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= state.flights.length) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: rh(20)),
                    child: const Center(
                      child: SizedBox(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator(
                          color: AppColors.primary200,
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  );
                }

                final flight = state.flights[index];
                return FlightUpdateListItem(
                  flight: flight,
                  onTap: () => Navigator.of(context, rootNavigator: true)
                      .pushNamed(
                    Routes.flightDetail,
                    arguments: {'id': flight.id},
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: rh(12)),
      itemCount: 5,
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.symmetric(horizontal: rw(20), vertical: rh(8)),
        child: _LoadingSkeletonCard(),
      ),
    );
  }
}

class _LoadingSkeletonCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(rr(16)),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: rw(14),
              vertical: rh(10),
            ),
            decoration: const BoxDecoration(
              color: AppColors.primary200,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ShimmerBox(width: rw(150), height: rh(14)),
                      verticalSpacing(6),
                      _ShimmerBox(width: rw(100), height: rh(12)),
                    ],
                  ),
                ),
                horizontalSpacing(10),
                _ShimmerBox(width: rw(50), height: rh(14)),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(rw(14)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ShimmerBox(width: rw(100), height: rh(12)),
                verticalSpacing(8),
                _ShimmerBox(width: double.infinity, height: rh(40)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  final double width;
  final double height;

  const _ShimmerBox({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: colors.border,
        borderRadius: BorderRadius.circular(rr(4)),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(rw(32)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: rw(80),
              height: rw(80),
              decoration: BoxDecoration(
                color: AppColors.primary200.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_none_rounded,
                size: rw(40),
                color: AppColors.primary200,
              ),
            ),
            verticalSpacing(20),
            Text(
              'flight_updates.empty_title'.tr(),
              style: AppTextStyles.font16Bold.copyWith(
                color: colors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            verticalSpacing(8),
            Text(
              'flight_updates.empty_body'.tr(),
              style: AppTextStyles.font14Regular.copyWith(
                color: colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const _ErrorView({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(rw(32)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: rw(56),
              color: AppColors.white.withValues(alpha: 0.3),
            ),
            verticalSpacing(16),
            Text(
              error,
              style: AppTextStyles.font14Regular.copyWith(
                color: colors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            verticalSpacing(24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: Text('common.retry'.tr()),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary200,
                padding: EdgeInsets.symmetric(
                  horizontal: rw(24),
                  vertical: rh(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
