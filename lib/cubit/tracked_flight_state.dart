import 'package:equatable/equatable.dart';
import '../core/shared/models/tracked_flight_model.dart';

abstract class TrackedFlightState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TrackedFlightInitial extends TrackedFlightState {}

class TrackedFlightLoading extends TrackedFlightState {}

class TrackedFlightLoaded extends TrackedFlightState {
  final TrackedFlightModel flight;
  TrackedFlightLoaded(this.flight); // ← بدون const

  @override
  List<Object?> get props => [flight];
}

class TrackedFlightError extends TrackedFlightState {
  final String message;
  TrackedFlightError(this.message); // ← بدون const

  @override
  List<Object?> get props => [message];
}