import 'package:equatable/equatable.dart';

abstract class AccessibilityState extends Equatable {
  const AccessibilityState();

  @override
  List<Object?> get props => [];
}

class AccessibilityInitial extends AccessibilityState {}

class AccessibilityLoading extends AccessibilityState {}

class AccessibilityLoaded extends AccessibilityState {
  final List<dynamic> services;
  const AccessibilityLoaded(this.services);

  @override
  List<Object?> get props => [services];
}

class AccessibilityError extends AccessibilityState {
  final String message;
  const AccessibilityError(this.message);

  @override
  List<Object?> get props => [message];
}