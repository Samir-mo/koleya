import 'package:equatable/equatable.dart';
import '../../../flights/data/models/flight_model.dart';

enum FlightUpdatesStatus { initial, loading, success, failure }

class FlightUpdatesListState extends Equatable {
  final FlightUpdatesStatus status;
  final List<FlightModel> flights;
  final String? error;
  final int currentPage;
  final bool hasMore;

  const FlightUpdatesListState({
    this.status = FlightUpdatesStatus.initial,
    this.flights = const [],
    this.error,
    this.currentPage = 0,
    this.hasMore = true,
  });

  bool get isLoading => status == FlightUpdatesStatus.loading;
  bool get isSuccess => status == FlightUpdatesStatus.success;
  bool get isFailure => status == FlightUpdatesStatus.failure;

  FlightUpdatesListState copyWith({
    FlightUpdatesStatus? status,
    List<FlightModel>? flights,
    String? error,
    int? currentPage,
    bool? hasMore,
    bool clearError = false,
  }) => FlightUpdatesListState(
    status: status ?? this.status,
    flights: flights ?? this.flights,
    error: clearError ? null : error ?? this.error,
    currentPage: currentPage ?? this.currentPage,
    hasMore: hasMore ?? this.hasMore,
  );

  @override
  List<Object?> get props => [status, flights, error, currentPage, hasMore];
}
