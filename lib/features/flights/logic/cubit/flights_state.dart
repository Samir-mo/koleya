import 'package:equatable/equatable.dart';

abstract class FlightsState extends Equatable {
  const FlightsState();
  @override
  List<Object?> get props => [];
}

class FlightsInitial extends FlightsState {
  const FlightsInitial();
}

class FlightsLoading extends FlightsState {}

class FlightsLoaded extends FlightsState {
  final List<dynamic> flights;
  const FlightsLoaded(this.flights);
  @override
  List<Object?> get props => [flights];
}

class FlightsError extends FlightsState {
  final String message;
  const FlightsError(this.message);
  @override
  List<Object?> get props => [message];
}
