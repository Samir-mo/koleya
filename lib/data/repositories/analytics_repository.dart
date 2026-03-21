import 'package:dio/dio.dart';
import '../api/api_client.dart';
import '../api/api_endpoints.dart';

/// AnalyticsRepository — مسئول عن إرسال تتبع التحميلات والمشاهدات
class AnalyticsRepository {
  final Dio _client = ApiClient.instance.dio;

  /// 🔹 إرسال حدث عند الضغط على زر تحميل التطبيق
  ///
  /// [platform] : "ios" أو "android"
  /// [source] : مصدر الضغط (مثلاً "website", "app", "ad")
  /// [referrer] : الصفحة أو المكان اللي جه منه المستخدم
  Future<Response> sendDownloadClick({
    required String platform,
    required String source,
    required String referrer,
  }) async {
    try {
      final body = {
        "platform": platform,
        "source": source,
        "referrer": referrer,
      };

      final response = await _client.post(
        ApiEndpoints.analyticsDownloadClick,
        data: body,
      );
      return response;
    } on DioException catch (e) {
      final msg = e.response?.data?["message"] ?? e.message ?? "Download click error";
      throw Exception(msg);
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }

  /// 🔹 إرسال معلومات عن زيارة صفحة (page-view)
  ///
  /// [page] : اسم أو عنوان الصفحة
  /// [source] : مصدر الزيارة
  /// [duration] : المدة اللي قضاها المستخدم (بالثواني)
  Future<Response> sendPageView({
    required String page,
    required String source,
    required int duration,
  }) async {
    try {
      final body = {
        "page": page,
        "source": source,
        "duration": duration,
      };

      final response = await _client.post(
        ApiEndpoints.analyticsPageView,
        data: body,
      );
      return response;
    } on DioException catch (e) {
      final msg = e.response?.data?["message"] ?? e.message ?? "Page view analytics error";
      throw Exception(msg);
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }
}