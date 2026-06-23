import 'package:dio/dio.dart';
import 'package:gate_buddy/core/api/api_consumer.dart';

import '../../core/api/api_endpoints.dart';

/// PlacesRepository — مسئول عن جلب بيانات الأماكن والمتاجر
class PlacesRepository {
  final ApiConsumer api;

  PlacesRepository({required this.api});

  /// 📥 جلب كل الأماكن (GET /places)
  /// يمكن تمرير استعلامات بحث أو فلترة كـ queryParameters
  Future<Response> getPlaces({Map<String, dynamic>? queryParams}) async {
    try {
      final response = await api.get(
        ApiEndpoints.places,
        queryParameters: queryParams,
      );
      return response;
    } on DioException catch (e) {
      final msg =
          e.response?.data?["message"] ?? e.message ?? "Get places error";
      throw Exception(msg);
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }

  /// 📋 جلب تفاصيل مكان محدد (GET /places/:id)
  Future<Response> getPlaceDetails(String id) async {
    try {
      final endpoint = "${ApiEndpoints.places}/$id";
      final response = await api.get(endpoint);
      return response;
    } on DioException catch (e) {
      final msg =
          e.response?.data?["message"] ??
          e.message ??
          "Get place details error";
      throw Exception(msg);
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }
}
