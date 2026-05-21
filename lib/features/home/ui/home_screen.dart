import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koleya/cubit/home_cubit.dart';
import 'package:koleya/cubit/home_state.dart';
import 'package:koleya/features/home/ui/widgets/airport_services_grid.dart';
import 'package:koleya/features/home/ui/widgets/airport_services_icon.dart';
import 'package:koleya/features/home/ui/widgets/home_app_bar.dart';
import 'package:koleya/features/home/ui/widgets/section_title.dart';
import 'package:koleya/features/home/ui/widgets/tracked_flight_big_card.dart';
import 'package:koleya/features/home/ui/widgets/tracked_flight_icon.dart';
import 'package:koleya/features/home/ui/widgets/updated_flights_section.dart';

class HomeScreen extends StatelessWidget {
  final ScrollController scrollController;

  const HomeScreen({super.key, required this.scrollController});

  static const Color primaryBlue = Color(0xFF013F82);
  static const Color accentOrange = Color(0xFFF3A623);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        if (state is HomeLoading) {
          return _loadingView();
        }

        if (state is HomeError) {
          return _errorView(state.error);
        }

        if (state is HomeLoaded) {
          return _loadedView(state);
        }

        return _loadingView();
      },
    );
  }

  // ---------------- LOADING ----------------
  Widget _loadingView() {
    return Container(
      color: primaryBlue,
      child: const Center(child: CircularProgressIndicator(color: Colors.white)),
    );
  }

  // ---------------- ERROR ----------------
  Widget _errorView(String error) {
    return Container(
      color: primaryBlue,
      child: Center(
        child: Text('❌ Error: $error', style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  // ---------------- LOADED ----------------
  Widget _loadedView(HomeLoaded state) {
    final data = state.data;

    final List<Map<String, dynamic>> flights = List<Map<String, dynamic>>.from(
      data["updatedFlights"] ?? [],
    );

    final Map<String, dynamic>? trackedFlight = data["trackedFlight"] as Map<String, dynamic>?;

    return Material(
      color: primaryBlue,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            HomeAppBar(primaryBlue: primaryBlue),

            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UpdatedFlightsSection(
                        flights: flights,
                        primaryBlue: primaryBlue,
                        accentOrange: accentOrange,
                      ),

                      const SizedBox(height: 24),

                      if (trackedFlight != null && trackedFlight.isNotEmpty) ...[
                        SectionTitle(
                          title: 'Your Tracked Flight',
                          color: primaryBlue,
                          leading: const TrackedFlightIcon(),
                        ),
                        const SizedBox(height: 10),

                        TrackedFlightBigCard(
                          trackedFlight: trackedFlight,
                          primaryBlue: primaryBlue,
                          accentOrange: accentOrange,
                        ),

                        const SizedBox(height: 24),
                      ],

                      SectionTitle(
                        title: 'Airport Services',
                        color: primaryBlue,
                        leading: const AirportServicesIcon(),
                      ),

                      const SizedBox(height: 10),

                      AirportServicesGrid(primaryBlue: primaryBlue, accentOrange: accentOrange),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
