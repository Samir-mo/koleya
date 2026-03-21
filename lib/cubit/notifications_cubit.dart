import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/notifications_repository.dart';
import '../../data/models/notification_model.dart';
import 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationsRepository _repo = NotificationsRepository();

  NotificationsCubit() : super(NotificationsInitial());

  Future<void> getNotifications() async {
    emit(NotificationsLoading());
    try {
      final response = await _repo.getNotifications();

      final data = response.data;
      List<NotificationModel> notifs = [];

      if (data is List) {
        notifs = data.map((e) => NotificationModel.fromJson(e)).toList();
      } else if (data is Map && data["data"] is List) {
        notifs =
            (data["data"] as List).map((e) => NotificationModel.fromJson(e)).toList();
      }

      emit(NotificationsLoaded(notifs));
    } catch (e) {
      emit(NotificationsError(e.toString()));
    }
  }
}