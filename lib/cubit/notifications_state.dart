import 'package:equatable/equatable.dart';
import '../../data/models/notification_model.dart';

abstract class NotificationsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NotificationsInitial extends NotificationsState {}

class NotificationsLoading extends NotificationsState {}

class NotificationsLoaded extends NotificationsState {
  final List<NotificationModel> notifications;
  NotificationsLoaded(this.notifications); // ← بدون const

  @override
  List<Object?> get props => [notifications];
}

class NotificationsError extends NotificationsState {
  final String message;
  NotificationsError(this.message); // ← بدون const

  @override
  List<Object?> get props => [message];
}