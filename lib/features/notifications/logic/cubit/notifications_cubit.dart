import 'package:flutter_bloc/flutter_bloc.dart';
import 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(const NotificationsInitial());

  Future<void> loadNotifications() async {}
  Future<void> markAsRead(String id) async {}
}
