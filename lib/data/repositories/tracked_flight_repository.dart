import 'package:dio/dio.dart';
import '../api/api_client.dart';
import '../api/api_endpoints.dart';

class TrackedFlightRepository {
  final Dio _client = ApiClient.instance.dio;

  /// 📥 جلب تفاصيل الرحلة من السيرفر عبر رقم الرحلة
  Future<Response> getFlightDetails(String flightNo) async {
    try {
      final response =
          await _client.get("${ApiEndpoints.flights}/$flightNo");
      return response;
    } on DioException catch (e) {
      final msg = e.response?.data?["message"] ?? e.message ?? "API error";
      throw Exception(msg);
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }
}