import 'package:equatable/equatable.dart';

abstract class TrackedFlightState extends Equatable {
  const TrackedFlightState();
  @override
  List<Object?> get props => [];
}

class TrackedFlightInitial extends TrackedFlightState {
  const TrackedFlightInitial();
}

class TrackedFlightLoading extends TrackedFlightState {}

class TrackedFlightLoaded extends TrackedFlightState {
  final dynamic flight;
  const TrackedFlightLoaded(this.flight);
  @override
  List<Object?> get props => [flight];
}

class TrackedFlightError extends TrackedFlightState {
  final String message;
  const TrackedFlightError(this.message);
  @override
  List<Object?> get props => [message];
}
