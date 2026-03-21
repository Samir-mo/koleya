import 'package:equatable/equatable.dart';

abstract class FinancialState extends Equatable {
  const FinancialState();

  @override
  List<Object?> get props => [];
}

class FinancialInitial extends FinancialState {}

class FinancialLoading extends FinancialState {}

class FinancialLoaded extends FinancialState {
  final List<dynamic> services;
  const FinancialLoaded(this.services);

  @override
  List<Object?> get props => [services];
}

class FinancialError extends FinancialState {
  final String message;
  const FinancialError(this.message);

  @override
  List<Object?> get props => [message];
}