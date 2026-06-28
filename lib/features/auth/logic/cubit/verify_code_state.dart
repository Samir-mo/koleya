import 'package:equatable/equatable.dart';

enum VerifyCodeStatus { initial, loading, success, failure }

class VerifyCodeState extends Equatable {
  final VerifyCodeStatus status;
  final String? resetToken;
  final String? error;

  const VerifyCodeState({
    this.status = VerifyCodeStatus.initial,
    this.resetToken,
    this.error,
  });

  VerifyCodeState copyWith({
    VerifyCodeStatus? status,
    String? resetToken,
    String? error,
    bool clearError = false,
  }) =>
      VerifyCodeState(
        status: status ?? this.status,
        resetToken: resetToken ?? this.resetToken,
        error: clearError ? null : error ?? this.error,
      );

  bool get isLoading => status == VerifyCodeStatus.loading;

  @override
  List<Object?> get props => [status, resetToken, error];
}
