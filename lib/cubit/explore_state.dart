import 'package:equatable/equatable.dart';

abstract class ExploreState extends Equatable {
  const ExploreState();

  @override
  List<Object?> get props => [];
}

class ExploreInitial extends ExploreState {}

class ExploreLoading extends ExploreState {}

class ExploreLoaded extends ExploreState {
  final List<dynamic> places;
  const ExploreLoaded(this.places);

  @override
  List<Object?> get props => [places];
}

class ExploreError extends ExploreState {
  final String message;
  const ExploreError(this.message);

  @override
  List<Object?> get props => [message];
}