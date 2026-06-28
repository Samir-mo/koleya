import 'package:gate_buddy/core/api/api_consumer.dart';
import 'package:gate_buddy/core/api/api_endpoints.dart';
import 'package:gate_buddy/core/data/base_remote_ds.dart';

class TrackedFlightRemoteDs with BaseRemoteDs {
  final ApiConsumer api;
  TrackedFlightRemoteDs({required this.api});

  Future<dynamic> getTrackedFlights() =>
      execute(() => api.get(ApiEndpoints.trackedFlights));

  Future<dynamic> trackFlight(String id) =>
      execute(() => api.post(ApiEndpoints.trackFlight.replaceFirst(':id', id)));

  Future<dynamic> untrackFlight(String id) =>
      execute(() => api.delete(ApiEndpoints.untrackFlight.replaceFirst(':id', id)));
}
