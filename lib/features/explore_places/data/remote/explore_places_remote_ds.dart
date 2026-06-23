import 'package:gate_buddy/core/api/api_consumer.dart';
import 'package:gate_buddy/core/api/api_endpoints.dart';
import 'package:gate_buddy/core/errors/error_handler.dart';

import '../models/place_of_service_model.dart';

class ExplorePlacesRemoteDs {
  final ApiConsumer api;

  ExplorePlacesRemoteDs({required this.api});

  Future<List<PlaceOfServiceModel>> getPlaces({String? category}) async {
    try {
      final query = category != null ? {'category': category} : null;

      final dynamic response = await api.get(
        ApiEndpoints.services,
        queryParameters: query,
      );

      List<dynamic> raw = [];
      if (response is List) {
        raw = response;
      } else if (response is Map) {
        raw =
            response['data']?['services'] as List? ??
            response['services'] as List? ??
            [];
      }

      return raw
          .map((e) => PlaceOfServiceModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      ErrorHandler.handleException(e);
    }
  }
}
