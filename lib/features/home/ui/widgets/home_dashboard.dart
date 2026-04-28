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

class HomeDashboard extends StatelessWidget {
  final ScrollController? scrollController;
  const HomeDashboard({super.key, this.scrollController});

  Color get _primaryBlue => const Color(0xFF013F82);
  Color get _accentOrange => const Color(0xFFF3A623);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          return Scaffold(
            backgroundColor: _primaryBlue,
            body: const Center(child: CircularProgressIndicator(color: Colors.white)),
          );
        }

        if (state is HomeError) {
          return Scaffold(
            backgroundColor: _primaryBlue,
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  '❌ خطأ أثناء تحميل البيانات:\n${state.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          );
        }

        if (state is HomeLoaded) {
          final data = state.data;
          final List flights = data["updatedFlights"] ?? [];
          final Map? trackedFlight = data["trackedFlight"];

          return Scaffold(
            backgroundColor: _primaryBlue,
            body: SafeArea(
              child: Column(
                children: [
                  HomeAppBar(primaryBlue: _primaryBlue),

                  // الجزء الأبيض اللي تحت
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
                            // ===== Updated Flights =====
                            UpdatedFlightsSection(
                              flights: flights,
                              primaryBlue: _primaryBlue,
                              accentOrange: _accentOrange,
                            ),
                            const SizedBox(height: 24),

                            // ===== Your Tracked Flight =====
                            if (trackedFlight != null) ...[
                              SectionTitle(
                                title: 'Your Tracked Flight',
                                color: _primaryBlue,
                                leading: const TrackedFlightIcon(),
                              ),
                              const SizedBox(height: 10),
                              TrackedFlightBigCard(
                                trackedFlight: trackedFlight,
                                primaryBlue: _primaryBlue,
                                accentOrange: _accentOrange,
                              ),
                              const SizedBox(height: 24),
                            ],

                            // ===== Airport Services =====
                            SectionTitle(
                              title: 'Airport Services',
                              color: _primaryBlue,
                              leading: const AirportServicesIcon(),
                            ),
                            const SizedBox(height: 10),
                            AirportServicesGrid(
                              primaryBlue: _primaryBlue,
                              accentOrange: _accentOrange,
                            ),
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

        return Scaffold(
          backgroundColor: _primaryBlue,
          body: const Center(child: CircularProgressIndicator(color: Colors.white)),
        );
      },
    );
  }
}
