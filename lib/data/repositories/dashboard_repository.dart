import 'package:dio/dio.dart';
import '../api/api_client.dart';
import '../api/api_endpoints.dart';

/// DashboardRepository — مسئول عن جلب بيانات الصفحة الرئيسية (Home)
class DashboardRepository {
  final Dio _client = ApiClient.instance.dio;

  /// 📥 جلب بيانات الـ Dashboard / Home من السيرفر
  ///
  /// - لو المستخدم مسجل دخول → بيرجع بياناته الشخصية + trackedFlight
  /// - لو مش مسجل → بيرجع بيانات عامة عن الرحلات والخدمات
  Future<Response> getHomeData() async {
    try {
      final response = await _client.get(ApiEndpoints.home);
      return response;
    } on DioException catch (e) {
      final msg = e.response?.data?["message"] ??
          e.message ??
          "Failed to fetch home data";
      throw Exception(msg);
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }

  /// 🆕 ميثود إضافية علشان تتوافق مع الكيوبت (alias)
  Future<Response> getDashboardData() => getHomeData();
}