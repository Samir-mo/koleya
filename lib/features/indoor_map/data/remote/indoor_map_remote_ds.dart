import 'package:dio/dio.dart';
import 'package:gate_buddy/core/api/api_consumer.dart';

import '../../../../data/api/api_endpoints.dart';
import '../models/service_location_model.dart';

class IndoorMapRemoteDs {
  final ApiConsumer api;

  IndoorMapRemoteDs({required this.api});
  Future<List<ServiceLocationModel>> getServicesWithLocation({
    String? category,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (category != null && category.isNotEmpty) {
        queryParams['category'] = category;
      }

     // ApiConsumer.get returns dynamic — it IS the decoded body, not a Response object
      final dynamic response = await api.get(
        ApiEndpoints.services,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      List<dynamic> raw = [];

      if (response is List) {
        raw = response;
      } else if (response is Map) {
        // ✅ matches your actual shape: { "status": "success", "data": { "services": [...] } }
        if (response['data'] is Map && response['data']['services'] is List) {
          raw = response['data']['services'] as List;
        } else if (response['data'] is List) {
          raw = response['data'] as List;
        } else if (response['services'] is List) {
          raw = response['services'] as List;
        }
      }

      return raw
          .map((e) => ServiceLocationModel.fromJson(e as Map<String, dynamic>))
          // Only include items that have real coordinates
          .where((s) => s.latitude != 0.0 && s.longitude != 0.0)
          .toList();
    } on DioException catch (e) {
      final msg =
          e.response?.data?['message'] ?? e.message ?? 'Map services error';
      throw Exception(msg);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
