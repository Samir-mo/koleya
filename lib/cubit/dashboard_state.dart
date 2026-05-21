import 'package:equatable/equatable.dart';
import '../core/shared/models/dashboard_model.dart';

abstract class DashboardState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final DashboardModel dashboard;
  DashboardLoaded(this.dashboard); // ← بدون const

  @override
  List<Object?> get props => [dashboard];
}

class DashboardError extends DashboardState {
  final String message;
  DashboardError(this.message); // ← بدون const

  @override
  List<Object?> get props => [message];
}