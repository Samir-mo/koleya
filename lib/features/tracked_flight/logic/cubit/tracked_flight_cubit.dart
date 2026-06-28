import 'package:flutter_bloc/flutter_bloc.dart';
import 'tracked_flight_state.dart';

class TrackedFlightCubit extends Cubit<TrackedFlightState> {
  TrackedFlightCubit() : super(const TrackedFlightInitial());

  Future<void> loadTrackedFlight() async {}
  Future<void> trackFlight(String id) async {}
  Future<void> cancelTracking(String id) async {}
}
