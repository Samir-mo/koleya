import 'package:gate_buddy/core/api/api_consumer.dart';
import 'package:gate_buddy/core/errors/error_handler.dart';
import 'package:gate_buddy/data/api/api_endpoints.dart';
import 'package:gate_buddy/features/indoor_map/data/models/map_service_model.dart';

class IndoorMapRemoteDs {
  final ApiConsumer api;

  IndoorMapRemoteDs({required this.api});

  Future<List<MapServiceModel>> getServices() async {
    try {
      final response = await api.get(ApiEndpoints.mapAllServices);

      final List data = response['data']['services'];

      return data.map((json) => MapServiceModel.fromJson(json)).toList();
    } catch (e) {
      throw ErrorHandler.handleFailure(e);
    }
  }
}
