import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/flight_model.dart';
import '../../data/repo/flights_repo.dart';
import 'flights_state.dart';

class FlightsCubit extends Cubit<FlightsState> {
  final FlightsRepo repo;

  FlightsCubit({required this.repo}) : super(const FlightsState());

  Future<void> loadFlights() async {
    emit(state.copyWith(status: FlightsStatus.loading, clearError: true));
    try {
      final all = await repo.getFlights();
      emit(state.copyWith(
        status: FlightsStatus.success,
        departures: all.where((f) => f.direction == 'departure').toList(),
        arrivals: all.where((f) => f.direction == 'arrival').toList(),
      ));
    } catch (e) {
      emit(state.copyWith(
        status: FlightsStatus.failure,
        error: e.toString(),
      ));
    }
  }

  Future<void> searchFlights(String query) async {
    if (query.trim().isEmpty) {
      emit(state.copyWith(isSearching: false, query: '', searchResults: []));
      return;
    }
    emit(state.copyWith(
      isSearching: true,
      query: query,
      status: FlightsStatus.loading,
    ));
    try {
      final results = await repo.searchFlights(query.trim());
      emit(state.copyWith(
        status: FlightsStatus.success,
        searchResults: results,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: FlightsStatus.failure,
        error: e.toString(),
      ));
    }
  }

  void clearSearch() {
    emit(state.copyWith(isSearching: false, query: '', searchResults: []));
  }

  Future<void> toggleTrack(FlightModel flight) async {
    emit(state.copyWith(trackingFlightId: flight.id));
    try {
      if (flight.isTracked) {
        await repo.untrackFlight(flight.id);
      } else {
        await repo.trackFlight(flight.id);
      }
      _updateTrackedState(flight.id, !flight.isTracked);
    } catch (e) {
      emit(state.copyWith(clearTracking: true, error: e.toString()));
    }
  }

  void _updateTrackedState(String id, bool isTracked) {
    FlightModel update(FlightModel f) =>
        f.id == id ? f.copyWith(isTracked: isTracked) : f;

    emit(state.copyWith(
      clearTracking: true,
      departures: state.departures.map(update).toList(),
      arrivals: state.arrivals.map(update).toList(),
      searchResults: state.searchResults.map(update).toList(),
    ));
  }
}
