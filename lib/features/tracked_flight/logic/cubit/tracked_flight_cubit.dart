import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/failure.dart';
import '../../../flights/data/models/flight_model.dart';
import '../../data/repo/tracked_flight_repo.dart';
import 'tracked_flight_state.dart';

class TrackedFlightCubit extends Cubit<TrackedFlightState> {
  final TrackedFlightRepo repo;

  TrackedFlightCubit({required this.repo}) : super(const TrackedFlightState());

  /// Loads ALL tracked flights from API.
  /// Used by home section and TrackedFlightsListScreen.
  Future<void> loadAll() async {
    emit(state.copyWith(status: TrackedFlightStatus.loading, clearError: true));
    try {
      final list = await repo.getTrackedFlights();
      emit(
        state.copyWith(
          status: TrackedFlightStatus.success,
          trackedFlights: list,
          flight: list.isNotEmpty ? list.first : null,
          clearFlight: list.isEmpty,
        ),
      );
      // Also load updates for the first flight if available
      if (list.isNotEmpty && list.first.id.isNotEmpty) {
        _loadUpdatesQuietly(list.first.id);
      }
    } catch (e) {
      emit(state.copyWith(status: TrackedFlightStatus.failure, error: _msg(e)));
    }
  }

  /// Use a pre-loaded FlightModel (from FlightDetailsScreen after tracking).
  void setFlight(FlightModel flight) {
    emit(
      state.copyWith(
        status: TrackedFlightStatus.success,
        flight: flight,
        updates: flight.updates,
      ),
    );
    if (flight.id.isNotEmpty && flight.updates.isEmpty) {
      _loadUpdatesQuietly(flight.id);
    }
  }

  Future<void> _loadUpdatesQuietly(String flightId) async {
    try {
      final updates = await repo.getFlightUpdates(flightId);
      if (!isClosed) emit(state.copyWith(updates: updates));
    } catch (_) {
      // non-fatal — updates are supplemental
    }
  }

  Future<void> cancelTracking(String flightId) async {
    emit(state.copyWith(status: TrackedFlightStatus.cancelling));
    try {
      await repo.untrackFlight(flightId);
      emit(state.copyWith(status: TrackedFlightStatus.cancelled));
    } catch (e) {
      emit(state.copyWith(status: TrackedFlightStatus.failure, error: _msg(e)));
    }
  }

  String _msg(Object e) => e is Failure ? e.message : e.toString();
}
