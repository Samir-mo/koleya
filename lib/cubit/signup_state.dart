import 'package:equatable/equatable.dart';

abstract class SignupState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SignupInitial extends SignupState {}

class SignupLoading extends SignupState {}

class SignupSuccess extends SignupState {
  final String message;
  SignupSuccess({this.message = "Account created successfully"}); // ← بدون const

  @override
  List<Object?> get props => [message];
}

class SignupFailure extends SignupState {
  final String error;
  SignupFailure(this.error); // ← بدون const

  @override
  List<Object?> get props => [error];
}