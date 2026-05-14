import 'package:equatable/equatable.dart';
import '../core/shared/models/flight_model.dart';

abstract class FlightsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FlightsInitial extends FlightsState {}

class FlightsLoading extends FlightsState {}

class FlightsLoaded extends FlightsState {
  final List<FlightModel> flights;
  FlightsLoaded(this.flights);
  @override
  List<Object?> get props => [flights];
}

class FlightsError extends FlightsState {
  final String message;
  FlightsError(this.message);
  @override
  List<Object?> get props => [message];
}