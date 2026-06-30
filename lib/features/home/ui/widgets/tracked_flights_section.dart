import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'tracked_flights_content.dart';
import '../../../tracked_flight/logic/cubit/tracked_flight_cubit.dart';
import 'package:get_it/get_it.dart';

/// Self-contained section that loads tracked flights and shows them.
/// Provides its own cubit so home doesn't need to know about it.
class TrackedFlightsSection extends StatelessWidget {
  const TrackedFlightsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<TrackedFlightCubit>()..loadAll(),
      child: const TrackedFlightsContent(),
    );
  }
}
