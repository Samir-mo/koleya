import 'package:equatable/equatable.dart';
import '../../../flights/data/models/flight_model.dart';

enum TrackedFlightStatus {
  initial,
  loading,
  success,
  failure,
  cancelling,
  cancelled,
}

class TrackedFlightState extends Equatable {
  final TrackedFlightStatus status;
  // The single flight being viewed in TrackedFlightScreen
  final FlightModel? flight;
  // Full list of tracked flights (used in home section + list screen)
  final List<FlightModel> trackedFlights;
  final List<FlightUpdateModel> updates;
  final String? error;

  const TrackedFlightState({
    this.status = TrackedFlightStatus.initial,
    this.flight,
    this.trackedFlights = const [],
    this.updates = const [],
    this.error,
  });

  bool get isLoading => status == TrackedFlightStatus.loading;
  bool get isSuccess => status == TrackedFlightStatus.success;
  bool get isFailure => status == TrackedFlightStatus.failure;
  bool get isCancelling => status == TrackedFlightStatus.cancelling;
  bool get isCancelled => status == TrackedFlightStatus.cancelled;

  TrackedFlightState copyWith({
    TrackedFlightStatus? status,
    FlightModel? flight,
    List<FlightModel>? trackedFlights,
    List<FlightUpdateModel>? updates,
    String? error,
    bool clearError = false,
    bool clearFlight = false,
  }) => TrackedFlightState(
    status: status ?? this.status,
    flight: clearFlight ? null : (flight ?? this.flight),
    trackedFlights: trackedFlights ?? this.trackedFlights,
    updates: updates ?? this.updates,
    error: clearError ? null : (error ?? this.error),
  );

  @override
  List<Object?> get props => [status, flight, trackedFlights, updates, error];
}
