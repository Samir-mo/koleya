import '../../../flights/data/models/flight_model.dart';

abstract class TrackedFlightRepo {
  Future<List<FlightModel>> getTrackedFlights();
  Future<void> trackFlight(String id, {String? boardingPassNumber});
  Future<void> untrackFlight(String id);
  Future<List<FlightUpdateModel>> getFlightUpdates(String id);
}
