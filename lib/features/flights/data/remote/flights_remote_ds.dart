import 'package:gate_buddy/core/api/api_consumer.dart';
import 'package:gate_buddy/core/api/api_endpoints.dart';
import 'package:gate_buddy/core/errors/error_handler.dart';

import '../models/flight_model.dart';

class FlightsRemoteDs {
  final ApiConsumer api;

  FlightsRemoteDs({required this.api});

  Future<List<FlightModel>> getFlights({
    String? direction,
    String? status,
    int page = 1,
    int limit = 50,
  }) async {
    try {
      final params = <String, dynamic>{'page': page, 'limit': limit};
      if (direction != null) params['direction'] = direction;
      if (status != null) params['status'] = status;

      final response = await api.get(
        ApiEndpoints.flights,
        queryParameters: params,
      );
      return _parseFlightList(response);
    } catch (e) {
      ErrorHandler.handleException(e);
    }
  }

  Future<List<FlightModel>> getUpdatedFlights() async {
    try {
      final response = await api.get(
        ApiEndpoints.flightsUpdated,
        queryParameters: {'limit': 30, 'sort': '-updatedAt'},
      );
      return _parseFlightList(response);
    } catch (e) {
      ErrorHandler.handleException(e);
    }
  }

  Future<List<FlightModel>> searchFlights(String query) async {
    try {
      final response = await api.get(
        ApiEndpoints.flightsSearch,
        queryParameters: {'q': query},
      );
      return _parseFlightList(response);
    } catch (e) {
      ErrorHandler.handleException(e);
    }
  }

  Future<FlightModel> getFlightById(String id) async {
    try {
      final endpoint = ApiEndpoints.flightById.replaceAll(':id', id);
      final response = await api.get(endpoint);
      final data = response['data'] as Map<String, dynamic>;
      return FlightModel.fromJson(data['flight'] as Map<String, dynamic>);
    } catch (e) {
      ErrorHandler.handleException(e);
    }
  }

  Future<void> trackFlight(String id) async {
    try {
      final endpoint = ApiEndpoints.trackFlight.replaceAll(':id', id);
      await api.post(endpoint, body: {});
    } catch (e) {
      ErrorHandler.handleException(e);
    }
  }

  Future<void> untrackFlight(String id) async {
    try {
      final endpoint = ApiEndpoints.untrackFlight.replaceAll(':id', id);
      await api.delete(endpoint);
    } catch (e) {
      ErrorHandler.handleException(e);
    }
  }

  static List<FlightModel> _parseFlightList(dynamic data) {
    if (data is! Map) return [];
    final body = data['data'];
    List<dynamic> raw = [];
    if (body is Map && body['flights'] is List) {
      raw = body['flights'] as List;
    } else if (body is List) {
      raw = body;
    }
    return raw
        .map((e) => FlightModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
