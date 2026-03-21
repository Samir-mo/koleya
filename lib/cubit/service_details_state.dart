import 'package:equatable/equatable.dart';

/// حالات شاشة تفاصيل الفئة / الخدمة
abstract class ServiceDetailsState extends Equatable {
  const ServiceDetailsState();

  @override
  List<Object?> get props => [];
}

class ServiceDetailsInitial extends ServiceDetailsState {}

class ServiceDetailsLoading extends ServiceDetailsState {}

class ServiceDetailsLoaded extends ServiceDetailsState {
  final List<dynamic> services;
  const ServiceDetailsLoaded(this.services);

  @override
  List<Object?> get props => [services];
}

class ServiceDetailsError extends ServiceDetailsState {
  final String message;
  const ServiceDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}