import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../../../core/utils/extensions/context_ext.dart';
import '../../../../core/utils/spacing.dart';
import '../../../../core/widgets/flight_status_badge.dart';
import '../../../flights/data/models/flight_model.dart';
import '../../data/models/home_model.dart';
import '../../logic/cubit/home_cubit.dart';
import '../../logic/cubit/home_state.dart';
import 'airport_services_grid.dart';
import 'featured_services_section.dart';
import 'flight_update_entry_card.dart';
import 'home_section.dart';
import 'scan_boarding_pass_card.dart';
import 'tracked_flight_card.dart';

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
            // ── Flight updates (always shown, first section) ────────────────
            verticalSpacing(16),
            BlocBuilder<HomeCubit, HomeState>(
              buildWhen: (prev, curr) =>
                  prev.updatedFlights != curr.updatedFlights,
              builder: (context, state) {
                final flights = state.updatedFlights;
                return HomeSection(
                  header: HomeSectionHeader(
                    title: 'home.flight_updates'.tr(),
                    actionLabel: flights.isNotEmpty
                        ? 'home.view_all'.tr()
                        : null,
                    onAction: flights.isNotEmpty
                        ? () => Navigator.of(
                            context,
                            rootNavigator: true,
                          ).pushNamed(Routes.flightUpdates)
                        : null,
                  ),
                  child: flights.isEmpty
                      ? const _EmptyFlightUpdates()
                      : Column(
                          children: flights
                              .take(3)
                              .map(
                                (f) => Padding(
                                  padding: EdgeInsets.only(bottom: rh(10)),
                                  child: _UpdatedFlightCard(flight: f),
                                ),
                              )
                              .toList(),
                        ),
                );
              },
            ),

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

class _UpdatedFlightCard extends StatelessWidget {
  final FlightModel flight;
  const _UpdatedFlightCard({required this.flight});

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(rr(14)),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: rw(4),
              decoration: BoxDecoration(
                color: colors.warning,
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(14),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: rw(14),
                  vertical: rh(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Flight header: number + route + status
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${flight.airline.name} ${flight.flightNumber}',
                                style: AppTextStyles.font12Medium.copyWith(
                                  color: colors.textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              verticalSpacing(2),
                              Row(
                                children: [
                                  Text(
                                    flight.route.fromCode,
                                    style: AppTextStyles.font12Regular.copyWith(
                                      color: colors.textSecondary,
                                    ),
                                  ),
                                  horizontalSpacing(4),
                                  Icon(
                                    Icons.arrow_forward_rounded,
                                    size: rw(10),
                                    color: colors.textHint,
                                  ),
                                  horizontalSpacing(4),
                                  Text(
                                    flight.route.toCode,
                                    style: AppTextStyles.font12Regular.copyWith(
                                      color: colors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        horizontalSpacing(8),
                        FlightStatusBadge(
                          status: flight.status,
                          showBorder: false,
                        ),
                      ],
                    ),
                    // Top updates (max 2)
                    if (flight.updates.isNotEmpty) ...[
                      verticalSpacing(10),
                      ...flight.updates
                          .take(2)
                          .map(
                            (u) => Padding(
                              padding: EdgeInsets.only(bottom: rh(6)),
                              child: FlightUpdateEntryCard(update: u),
                            ),
                          ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyFlightUpdates extends StatelessWidget {
  const _EmptyFlightUpdates();

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: rw(20), vertical: rh(20)),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(rr(14)),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        children: [
          Container(
            width: rw(44),
            height: rw(44),
            decoration: BoxDecoration(
              color: AppColors.primary200.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_none_rounded,
              size: rw(22),
              color: AppColors.primary200,
            ),
          ),
          verticalSpacing(10),
          Text(
            'home.no_updates'.tr(),
            style: AppTextStyles.font14SemiBold.copyWith(
              color: colors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          verticalSpacing(4),
          Text(
            'home.no_updates_hint'.tr(),
            style: AppTextStyles.font12Regular.copyWith(
              color: colors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
