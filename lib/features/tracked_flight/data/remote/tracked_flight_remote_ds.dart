import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/data/base_remote_ds.dart';

class TrackedFlightRemoteDs with BaseRemoteDs {
  final ApiConsumer api;
  TrackedFlightRemoteDs({required this.api});

  Future<dynamic> getTrackedFlights() =>
      execute(() => api.get(ApiEndpoints.trackedFlights));

  Future<dynamic> trackFlight(String id, {String? boardingPassNumber}) =>
      execute(
        () => api.post(
          ApiEndpoints.trackFlight.replaceFirst(':id', id),
          body: boardingPassNumber != null
              ? {'boardingPassNumber': boardingPassNumber}
              : {},
        ),
      );

  Future<dynamic> untrackFlight(String id) => execute(
    () => api.delete(ApiEndpoints.untrackFlight.replaceFirst(':id', id)),
  );

  Future<dynamic> getFlightUpdates(String id) => execute(
    () => api.get(
      ApiEndpoints.flightUpdates.replaceFirst(':id', id),
      queryParameters: {'limit': 20},
    ),
  );

  Future<dynamic> getMyFlight() => execute(
    () => api.get(ApiEndpoints.myFlight),
  );
}
