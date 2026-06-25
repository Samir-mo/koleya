import 'package:gate_buddy/core/api/api_consumer.dart';
import 'package:gate_buddy/core/api/api_endpoints.dart';

class NotificationsRemoteDs {
  final ApiConsumer api;
  NotificationsRemoteDs({required this.api});

  Future<dynamic> getNotifications() => api.get(ApiEndpoints.notifications);

  Future<dynamic> markAsRead(String id) => api.patch(
        ApiEndpoints.readNotification.replaceFirst(':id', id),
      );
}
