import 'package:equatable/equatable.dart';

abstract class ResetPasswordState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ResetPasswordInitial extends ResetPasswordState {}

class ResetPasswordLoading extends ResetPasswordState {}

class ResetPasswordSuccess extends ResetPasswordState {
  final String message;
  ResetPasswordSuccess({this.message = "Password reset successful!"});

  @override
  List<Object?> get props => [message];
}

class ResetPasswordFailure extends ResetPasswordState {
  final String error;
  ResetPasswordFailure(this.error);

  @override
  List<Object?> get props => [error];
}