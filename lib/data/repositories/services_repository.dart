import 'package:dio/dio.dart';
import '../api/api_client.dart';
import '../api/api_endpoints.dart';

/// ServicesRepository — مسئول عن جلب بيانات الخدمات داخل المطار
class ServicesRepository {
  final Dio _client = ApiClient.instance.dio;

  /// 📥 جلب قائمة الخدمات (يدعم البحث والتصفية عبر query parameters)
  Future<Response> getServices({Map<String, dynamic>? queryParams}) async {
    try {
      final response = await _client.get(
        ApiEndpoints.services,
        queryParameters: queryParams,
      );
      return response;
    } on DioException catch (e) {
      final err = e.response?.data?["message"] ?? e.message ?? "Failed to fetch services";
      throw Exception(err);
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }

  /// 📋 جلب تفاصيل خدمة معينة (GET /services/:id)
  Future<Response> getServiceById(String id) async {
    try {
      final url = ApiEndpoints.serviceById.replaceAll(":id", id);
      final response = await _client.get(url);
      return response;
    } on DioException catch (e) {
      final err = e.response?.data?["message"] ?? e.message ?? "Failed to fetch service details";
      throw Exception(err);
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }

  /// 📍 جلب موقع الخدمة (GET /services/:id/location)
  Future<Response> getServiceLocation(String id) async {
    try {
      final url = ApiEndpoints.serviceLocation.replaceAll(":id", id);
      final response = await _client.get(url);
      return response;
    } on DioException catch (e) {
      final err = e.response?.data?["message"] ?? e.message ?? "Failed to fetch service location";
      throw Exception(err);
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }

  /// 👑 جلب جميع الـ VIP Lounges (GET /services/vip-lounges)
  Future<Response> getVipLounges() async {
    try {
      final response = await _client.get(ApiEndpoints.vipLounges);
      return response;
    } on DioException catch (e) {
      final err = e.response?.data?["message"] ?? e.message ?? "Failed to fetch VIP lounges";
      throw Exception(err);
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }

  /// 👑 جلب VIP Lounge معين عبر الـ ID (GET /services/vip-lounges/:id)
  Future<Response> getVipLoungeById(String id) async {
    try {
      final url = ApiEndpoints.vipLoungeById.replaceAll(":id", id);
      final response = await _client.get(url);
      return response;
    } on DioException catch (e) {
      final err = e.response?.data?["message"] ?? e.message ?? "Failed to fetch VIP lounge details";
      throw Exception(err);
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }
}