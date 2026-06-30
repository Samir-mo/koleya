import 'package:equatable/equatable.dart';
import '../../data/models/home_model.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  final HomeStatus status;
  final HomeModel? data;
  final String? error;

  const HomeState({this.status = HomeStatus.initial, this.data, this.error});

  bool get isLoading => status == HomeStatus.loading;
  bool get isSuccess => status == HomeStatus.success;
  bool get isFailure => status == HomeStatus.failure;

  HomeState copyWith({
    HomeStatus? status,
    HomeModel? data,
    String? error,
    bool clearError = false,
  }) => HomeState(
    status: status ?? this.status,
    data: data ?? this.data,
    error: clearError ? null : error ?? this.error,
  );

  @override
  List<Object?> get props => [status, data, error];
}
