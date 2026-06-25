import 'package:gate_buddy/core/api/api_consumer.dart';
import 'package:gate_buddy/core/api/api_endpoints.dart';

class FlightsRemoteDs {
  final ApiConsumer api;
  FlightsRemoteDs({required this.api});

  Future<dynamic> getFlights() => api.get(ApiEndpoints.flights);
  Future<dynamic> getUpdatedFlights() => api.get(ApiEndpoints.flightsUpdated);
  Future<dynamic> searchFlights(String query) =>
      api.get(ApiEndpoints.flightsSearch, queryParameters: {'q': query});
}
