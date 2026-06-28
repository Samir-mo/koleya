import 'package:gate_buddy/core/api/api_consumer.dart';
import 'package:gate_buddy/core/api/api_endpoints.dart';
import 'package:gate_buddy/core/errors/error_handler.dart';

class TrackedFlightRemoteDs {
  final ApiConsumer api;
  TrackedFlightRemoteDs({required this.api});

  Future<dynamic> getTrackedFlights() async {
    try {
      return await api.get(ApiEndpoints.trackedFlights);
    } catch (e) {
      ErrorHandler.handle(e);
    }
  }

  Future<dynamic> trackFlight(String id) async {
    try {
      return await api.post(ApiEndpoints.trackFlight.replaceFirst(':id', id));
    } catch (e) {
      ErrorHandler.handle(e);
    }
  }

  Future<dynamic> untrackFlight(String id) async {
    try {
      return await api.delete(ApiEndpoints.untrackFlight.replaceFirst(':id', id));
    } catch (e) {
      ErrorHandler.handle(e);
    }
  }
}
