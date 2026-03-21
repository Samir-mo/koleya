import 'package:dio/dio.dart';
import '../api/api_client.dart';
import '../api/api_endpoints.dart';

/// SearchRepository — مسئول عن عمليات البحث الموحدة
class SearchRepository {
  final Dio _client = ApiClient.instance.dio;

  /// 🔹 البحث العام عن بيانات في (Flights / Services / Places ...)
  /// [query] النص الذي يُبحث عنه
  /// [types] قائمة تحدد أنواع البحث (مثلاً ["flights", "services"])
  Future<Response> search({
    required String query,
    List<String>? types,
  }) async {
    try {
      final queryParams = {
        "q": query,
        if (types != null && types.isNotEmpty)
          "types": types.join(","), // نجمعهم كـ comma-separated string
      };

      final response = await _client.get(
        ApiEndpoints.search,
        queryParameters: queryParams,
      );

      return response;
    } on DioException catch (e) {
      final msg =
          e.response?.data?["message"] ?? e.message ?? "Search request error";
      throw Exception(msg);
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }
}