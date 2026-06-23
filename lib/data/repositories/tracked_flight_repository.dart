import 'package:dio/dio.dart';
import 'package:gate_buddy/core/api/api_consumer.dart';

import '../../core/api/api_endpoints.dart';

class TrackedFlightRepository {
  final ApiConsumer api;

  TrackedFlightRepository({required this.api});

  /// 📥 جلب تفاصيل الرحلة من السيرفر عبر رقم الرحلة
  Future<Response> getFlightDetails(String flightNo) async {
    try {
      final response = await api.get("${ApiEndpoints.flights}/$flightNo");
      return response;
    } on DioException catch (e) {
      final msg = e.response?.data?["message"] ?? e.message ?? "API error";
      throw Exception(msg);
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }
}
