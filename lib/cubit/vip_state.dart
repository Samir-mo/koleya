import 'package:equatable/equatable.dart';

abstract class VipState extends Equatable {
  const VipState();

  @override
  List<Object?> get props => [];
}

class VipInitial extends VipState {}

class VipLoading extends VipState {}

class VipLoaded extends VipState {
  final List<dynamic> services;
  const VipLoaded(this.services);

  @override
  List<Object?> get props => [services];
}

class VipError extends VipState {
  final String message;
  const VipError(this.message);

  @override
  List<Object?> get props => [message];
}