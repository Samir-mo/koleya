import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gate_buddy/core/themes/app_colors.dart';
import 'package:gate_buddy/core/utils/spacing.dart';
import 'package:gate_buddy/features/home/data/models/home_model.dart';
import 'package:gate_buddy/features/home/logic/cubit/home_cubit.dart';
import 'package:gate_buddy/features/home/ui/widgets/airport_services_grid.dart';
import 'package:gate_buddy/features/home/ui/widgets/featured_services_section.dart';
import 'package:gate_buddy/features/home/ui/widgets/flight_update_card.dart';
import 'package:gate_buddy/features/home/ui/widgets/home_section.dart';
import 'package:gate_buddy/features/home/ui/widgets/scan_boarding_pass_card.dart';
import 'package:gate_buddy/features/home/ui/widgets/tracked_flight_card.dart';
import 'package:gate_buddy/features/home/ui/widgets/tracked_flights_section.dart';
import 'package:gate_buddy/features/main_navigation/ui/main_scaffold.dart';

class HomeLoadedView extends StatelessWidget {
  final HomeModel data;
  final ScrollController scrollController;
  const HomeLoadedView({
    super.key,
    required this.data,
    required this.scrollController,
  });

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
            if (data.updatedFlights.isNotEmpty) ...[
              verticalSpacing(24),
              HomeSection(
                header: HomeSectionHeader(
                  title: 'home.flight_updates'.tr(),
                  actionLabel: 'home.view_all'.tr(),
                  onAction: () =>
                      MainScaffold.jumpToTab(MainScaffold.tabFlights),
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
              HomeSection(
                header: HomeSectionHeader(title: 'home.your_flight'.tr()),
                child: TrackedFlightCard(track: data.userTrack!),
              ),
            ],

            // ── Tracked flights list ──────────────────────────────────────
            verticalSpacing(24),
            const TrackedFlightsSection(),

            // ── Airport services grid ─────────────────────────────────────
            verticalSpacing(24),
            HomeSection(
              header: HomeSectionHeader(title: 'home.airport_services'.tr()),
              child: const AirportServicesGrid(),
            ),

            // ── Scan boarding pass card ───────────────────────────────────
            verticalSpacing(24),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: rw(20)),
              child: const ScanBoardingPassCard(),
            ),

            verticalSpacing(40),
          ],
        ),
      ),
    );
  }
}
