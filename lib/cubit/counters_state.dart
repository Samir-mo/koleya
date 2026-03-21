import 'package:equatable/equatable.dart';

abstract class CountersState extends Equatable {
  const CountersState();

  @override
  List<Object?> get props => [];
}

class CountersInitial extends CountersState {}

class CountersLoading extends CountersState {}

class CountersLoaded extends CountersState {
  final List<dynamic> counters;
  const CountersLoaded(this.counters);

  @override
  List<Object?> get props => [counters];
}

class CountersError extends CountersState {
  final String message;
  const CountersError(this.message);

  @override
  List<Object?> get props => [message];
}
