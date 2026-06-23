import 'package:dio/dio.dart';
import 'package:gate_buddy/core/api/api_consumer.dart';

import '../../core/api/api_endpoints.dart';

/// NotificationsRepository — مسئول عن إدارة إشعارات المستخدم
class NotificationsRepository {
  final ApiConsumer api;

  NotificationsRepository({required this.api});

  /// 🔹 جلب كل الإشعارات غير المقروءة (GET /notifications)
  Future<Response> getNotifications() async {
    try {
      final response = await api.get(ApiEndpoints.notifications);
      return response;
    } on DioException catch (e) {
      final msg =
          e.response?.data?["message"] ??
          e.message ??
          "Failed to fetch notifications";
      throw Exception(msg);
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }

  /// 🔹 الاشتراك في إشعارات رحلة معينة (POST /notifications/subscribe)
  /// [flightId] رقم الرحلة - [channels] زي ["push", "email"]
  Future<Response> subscribeToFlight({
    required String flightId,
    required List<String> channels,
  }) async {
    try {
      final data = {"flightId": flightId, "channels": channels};
      final response = await api.post(
        ApiEndpoints.subscribeNotifications,
        body: data,
      );
      return response;
    } on DioException catch (e) {
      final msg =
          e.response?.data?["message"] ?? e.message ?? "Subscription failed";
      throw Exception(msg);
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }

  /// 🔹 تحديد إشعار كمقروء (PATCH /notifications/:id/read)
  Future<Response> markAsRead(String notificationId) async {
    try {
      final url = ApiEndpoints.readNotification.replaceAll(
        ":id",
        notificationId,
      );
      final response = await api.patch(url);
      return response;
    } on DioException catch (e) {
      final msg =
          e.response?.data?["message"] ??
          e.message ??
          "Failed to mark notification as read";
      throw Exception(msg);
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }
}
