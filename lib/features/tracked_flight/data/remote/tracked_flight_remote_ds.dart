import 'package:gate_buddy/core/api/api_consumer.dart';
import 'package:gate_buddy/core/api/api_endpoints.dart';

class TrackedFlightRemoteDs {
  final ApiConsumer api;
  TrackedFlightRemoteDs({required this.api});

  Future<dynamic> getTrackedFlights() => api.get(ApiEndpoints.trackedFlights);
  Future<dynamic> trackFlight(String id) =>
      api.post(ApiEndpoints.trackFlight.replaceFirst(':id', id));
  Future<dynamic> untrackFlight(String id) =>
      api.delete(ApiEndpoints.untrackFlight.replaceFirst(':id', id));
}
