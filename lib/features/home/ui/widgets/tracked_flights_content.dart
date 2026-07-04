import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/utils/spacing.dart';
import 'compact_tracked_card.dart';
import 'featured_services_section.dart';
import 'tracked_flights_empty_card.dart';
import 'tracked_flights_loading_card.dart';
import '../../../tracked_flight/logic/cubit/tracked_flight_cubit.dart';
import '../../../tracked_flight/logic/cubit/tracked_flight_state.dart';

class TrackedFlightsContent extends StatelessWidget {
  const TrackedFlightsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrackedFlightCubit, TrackedFlightState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: rw(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeSectionHeader(
                title: 'tracked_flight.section_title'.tr(),
                actionLabel: state.isSuccess && state.trackedFlights.length > 1
                    ? 'home.view_all'.tr()
                    : null,
                onAction: state.isSuccess && state.trackedFlights.length > 1
                    ? () => Navigator.of(
                        context,
                        rootNavigator: true,
                      ).pushNamed(Routes.trackedFlightsList)
                    : null,
              ),
              verticalSpacing(12),
              if (state.isLoading)
                const TrackedFlightsLoadingCard()
              else if (state.isSuccess && state.trackedFlights.isNotEmpty)
                ...state.trackedFlights
                    .take(2)
                    .map(
                      (f) => Padding(
                        padding: EdgeInsets.only(bottom: rh(10)),
                        child: CompactTrackedCard(flight: f),
                      ),
                    )
              else
                const TrackedFlightsEmptyCard(),
            ],
          ),
        );
      },
    );
  }
}
