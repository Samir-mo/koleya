import 'package:equatable/equatable.dart';
import 'package:gate_buddy/features/flights/data/models/flight_model.dart';
import '../../data/models/home_model.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  final HomeStatus status;
  final HomeModel? data;
  final String? error;

  // Recently updated flights; fetched separately from the main dashboard.
  final List<FlightModel> updatedFlights;

  const HomeState({
    this.status = HomeStatus.initial,
    this.data,
    this.error,
    this.updatedFlights = const [],
  });

  bool get isLoading => status == HomeStatus.loading;
  bool get isSuccess => status == HomeStatus.success;
  bool get isFailure => status == HomeStatus.failure;

  HomeState copyWith({
    HomeStatus? status,
    HomeModel? data,
    String? error,
    bool clearError = false,
    List<FlightModel>? updatedFlights,
  }) => HomeState(
    status: status ?? this.status,
    data: data ?? this.data,
    error: clearError ? null : error ?? this.error,
    updatedFlights: updatedFlights ?? this.updatedFlights,
  );

  @override
  List<Object?> get props => [status, data, error, updatedFlights];
}
