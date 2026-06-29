import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gate_buddy/core/router/routes.dart';
import 'package:gate_buddy/core/themes/app_colors.dart';
import 'package:gate_buddy/core/utils/extensions/context_ext.dart';
import 'package:gate_buddy/core/utils/spacing.dart';
import 'package:gate_buddy/core/widgets/empty_state.dart';
import 'package:gate_buddy/features/home/data/models/home_model.dart';
import 'package:gate_buddy/features/home/logic/cubit/home_cubit.dart';
import 'package:gate_buddy/features/home/logic/cubit/home_state.dart';
import 'package:gate_buddy/features/home/ui/widgets/airport_services_grid.dart';
import 'package:gate_buddy/features/home/ui/widgets/featured_services_section.dart';
import 'package:gate_buddy/features/home/ui/widgets/flight_update_card.dart';
import 'package:gate_buddy/features/home/ui/widgets/home_app_bar.dart';
import 'package:gate_buddy/features/home/ui/widgets/metrics_strip.dart';
import 'package:gate_buddy/features/home/ui/widgets/tracked_flight_card.dart';
import 'package:gate_buddy/features/home/ui/widgets/tracked_flights_section.dart';

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
                  child: _Body(
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

class _Body extends StatelessWidget {
  final HomeState state;
  final ScrollController scrollController;
  const _Body({required this.state, required this.scrollController});

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
    if (state.isLoading) return _LoadingSkeleton();
    if (state.isFailure) {
      return _ErrorView(error: state.error ?? 'errors.unknown'.tr());
    }
    if (state.isSuccess && state.data != null) {
      return _LoadedView(data: state.data!, scrollController: scrollController);
    }
    return _LoadingSkeleton();
  }
}

// ── Loading ───────────────────────────────────────────────────────────────────

class _LoadingSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.primary200),
    );
  }
}

// ── Error view ────────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final String error;
  const _ErrorView({required this.error});

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

// ── Loaded view ───────────────────────────────────────────────────────────────

class _LoadedView extends StatelessWidget {
  final HomeModel data;
  final ScrollController scrollController;
  const _LoadedView({required this.data, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.primary200,
      onRefresh: () => context.read<HomeCubit>().refresh(),
      child: SingleChildScrollView(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Metrics ───────────────────────────────────────────────────
            verticalSpacing(20),
            MetricsStrip(metrics: data.metrics),

            // ── Updated flights ───────────────────────────────────────────
            if (data.updatedFlights.isNotEmpty) ...[
              verticalSpacing(24),
              _Section(
                header: HomeSectionHeader(
                  title: 'home.flight_updates'.tr(),
                  actionLabel: 'home.view_all'.tr(),
                  onAction: () => Navigator.pushNamed(context, Routes.flights),
                ),
                child: Column(
                  children: data.updatedFlights
                      .take(2)
                      .map(
                        (f) => Padding(
                          padding: EdgeInsets.only(bottom: rh(10)),
                          child: FlightUpdateCard(flight: f),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],

            // ── Tracked flight ────────────────────────────────────────────
            if (data.userTrack != null &&
                data.userTrack!.isActive &&
                data.userTrack!.flight.flightNumber.isNotEmpty) ...[
              verticalSpacing(24),
              _Section(
                header: HomeSectionHeader(title: 'home.your_flight'.tr()),
                child: TrackedFlightCard(track: data.userTrack!),
              ),
            ],

            // ── Tracked flights ────────────────────────────────────────────
            verticalSpacing(24),
            const TrackedFlightsSection(),

            // ── Airport services grid ─────────────────────────────────────
            verticalSpacing(24),
            _Section(
              header: HomeSectionHeader(title: 'home.airport_services'.tr()),
              child: const AirportServicesGrid(),
            ),

            // ── Featured services ─────────────────────────────────────────
            if (data.featuredServices.isNotEmpty) ...[
              verticalSpacing(24),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: rw(20)),
                child: HomeSectionHeader(
                  title: 'home.popular_services'.tr(),
                  actionLabel: 'home.view_all'.tr(),
                  onAction: () => Navigator.pushNamed(context, Routes.services),
                ),
              ),
              verticalSpacing(12),
              Padding(
                padding: EdgeInsets.only(left: rw(20)),
                child: FeaturedServicesSection(services: data.featuredServices),
              ),
            ],

            verticalSpacing(40),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final Widget header;
  final Widget child;
  const _Section({required this.header, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: rw(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [header, verticalSpacing(12), child],
      ),
    );
  }
}
