import 'package:equatable/equatable.dart';

enum ForgetPasswordStatus { initial, loading, success, failure }

class ForgetPasswordState extends Equatable {
  final ForgetPasswordStatus status;
  final String? error;

  const ForgetPasswordState({
    this.status = ForgetPasswordStatus.initial,
    this.error,
  });

  ForgetPasswordState copyWith({
    ForgetPasswordStatus? status,
    String? error,
    bool clearError = false,
  }) => ForgetPasswordState(
    status: status ?? this.status,
    error: clearError ? null : error ?? this.error,
  );

  bool get isLoading => status == ForgetPasswordStatus.loading;

  @override
  List<Object?> get props => [status, error];
}
