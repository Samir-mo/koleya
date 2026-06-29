import 'package:gate_buddy/core/api/api_consumer.dart';
import 'package:gate_buddy/core/api/api_endpoints.dart';
import 'package:gate_buddy/core/data/base_remote_ds.dart';

import '../models/flight_model.dart';

class FlightsRemoteDs with BaseRemoteDs {
  final ApiConsumer api;

  FlightsRemoteDs({required this.api});

  Future<List<FlightModel>> getFlights({
    String? direction,
    String? status,
    int page = 1,
    int limit = 50,
  }) =>
      execute(() async {
        final params = <String, dynamic>{'page': page, 'limit': limit};
        if (direction != null) params['direction'] = direction;
        if (status != null) params['status'] = status;

        final response = await api.get(
          ApiEndpoints.flights,
          queryParameters: params,
        );
        return _parseFlightList(response);
      });

  Future<List<FlightModel>> getUpdatedFlights() =>
      execute(() async {
        final response = await api.get(
          ApiEndpoints.flightsUpdated,
          queryParameters: {'limit': 30, 'sort': '-updatedAt'},
        );
        return _parseFlightList(response);
      });

  Future<List<FlightModel>> searchFlights(String query) =>
      execute(() async {
        final response = await api.get(
          ApiEndpoints.flightsSearch,
          queryParameters: {'q': query},
        );
        return _parseFlightList(response);
      });

  Future<FlightModel> getFlightById(String id) =>
      execute(() async {
        final endpoint = ApiEndpoints.flightById.replaceAll(':id', id);
        final response = await api.get(endpoint);
        final data = response['data'] as Map<String, dynamic>;
        return FlightModel.fromJson(data['flight'] as Map<String, dynamic>);
      });

  Future<void> trackFlight(String id) =>
      execute(() async {
        final endpoint = ApiEndpoints.trackFlight.replaceAll(':id', id);
        await api.post(endpoint, body: {});
      });

  Future<void> untrackFlight(String id) =>
      execute(() async {
        final endpoint = ApiEndpoints.untrackFlight.replaceAll(':id', id);
        await api.delete(endpoint);
      });

  // Resolves all known response shapes from this backend:
  //   { data: { flights: [...] } }   — paginated list endpoint
  //   { data: { results: [...] } }   — search endpoint
  //   { data: { data: [...] } }      — Natours double-nesting
  //   { data: [...] }                — flat list
  static List<FlightModel> _parseFlightList(dynamic data) {
    if (data is! Map) return [];
    final body = data['data'];
    List<dynamic> raw = [];
    if (body is Map) {
      if (body['flights'] is List) {
        raw = body['flights'] as List;
      } else if (body['results'] is List) {
        raw = body['results'] as List;
      } else if (body['data'] is List) {
        raw = body['data'] as List;
      }
    } else if (body is List) {
      raw = body;
    }
    return raw
        .whereType<Map<String, dynamic>>()
        .map(FlightModel.fromJson)
        .toList();
  }
}
