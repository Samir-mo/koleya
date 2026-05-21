import 'package:dio/dio.dart';
import '../api/api_client.dart';
import '../api/api_endpoints.dart';
import '../../core/shared/models/service_model.dart';

/// 🇪🇬 AirportRepository مسؤول عن كل الطلبات المتعلقة بالمطار (الخدمات، الاستعلامات ...إلخ)
class AirportRepository {
  final Dio _client = ApiClient.instance.dio;

  /// 🛫 جلب قائمة الخدمات من الـ API مباشرة
  Future<List<ServiceModel>> getServices() async {
    try {
      // ✅ استدعاء الـ API الحقيقي
      final Response response = await _client.get(ApiEndpoints.services);

      // 🔍 التأكد إن البيانات القادمة عبارة عن List أو داخل "data"
      if (response.data is List) {
        // لو السيرفر بيرجع List مباشرة
        return (response.data as List)
            .map((e) => ServiceModel.fromJson(e))
            .toList();
      } else if (response.data is Map && response.data["data"] is List) {
        // أحيانًا السيرفر بيرجع { "data": [ ... ] }
        final List data = response.data["data"];
        return data.map((e) => ServiceModel.fromJson(e)).toList();
      } else {
        throw Exception("Invalid response format - expected a list");
      }

    } on DioException catch (e) {
      // ⚠️ معالجة أخطاء Dio (شبكة / رد غير صالح)
      final errorMessage =
          e.response?.data?["message"] ?? e.message ?? "Unknown API error";
      throw Exception("API Error: $errorMessage");

    } catch (e, stackTrace) {
      // ⚠️ أي أخطاء عامة أخرى
      // 👇 نضيف stackTrace لغرض الديباغ فقط (اختياري)
      print("Unexpected error in getServices: $e\n$stackTrace");
      throw Exception("Unexpected error: $e");
    }
  }
}