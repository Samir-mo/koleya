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

      final response = await api.get(
        ApiEndpoints.services,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      final data = response.data;

      List<dynamic> raw = [];

      if (data is List) {
        raw = data;
      } else if (data is Map) {
        // { "data": { "services": [...] } }
        if (data['data'] is Map && data['data']['services'] is List) {
          raw = data['data']['services'] as List;
        }
        // { "data": [...] }
        else if (data['data'] is List) {
          raw = data['data'] as List;
        }
        // { "services": [...] }
        else if (data['services'] is List) {
          raw = data['services'] as List;
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
