import 'package:equatable/equatable.dart';

abstract class VerifyCodeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class VerifyCodeInitial extends VerifyCodeState {}

class VerifyCodeLoading extends VerifyCodeState {}

class VerifyCodeSuccess extends VerifyCodeState {
  final String message;
  VerifyCodeSuccess({this.message = "Code verified successfully!"});

  @override
  List<Object?> get props => [message];
}

class VerifyCodeFailure extends VerifyCodeState {
  final String error;
  VerifyCodeFailure(this.error);
  @override
  List<Object?> get props => [error];
}