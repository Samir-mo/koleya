import 'package:equatable/equatable.dart';
import 'package:gate_buddy/features/flights/data/models/flight_model.dart';
import '../../data/models/home_model.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  final HomeStatus status;
  final HomeModel? data;
  final String? error;

  // Flight-updates load has its own status/error so it can't clobber the
  // main dashboard status when the two loads race (see HomeCubit.refresh).
  final HomeStatus flightUpdatesStatus;
  final List<FlightUpdateModel> flightUpdates;
  final String? flightUpdatesError;

  const HomeState({
    this.status = HomeStatus.initial,
    this.data,
    this.error,
    this.flightUpdatesStatus = HomeStatus.initial,
    this.flightUpdates = const [],
    this.flightUpdatesError,
  });

  bool get isLoading => status == HomeStatus.loading;
  bool get isSuccess => status == HomeStatus.success;
  bool get isFailure => status == HomeStatus.failure;

  HomeState copyWith({
    HomeStatus? status,
    HomeModel? data,
    String? error,
    bool clearError = false,
    HomeStatus? flightUpdatesStatus,
    List<FlightUpdateModel>? flightUpdates,
    String? flightUpdatesError,
    bool clearFlightUpdatesError = false,
  }) => HomeState(
    status: status ?? this.status,
    data: data ?? this.data,
    error: clearError ? null : error ?? this.error,
    flightUpdatesStatus: flightUpdatesStatus ?? this.flightUpdatesStatus,
    flightUpdates: flightUpdates ?? this.flightUpdates,
    flightUpdatesError: clearFlightUpdatesError
        ? null
        : flightUpdatesError ?? this.flightUpdatesError,
  );

  @override
  List<Object?> get props => [
    status,
    data,
    error,
    flightUpdatesStatus,
    flightUpdates,
    flightUpdatesError,
  ];
}
