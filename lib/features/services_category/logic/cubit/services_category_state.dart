import 'package:equatable/equatable.dart';
import '../../../../core/shared/models/service_model.dart';

enum ServicesCategoryStatus { initial, loading, success, failure }

class ServicesCategoryState extends Equatable {
  final ServicesCategoryStatus status;
  final List<ServiceModel> services;
  final String category;
  final String? error;

  const ServicesCategoryState({
    this.status = ServicesCategoryStatus.initial,
    this.services = const [],
    this.category = '',
    this.error,
  });

  bool get isLoading => status == ServicesCategoryStatus.loading;
  bool get isSuccess => status == ServicesCategoryStatus.success;
  bool get isFailure => status == ServicesCategoryStatus.failure;

  ServicesCategoryState copyWith({
    ServicesCategoryStatus? status,
    List<ServiceModel>? services,
    String? category,
    String? error,
  }) {
    return ServicesCategoryState(
      status: status ?? this.status,
      services: services ?? this.services,
      category: category ?? this.category,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, services, category, error];
}
