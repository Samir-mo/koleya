import 'package:equatable/equatable.dart';
import '../core/shared/models/service_model.dart';

abstract class AppState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AppInitial extends AppState {}

class AppLoading extends AppState {}

class AppLoaded extends AppState {
  final List<ServiceModel> services;
  AppLoaded(this.services);

  @override
  List<Object?> get props => [services];
}

class AppError extends AppState {
  final String message;
  AppError(this.message);

  @override
  List<Object?> get props => [message];
}