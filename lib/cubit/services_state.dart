// import 'package:equatable/equatable.dart';
// import '../core/shared/models/service_model.dart';

// abstract class ServicesState extends Equatable {
//   @override
//   List<Object?> get props => [];
// }

// class ServicesInitial extends ServicesState {}

// class ServicesLoading extends ServicesState {}

// class ServicesLoaded extends ServicesState {
//   final List<ServiceModel> services;
//   ServicesLoaded(this.services); // ← بدون const

//   @override
//   List<Object?> get props => [services];
// }

// class ServicesError extends ServicesState {
//   final String message;
//   ServicesError(this.message); // ← بدون const

//   @override
//   List<Object?> get props => [message];
// }