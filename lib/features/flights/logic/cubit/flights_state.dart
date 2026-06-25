import 'package:equatable/equatable.dart';

import '../../data/models/flight_model.dart';

enum FlightsStatus { initial, loading, success, failure }

class FlightsState extends Equatable {
  final FlightsStatus status;
  final List<FlightModel> departures;
  final List<FlightModel> arrivals;
  final List<FlightModel> searchResults;
  final String query;
  final bool isSearching;
  final String? trackingFlightId;
  final String? error;

  const FlightsState({
    this.status = FlightsStatus.initial,
    this.departures = const [],
    this.arrivals = const [],
    this.searchResults = const [],
    this.query = '',
    this.isSearching = false,
    this.trackingFlightId,
    this.error,
  });

  FlightsState copyWith({
    FlightsStatus? status,
    List<FlightModel>? departures,
    List<FlightModel>? arrivals,
    List<FlightModel>? searchResults,
    String? query,
    bool? isSearching,
    String? trackingFlightId,
    bool clearTracking = false,
    String? error,
    bool clearError = false,
  }) {
    return FlightsState(
      status: status ?? this.status,
      departures: departures ?? this.departures,
      arrivals: arrivals ?? this.arrivals,
      searchResults: searchResults ?? this.searchResults,
      query: query ?? this.query,
      isSearching: isSearching ?? this.isSearching,
      trackingFlightId: clearTracking ? null : (trackingFlightId ?? this.trackingFlightId),
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [
        status,
        departures,
        arrivals,
        searchResults,
        query,
        isSearching,
        trackingFlightId,
        error,
      ];
}
