import 'package:equatable/equatable.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {
  final int index;
  const HomeInitial(this.index);

  @override
  List<Object?> get props => [index];
}

class HomeTabChanged extends HomeState {
  final int index;
  const HomeTabChanged(this.index);

  @override
  List<Object?> get props => [index];
}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final Map<String, dynamic> data;
  const HomeLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class HomeError extends HomeState {
  final String error;
  const HomeError(this.error);

  @override
  List<Object?> get props => [error];
}
