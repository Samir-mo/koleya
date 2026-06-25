abstract class NotificationsRepo {
  Future<dynamic> getNotifications();
  Future<dynamic> markAsRead(String id);
}
